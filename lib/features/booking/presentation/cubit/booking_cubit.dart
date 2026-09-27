import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Timer? _holdTimer;

  BookingCubit({
    required this.getTrainDetailsUseCase,
    required this.selectSeatUseCase,
    required this.validatePassengersUseCase,
    required this.processPaymentUseCase,
  }) : super(const BookingState());

  @override
  Future<void> close() {
    _holdTimer?.cancel();
    return super.close();
  }

  Future<void> loadTrainDetails(String trainId) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final train = await getTrainDetailsUseCase.execute(trainId);

      // Business class default as per wireframe
      final businessClass = train.classOptions.firstWhere(
        (c) => c.id == 'business',
        orElse: () => train.classOptions.first,
      );

      final initialPassengers = [
        const Passenger(
          passengerId: 'p1',
          index: 1,
          fullName: 'Nasser Al-Harbi',
          nationalIdOrPassport: '1084920491',
        ),
        const Passenger(
          passengerId: 'p2',
          index: 2,
          fullName: 'Layla Al-Harbi',
          nationalIdOrPassport: '1092837492',
        ),
      ];

      // Initial default seats: 12A and 12B in Coach 3
      const seat12A = Seat(
        seatNumber: '12A',
        coachNumber: '3',
        isOccupied: false,
        price: 265.0,
        type: SeatType.window,
      );
      const seat12B = Seat(
        seatNumber: '12B',
        coachNumber: '3',
        isOccupied: false,
        price: 265.0,
        type: SeatType.aisle,
      );

      final selectedSeats = [seat12A, seat12B];
      final updatedPassengers = [
        initialPassengers[0].copyWith(assignedSeat: seat12A),
        initialPassengers[1].copyWith(assignedSeat: seat12B),
      ];

      final seats = await selectSeatUseCase.getSeatsForCoach(train.id, '3');

      emit(state.copyWith(
        status: BookingStatus.trainLoaded,
        trainDetail: train,
        selectedClass: businessClass,
        selectedCoachNumber: '3',
        coachSeats: seats,
        passengerCount: 2,
        selectedSeats: selectedSeats,
        passengers: updatedPassengers,
      ));

      await _calculateSummary();
      _startHoldTimer();
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void selectTravelClass(TravelClass travelClass) {
    emit(state.copyWith(
      selectedClass: travelClass,
      selectedCoachNumber: travelClass.defaultCoachNumber,
    ));
    loadSeatsForCoach(travelClass.defaultCoachNumber);
    _calculateSummary();
  }

  Future<void> loadSeatsForCoach(String coachNumber) async {
    if (state.trainDetail == null) return;
    try {
      final seats = await selectSeatUseCase.getSeatsForCoach(
        state.trainDetail!.id,
        coachNumber,
      );
      emit(state.copyWith(
        selectedCoachNumber: coachNumber,
        coachSeats: seats,
        status: BookingStatus.seatsLoaded,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void toggleSeatSelection(Seat seat) {
    if (seat.isOccupied) return;

    final currentSelected = List<Seat>.from(state.selectedSeats);
    final seatIndex = currentSelected.indexWhere(
      (s) => s.seatNumber == seat.seatNumber && s.coachNumber == seat.coachNumber,
    );

    if (seatIndex >= 0) {
      // Unselect
      currentSelected.removeAt(seatIndex);
    } else {
      // Select seat if within passenger count limit, else replace last
      if (currentSelected.length < state.passengerCount) {
        currentSelected.add(seat);
      } else {
        currentSelected.removeLast();
        currentSelected.add(seat);
      }
    }

    // Re-assign seats to passengers
    final updatedPassengers = List<Passenger>.from(state.passengers);
    for (int i = 0; i < updatedPassengers.length; i++) {
      if (i < currentSelected.length) {
        updatedPassengers[i] = updatedPassengers[i].copyWith(assignedSeat: currentSelected[i]);
      } else {
        updatedPassengers[i] = updatedPassengers[i].copyWith(assignedSeat: null);
      }
    }

    emit(state.copyWith(
      selectedSeats: currentSelected,
      passengers: updatedPassengers,
    ));

    _calculateSummary();
  }

  void updatePassengerInfo(int index, {String? fullName, String? nationalIdOrPassport}) {
    if (index < 0 || index >= state.passengers.length) return;
    final list = List<Passenger>.from(state.passengers);
    list[index] = list[index].copyWith(
      fullName: fullName ?? list[index].fullName,
      nationalIdOrPassport: nationalIdOrPassport ?? list[index].nationalIdOrPassport,
    );
    emit(state.copyWith(passengers: list));
  }

  void togglePassengerExpanded(int index) {
    emit(state.copyWith(
      expandedPassengerIndex: state.expandedPassengerIndex == index ? -1 : index,
    ));
  }

  void updateContactInfo({String? email, String? phone, bool? saveTravellers}) {
    emit(state.copyWith(
      contactEmail: email ?? state.contactEmail,
      contactPhone: phone ?? state.contactPhone,
      saveTravellers: saveTravellers ?? state.saveTravellers,
    ));
  }

  void selectPaymentMethod(PaymentMethodType type) {
    emit(state.copyWith(selectedPaymentMethod: type));
  }

  void updateCvv(String cvv) {
    emit(state.copyWith(cardCvv: cvv));
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
      emit(state.copyWith(
        status: BookingStatus.error,
        errorMessage: 'Please fill in all required passenger and contact details.',
      ));
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
      cvv: state.cardCvv,
    );

    if (success) {
      emit(state.copyWith(status: BookingStatus.paymentSuccess));
      return true;
    } else {
      emit(state.copyWith(
        status: BookingStatus.error,
        errorMessage: 'Payment processing failed. Please try again.',
      ));
      return false;
    }
  }

  String _getPaymentMethodLabel(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.mada:
        return 'Mada •••• 4417';
      case PaymentMethodType.applePay:
        return 'Apple Pay';
      case PaymentMethodType.creditCard:
        return 'Credit / Debit Card';
      case PaymentMethodType.cashAtStation:
        return 'Pay Cash at Station';
    }
  }
}
