import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';

import '../models/booking_dto.dart';
import '../models/notification_dto.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/trip_notification.dart';

import '../../../../core/database/api/api_end_points.dart';

abstract class TripsRemoteDataSource {
  Future<List<BookingDTO>> fetchMyBookings();

  Future<BookingDTO?> fetchBookingDetail(String bookingIdOrRef);

  Future<bool> cancelBookingTransaction(String bookingIdOrRef);

  Future<List<NotificationDTO>> fetchNotifications();

  Future<void> markNotificationRead(String id);
}

class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  final FirebaseFirestore firestore;

  TripsRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _bookings =>
      firestore.collection('bookings');

  String get _userId {
    final id = CacheHelper.getData(ApiKeys.id);

    if (id == null || id.toString().isEmpty) {
      throw Exception('User is not logged in');
    }

    return id.toString();
  }

  @override
  Future<List<BookingDTO>> fetchMyBookings() async {
    final snapshot = await _bookings.where('userId', isEqualTo: _userId).get();

    final bookings = snapshot.docs.map((doc) {
      return BookingDTO.fromJson({...doc.data(), 'id': doc.id});
    }).toList();

    bookings.sort((a, b) => b.travelDate.compareTo(a.travelDate));
    log("Bookings in fetchbooking Detailes $bookings");
    return bookings;
  }

  @override
  Future<BookingDTO?> fetchBookingDetail(String bookingIdOrRef) async {
    final bookings = firestore.collection('bookings');
    final id = bookingIdOrRef.trim();

    final doc = await bookings.doc(id).get();
    log('Doc ${doc.data()}');

    if (doc.exists && doc.data() != null) {
      log("Found by Document ID: ${doc.data()}");
      return BookingDTO.fromJson({...doc.data()!, 'id': doc.id});
    }

    final result = await bookings
        .where('id', isEqualTo: bookingIdOrRef)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      log("Booking not found by ID or reference: $bookingIdOrRef");
      return null;
    }

    final ticket = result.docs.first;
    log("Found by reference field: ${ticket.data()}");

    return BookingDTO.fromJson({...ticket.data(), 'id': ticket.id});
  }

  @override
  Future<bool> cancelBookingTransaction(String bookingIdOrRef) async {
    final booking = await fetchBookingDetail(bookingIdOrRef);

    if (booking == null || booking.status == BookingStatusType.cancelled) {
      return false;
    }

    await _bookings.doc(booking.id).update({'status': 'cancelled'});

    return true;
  }

  @override
  Future<List<NotificationDTO>> fetchNotifications() async {
    final snapshot = await firestore.collection('notifications').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final rawTimestamp = data['timestamp'] ?? data['createdAt'];

      DateTime timestamp;

      if (rawTimestamp is Timestamp) {
        timestamp = rawTimestamp.toDate();
      } else if (rawTimestamp is DateTime) {
        timestamp = rawTimestamp;
      } else if (rawTimestamp is String) {
        timestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
      } else {
        timestamp = DateTime.now();
      }

      final type = NotificationType.values.firstWhere(
        (value) =>
            value.name.toLowerCase() == data['type']?.toString().toLowerCase(),
        orElse: () => NotificationType.confirmation,
      );

      return NotificationDTO(
        id: doc.id,
        type: type,
        title: data['title']?.toString() ?? '',
        message: data['message']?.toString() ?? '',
        timestamp: timestamp,
        isUnread: data['isUnread'] as bool? ?? true,
      );
    }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> markNotificationRead(String id) async {
    final docRef = firestore.collection('notifications').doc(id);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final data = doc.data();

    if (data == null || data['userId']?.toString() != _userId) {
      return;
    }

    if (data['isUnread'] == false) return;

    await docRef.update({'isUnread': false});
  }
}
