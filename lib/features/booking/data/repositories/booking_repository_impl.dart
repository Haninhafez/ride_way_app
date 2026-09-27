import '../../domain/entities/booking_summary.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/train_detail.dart';
import '../../domain/entities/travel_class.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_data_source.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/passenger_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final BookingLocalDataSource localDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<TrainDetail> getTrainDetails(String trainId) {
    return remoteDataSource.fetchTrainDetails(trainId);
  }

  @override
  Future<List<Seat>> getSeatsForCoach(String trainId, String coachNumber) {
    return remoteDataSource.fetchSeatsForCoach(trainId, coachNumber);
  }

  @override
  Future<BookingSummary> calculateBookingSummary({
    required TravelClass selectedClass,
    required List<Seat> selectedSeats,
    required int passengerCount,
  }) {
    final basePrice = selectedClass.price;
    return remoteDataSource.calculateSummary(
      basePrice: basePrice,
      passengerCount: passengerCount,
    );
  }

  @override
  Future<bool> validatePassengers({
    required List<Passenger> passengers,
    required String email,
    required String phone,
  }) async {
    if (email.isEmpty || !email.contains('@')) return false;
    if (phone.isEmpty || phone.length < 7) return false;
    for (final p in passengers) {
      if (p.fullName.trim().isEmpty) return false;
      if (p.nationalIdOrPassport.trim().isEmpty) return false;
    }
    final models = passengers
        .map((p) => PassengerModel(
              passengerId: p.passengerId,
              index: p.index,
              fullName: p.fullName,
              nationalIdOrPassport: p.nationalIdOrPassport,
              assignedSeat: p.assignedSeat,
            ))
        .toList();
    await localDataSource.saveDraftPassengers(models);
    return true;
  }

  @override
  Future<bool> processPayment({
    required BookingSummary summary,
    required PaymentMethod paymentMethod,
    String? cvv,
  }) {
    return remoteDataSource.processPaymentTransaction();
  }
}
