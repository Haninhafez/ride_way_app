import '../../domain/entities/booking.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_local_data_source.dart';
import '../datasources/trips_remote_data_source.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripsRemoteDataSource remoteDataSource;
  final TripsLocalDataSource localDataSource;

  TripsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Booking>> getMyBookings() async {
    try {
      final remote = await remoteDataSource.fetchMyBookings();
      await localDataSource.cacheBookings(remote);
      return remote;
    } catch (_) {
      return await localDataSource.getCachedBookings();
    }
  }

  @override
  Future<Booking?> getBookingDetail(String bookingIdOrRef) async {
    try {
      final remote = await remoteDataSource.fetchBookingDetail(bookingIdOrRef);
      if (remote != null) {
        await localDataSource.cacheBookings([remote]);
      }
      return remote;
    } catch (_) {
      return await localDataSource.getCachedBooking(bookingIdOrRef);
    }
  }

  @override
  Future<Booking?> getDigitalTicket(String bookingIdOrRef) async {
    return await getBookingDetail(bookingIdOrRef);
  }

  @override
  Future<bool> cancelBooking(String bookingIdOrRef) {
    return remoteDataSource.cancelBookingTransaction(bookingIdOrRef);
  }
}
