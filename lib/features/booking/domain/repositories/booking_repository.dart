import '../entities/train_detail.dart';
import '../entities/travel_class.dart';
import '../entities/seat.dart';
import '../entities/passenger.dart';
import '../entities/booking_summary.dart';
import '../entities/payment_method.dart';

abstract class BookingRepository {
  Future<TrainDetail> getTrainDetails(String trainId);
  Future<List<Seat>> getSeatsForCoach(String trainId, String coachNumber);
  Future<BookingSummary> calculateBookingSummary({
    required TravelClass selectedClass,
    required List<Seat> selectedSeats,
    required int passengerCount,
  });
  Future<bool> validatePassengers({
    required List<Passenger> passengers,
    required String email,
    required String phone,
  });
  Future<bool> processPayment({
    required BookingSummary summary,
    required PaymentMethod paymentMethod,
    String? cvv,
  });
}
