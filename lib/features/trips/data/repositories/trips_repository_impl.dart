import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/booking.dart';
import '../../domain/entities/ticket_share.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/ticket_share_firestore_datasource.dart';
import '../datasources/trips_local_data_source.dart';
import '../datasources/trips_remote_data_source.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripsRemoteDataSource remoteDataSource;
  final TripsLocalDataSource localDataSource;
  final TicketShareFirestoreDataSource shareDataSource;

  TripsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.shareDataSource,
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
      log('Searching ticket with: $bookingIdOrRef');

      final remote = await remoteDataSource.fetchBookingDetail(bookingIdOrRef);

      log('Ticket found: $remote');

      if (remote != null) {
        await localDataSource.cacheBookings([remote]);
        return remote;
      }

      return await localDataSource.getCachedBooking(bookingIdOrRef);
    } catch (e, stackTrace) {
      log('Get booking error: $e');
      log(stackTrace.toString());

      return await localDataSource.getCachedBooking(bookingIdOrRef);
    }
  }

  @override
  Future<Booking?> getDigitalTicket(String bookingIdOrRef) =>
      getBookingDetail(bookingIdOrRef);

  @override
  Future<bool> cancelBooking(String bookingIdOrRef) async {
    final success = await remoteDataSource.cancelBookingTransaction(
      bookingIdOrRef,
    );

    if (success) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        try {
          await shareDataSource.revokeShareLink(bookingIdOrRef, uid);
        } catch (_) {}
      }
    }
    return success;
  }


  @override
  Future<String> createShareLink(String bookingId) async {
    final booking = await getBookingDetail(bookingId);
    if (booking == null) throw Exception('Booking not found: $bookingId');

    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    return shareDataSource.createShareLink(booking, uid);
  }

  @override
  Future<void> revokeShareLink(String bookingId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await shareDataSource.revokeShareLink(bookingId, uid);
  }

  @override
  Future<ResolveShareResult> resolveShare(String token) =>
      shareDataSource.resolveShare(token);
}
