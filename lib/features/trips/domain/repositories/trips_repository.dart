import '../entities/booking.dart';
import '../entities/ticket_share.dart';

abstract class TripsRepository {
  Future<List<Booking>> getMyBookings();
  Future<Booking?> getBookingDetail(String bookingIdOrRef);
  Future<Booking?> getDigitalTicket(String bookingIdOrRef);
  Future<bool> cancelBooking(String bookingIdOrRef);

  Future<String> createShareLink(String bookingId);

  Future<void> revokeShareLink(String bookingId);

  Future<ResolveShareResult> resolveShare(String token);
}
