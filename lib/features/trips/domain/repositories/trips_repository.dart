import '../entities/booking.dart';

abstract class TripsRepository {
  Future<List<Booking>> getMyBookings();
  Future<Booking?> getBookingDetail(String bookingIdOrRef);
  Future<Booking?> getDigitalTicket(String bookingIdOrRef);
  Future<bool> cancelBooking(String bookingIdOrRef);
}
