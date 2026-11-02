import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_summary.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/train_detail.dart';
import '../../domain/entities/travel_class.dart';

enum BookingStatus {
  initial,
  loading,
  trainLoaded,
  seatsLoaded,
  passengersValidated,
  paymentProcessing,
  ticketSaved,
  paymentSuccess,
  error,
}

class BookingState extends Equatable {
  final BookingStatus status;
  final String? errorMessage;
  final TrainDetail? trainDetail;
  final TravelClass? selectedClass;
  final int passengerCount;
  final String selectedCoachNumber;
  final List<Seat> coachSeats;
  final List<Seat> selectedSeats;
  final List<Passenger> passengers;
  final String contactEmail;
  final String contactPhone;
  final bool saveTravellers;
  final int holdTimerSeconds;
  final bool isHoldTimerRunning;
  final BookingSummary? summary;
  final PaymentMethodType selectedPaymentMethod;
  final String ?bookingId;

  final int expandedPassengerIndex;

  const BookingState({
    this.status = BookingStatus.initial,
    this.errorMessage,
    this.trainDetail,
    this.selectedClass,
    this.passengerCount = 1,
    this.selectedCoachNumber = '',
    this.coachSeats = const [],
    this.selectedSeats = const [],
    this.passengers = const [],
    this.contactEmail = '',
    this.contactPhone = '',
    this.saveTravellers = true,
    this.holdTimerSeconds = 522, 
    this.isHoldTimerRunning = true,
    this.summary,
    this.selectedPaymentMethod = PaymentMethodType.creditCard,

    this.expandedPassengerIndex = 0,  this.bookingId ="",
  });

  String get formattedHoldTime {
    final minutes = (holdTimerSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (holdTimerSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  BookingState copyWith({
    BookingStatus? status,
    String? errorMessage,
    TrainDetail? trainDetail,
    TravelClass? selectedClass,
    int? passengerCount,
    String? selectedCoachNumber,
    List<Seat>? coachSeats,
    List<Seat>? selectedSeats,
    List<Passenger>? passengers,
    String? contactEmail,
    String? contactPhone,
    bool? saveTravellers,
    int? holdTimerSeconds,
    bool? isHoldTimerRunning,
    BookingSummary? summary,
    PaymentMethodType? selectedPaymentMethod,
    bool clearError = false, 
    int? expandedPassengerIndex,
    String? bookingId,
  }) {
    return BookingState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      trainDetail: trainDetail ?? this.trainDetail,
      selectedClass: selectedClass ?? this.selectedClass,
      passengerCount: passengerCount ?? this.passengerCount,
      selectedCoachNumber: selectedCoachNumber ?? this.selectedCoachNumber,
      coachSeats: coachSeats ?? this.coachSeats,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      passengers: passengers ?? this.passengers,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      saveTravellers: saveTravellers ?? this.saveTravellers,
      holdTimerSeconds: holdTimerSeconds ?? this.holdTimerSeconds,
      isHoldTimerRunning: isHoldTimerRunning ?? this.isHoldTimerRunning,
      summary: summary ?? this.summary,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      expandedPassengerIndex:
          expandedPassengerIndex ?? this.expandedPassengerIndex, bookingId: bookingId??" 0",
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    trainDetail,
    selectedClass,
    passengerCount,
    selectedCoachNumber,
    coachSeats,
    selectedSeats,
    passengers,
    contactEmail,
    contactPhone,
    saveTravellers,
    holdTimerSeconds,
    isHoldTimerRunning,
    summary,
    selectedPaymentMethod,

    expandedPassengerIndex,
  ];
}
