import '../models/booking_dto.dart';

abstract class TripsLocalDataSource {
  Future<void> cacheBookings(List<BookingDTO> bookings);
  Future<List<BookingDTO>> getCachedBookings();
  Future<BookingDTO?> getCachedBooking(String bookingIdOrRef);
}

class TripsLocalDataSourceImpl implements TripsLocalDataSource {
  final Map<String, BookingDTO> _cache = {};

  @override
  Future<void> cacheBookings(List<BookingDTO> bookings) async {
    for (final b in bookings) {
      _cache[b.id] = b;
      _cache[b.bookingRef] = b;
    }
  }

  @override
  Future<List<BookingDTO>> getCachedBookings() async {
    return _cache.values.toSet().toList();
  }

  @override
  Future<BookingDTO?> getCachedBooking(String bookingIdOrRef) async {
    return _cache[bookingIdOrRef];
  }
}
