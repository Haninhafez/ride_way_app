import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/di/injecation.dart';
import 'package:ride_way_app/features/booking/data/models/travel_class_dto.dart';
import 'package:ride_way_app/features/booking/domain/entities/booking_summary.dart';
import 'package:ride_way_app/features/booking/domain/usecases/save_tickets_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_cubit.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/travel_class.dart';
import '../../domain/usecases/get_train_details_usecase.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import '../../domain/usecases/select_seat_usecase.dart';
import '../../domain/usecases/validate_passengers_usecase.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetTrainDetailsUseCase getTrainDetailsUseCase;
  final SelectSeatUseCase selectSeatUseCase;
  final ValidatePassengersUseCase validatePassengersUseCase;
  final ProcessPaymentUseCase processPaymentUseCase;
  final SaveTicketsUsecase saveTicketsUsecase;

  Timer? _holdTimer;

  BookingCubit({
    required this.getTrainDetailsUseCase,
    required this.selectSeatUseCase,
    required this.validatePassengersUseCase,
    required this.processPaymentUseCase,
    required this.saveTicketsUsecase,
  }) : super(const BookingState());

  @override
  Future<void> close() {
    _holdTimer?.cancel();
    return super.close();
  }

  Future<void> loadUserData() async {
    final email = await CacheHelper.getData(ApiKeys.email);
    final phone = await CacheHelper.getData(ApiKeys.phone);
    if (email == null || phone == null) {
      final getUser = await sl<FirebaseFirestore>()
          .collection('users')
          .doc(CacheHelper.getData(ApiKeys.id))
          .get();
      final getUserData = getUser.data();
      if (isClosed) return;
      emit(
        state.copyWith(
          contactEmail: getUserData?[ApiKeys.email] ?? '',
          contactPhone: getUserData?[ApiKeys.phone] ?? '',
        ),
      );
    }
    emit(state.copyWith(contactEmail: email ?? '', contactPhone: phone ?? ''));
  }

  Future<void> loadTrainDetails(String trainId) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final train = await getTrainDetailsUseCase.execute(trainId);

      final businessClass = train.classOptions.firstWhere(
        (c) => c.id == 'business',
        orElse: () => train.classOptions.first as TravelClassDTO,
      );

      final seats = await selectSeatUseCase.getSeatsForCoach(
        train.id,
        '3',
        businessClass.id,
        classPrice: businessClass.price,
      );
      final passengers = sl<SearchCubit>().state.passengerCount;
      log('passengers=$passengers');

      emit(
        state.copyWith(
          status: BookingStatus.trainLoaded,
          trainDetail: train,
          selectedClass: businessClass,
          selectedCoachNumber: '3',
          coachSeats: seats,
          passengerCount: passengers,
        ),
      );

      await _calculateSummary();
      _startHoldTimer();
    } catch (e) {
      emit(
        state.copyWith(status: BookingStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void selectClass(TravelClass travelClass) {
    selectTravelClass(travelClass);
  }

  void selectTravelClass(TravelClass travelClass) {
    final resetPassengers = state.passengers
        .map((p) => p.copyWith(assignedSeat: null))
        .toList();

    emit(
      state.copyWith(
        selectedClass: travelClass,
        selectedCoachNumber: travelClass.defaultCoachNumber,
        selectedSeats: const [],
        passengers: resetPassengers,
      ),
    );
    loadSeatsForCoach(travelClass.defaultCoachNumber);
    _calculateSummary();
  }

  Future<void> loadSeatsForCoach(String coachNumber) async {
    if (state.trainDetail == null || state.selectedClass == null) return;
    try {
      final seats = await selectSeatUseCase.getSeatsForCoach(
        state.trainDetail!.id,
        coachNumber,
        state.selectedClass!.id,
        classPrice: state.selectedClass!.price,
      );
      emit(
        state.copyWith(
          selectedCoachNumber: coachNumber,
          coachSeats: seats,
          status: BookingStatus.seatsLoaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(
      state.copyWith(
        status: BookingStatus.initial, 
        clearError: true, 
      ),
    );
  }

  void toggleSeatSelection(Seat seat) {
    if (isClosed || seat.isOccupied) return;

    final currentSelected = List<Seat>.from(state.selectedSeats);
    final seatIndex = currentSelected.indexWhere(
      (s) =>
          s.seatNumber == seat.seatNumber && s.coachNumber == seat.coachNumber,
    );

    if (seatIndex >= 0) {
      currentSelected.removeAt(seatIndex);
    } else {
      if (currentSelected.length < state.passengerCount) {
        currentSelected.add(seat);
      } else {
        currentSelected.removeLast();
        currentSelected.add(seat);
      }
    }

    final updatedPassengers = List<Passenger>.from(state.passengers);
    for (int i = 0; i < updatedPassengers.length; i++) {
      if (i < currentSelected.length) {
        updatedPassengers[i] = updatedPassengers[i].copyWith(
          assignedSeat: currentSelected[i],
        );
      } else {
        updatedPassengers[i] = updatedPassengers[i].copyWith(
          assignedSeat: null,
        );
      }
    }
    if (isClosed) return;
    emit(
      state.copyWith(
        selectedSeats: currentSelected,
        passengers: updatedPassengers,
      ),
    );

    _calculateSummary();
  }

  void updatePassengerInfo(int index, {String? fullName, String? phone}) {
    if (index < 0 || index >= state.passengers.length) return;
    final list = List<Passenger>.from(state.passengers);
    list[index] = list[index].copyWith(
      fullName: fullName ?? list[index].fullName,
      nationalIdOrPassport: phone ?? list[index].nationalIdOrPassport,
    );
    emit(state.copyWith(passengers: list));
  }

  void togglePassengerExpanded(int index) {
    emit(
      state.copyWith(
        expandedPassengerIndex: state.expandedPassengerIndex == index
            ? -1
            : index,
      ),
    );
  }

  void updateContactInfo({String? email, String? phone, bool? saveTravellers}) {
    emit(
      state.copyWith(
        contactEmail: email ?? state.contactEmail,
        contactPhone: phone ?? state.contactPhone,
        saveTravellers: saveTravellers ?? state.saveTravellers,
      ),
    );
  }

  void selectPaymentMethod(PaymentMethodType type) {
    emit(state.copyWith(selectedPaymentMethod: type));
  }

  Future<void> _calculateSummary() async {
    if (state.selectedClass == null) return;
    final repository = processPaymentUseCase.repository;
    final summary = await repository.calculateBookingSummary(
      selectedClass: state.selectedClass!,
      selectedSeats: state.selectedSeats,
      passengerCount: state.passengerCount,
    );
    emit(state.copyWith(summary: summary));
  }

  void _startHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.holdTimerSeconds > 0) {
        emit(state.copyWith(holdTimerSeconds: state.holdTimerSeconds - 1));
      } else {
        timer.cancel();
        emit(state.copyWith(isHoldTimerRunning: false));
      }
    });
  }

  Future<bool> validatePassengersAndProceed() async {
    emit(state.copyWith(status: BookingStatus.loading));
    final isValid = await validatePassengersUseCase.execute(
      passengers: state.passengers,
      email: state.contactEmail,
      phone: state.contactPhone,
    );

    if (isValid) {
      emit(state.copyWith(status: BookingStatus.passengersValidated));
      return true;
    } else {
      emit(
        state.copyWith(
          status: BookingStatus.error,
          errorMessage:
              'Please fill in all required passenger and contact details.',
        ),
      );
      return false;
    }
  }

  Future<bool> saveBookingTicket() async {
    try {
      emit(state.copyWith(status: BookingStatus.loading));

      if (state.trainDetail == null ||
          state.selectedClass == null ||
          state.summary == null) {
        emit(
          state.copyWith(
            status: BookingStatus.error,
            errorMessage: 'Missing train or booking details.',
          ),
        );
        return false;
      }

      final userId = CacheHelper.getData(ApiKeys.id) ?? '';
      if (userId.isEmpty) {
        emit(
          state.copyWith(
            status: BookingStatus.error,
            errorMessage: 'User not authenticated.',
          ),
        );
        return false;
      }

      final passengersList = state.passengers
          .map(
            (p) => {
              'passengerName': p.fullName,
              'passengerId': p.passengerId,
              'nationalIdOrPassport': p.nationalIdOrPassport,
              'seatNumber': p.assignedSeat?.seatNumber ?? '1',
            },
          )
          .toList();

      final bookingSummary = BookingSummary(
        subtotal: state.summary!.subtotal,
        seatReservationFee: state.summary!.seatReservationFee,
        serviceFee: state.summary!.serviceFee,
        vat: state.summary!.vat,
        grandTotal: state.summary!.grandTotal,
      );

      final bookingId = await saveTicketsUsecase.execute(
        train: state.trainDetail!,
        selectedClass: state.selectedClass!,
        passangers: state.passengerCount,
        selectedCoachNumber: state.selectedCoachNumber,
        booking: bookingSummary,
      );
      log("Bookin Id in Cubit : $bookingId");
      emit(
        state.copyWith(status: BookingStatus.ticketSaved, bookingId: bookingId),
      ); 
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: BookingStatus.error,
          errorMessage: 'Failed to save ticket: ${e.toString()}',
        ),
      );
      return false;
    }
  }

  Future<bool> processPayment() async {
    if (state.summary == null) return false;
    emit(state.copyWith(status: BookingStatus.paymentProcessing));

    final paymentMethod = PaymentMethod(
      type: state.selectedPaymentMethod,
      cardLast4: '4417',
      expiryDate: '09/28',
      label: _getPaymentMethodLabel(state.selectedPaymentMethod),
    );

    final success = await processPaymentUseCase.execute(
      summary: state.summary!,
      paymentMethod: paymentMethod,
    );

    if (success) {
      emit(state.copyWith(status: BookingStatus.paymentSuccess));
      return true;
    } else {
      emit(
        state.copyWith(
          status: BookingStatus.error,
          errorMessage: 'Payment processing failed. Please try again.',
        ),
      );
      return false;
    }
  }

  String _getPaymentMethodLabel(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.vodafoneCash:
        return 'Vodafone Cash';
      case PaymentMethodType.creditCard:
        return 'Credit / Debit Card';
      case PaymentMethodType.cashAtStation:
        return 'Pay Cash at Station';
    }
  }
}
