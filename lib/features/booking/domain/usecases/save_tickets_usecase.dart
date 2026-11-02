import 'package:ride_way_app/features/booking/domain/entities/booking_summary.dart';
import 'package:ride_way_app/features/booking/domain/entities/train_detail.dart';
import 'package:ride_way_app/features/booking/domain/entities/travel_class.dart';
import 'package:ride_way_app/features/booking/domain/repositories/booking_repository.dart';

class SaveTicketsUsecase {
  final BookingRepository bookingRepository;

  SaveTicketsUsecase({required this.bookingRepository});

  Future<String> execute({
    required TrainDetail train,
    required TravelClass selectedClass,
    required int passangers,
    required String selectedCoachNumber,
    required BookingSummary booking,
  }) async {
    final bookingId = await bookingRepository.bookingTicket(
      train: train,
      selectedClass: selectedClass,
      passangers: passangers,
      selectedCoachNumber: selectedCoachNumber,
      booking: booking,
    );
    return bookingId;
  }
}
