  import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking.dart';
import '../../domain/entities/ticket_share.dart';
import '../models/ticket_share_dto.dart';

class TicketShareFirestoreDataSource {
  final FirebaseFirestore firestore;

  static const _collection = 'ticketShares';

  TicketShareFirestoreDataSource(this.firestore);


  static String _generateToken() {
    final rng = Random.secure();
    final bytes = List<int>.generate(18, (_) => rng.nextInt(256));
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    final sb = StringBuffer();
    for (int i = 0; i + 2 < bytes.length; i += 3) {
      final b0 = bytes[i];
      final b1 = bytes[i + 1];
      final b2 = bytes[i + 2];
      sb
        ..write(alphabet[(b0 >> 2) & 0x3F])
        ..write(alphabet[((b0 << 4) | (b1 >> 4)) & 0x3F])
        ..write(alphabet[((b1 << 2) | (b2 >> 6)) & 0x3F])
        ..write(alphabet[b2 & 0x3F]);
    }
    return sb.toString().substring(0, 22);
  }


  static DateTime _calcExpiry(String travelDateStr) {
    final inSevenDays = DateTime.now().add(const Duration(days: 7));
    final travel = DateTime.tryParse(travelDateStr);
    if (travel == null) return inSevenDays;
    final dayAfterTravel = travel.add(const Duration(days: 1));
    return dayAfterTravel.isAfter(inSevenDays) ? dayAfterTravel : inSevenDays;
  }


  Future<String> createShareLink(Booking booking, String ownerUid) async {
    final existing = await firestore
        .collection(_collection)
        .where('bookingId', isEqualTo: booking.id)
        .where('ownerUid', isEqualTo: ownerUid)
        .where('revoked', isEqualTo: false)
        .limit(5)
        .get();

    final now = DateTime.now();
    for (final doc in existing.docs) {
      final dto = TicketShareDTO.fromFirestore(doc.id, doc.data());
      if (!dto.isExpired) return dto.token;
    }

    final token = _generateToken();
    final seatNumbers = booking.passengers.map((p) => p.seatNumber).join(', ');
    final maskedName = booking.passengers.isNotEmpty
        ? TicketShareDTO.maskName(booking.passengers.first.passengerName)
        : '';

    final dto = TicketShareDTO(
      token: token,
      bookingId: booking.id,
      ownerUid: ownerUid,
      createdAt: now,
      expiresAt: _calcExpiry(
          '${booking.travelDate.year}-${booking.travelDate.month.toString().padLeft(2, '0')}-${booking.travelDate.day.toString().padLeft(2, '0')}'),
      revoked: false,
      originCode: booking.origin,
      originName: booking.originName,
      destinationCode: booking.destination,
      destinationName: booking.destinationName,
      travelDate:
          '${booking.travelDate.year}-${booking.travelDate.month.toString().padLeft(2, '0')}-${booking.travelDate.day.toString().padLeft(2, '0')}',
      departureTime: booking.departureTime,
      arrivalTime: booking.arrivalTime,
      trainCode: booking.trainCode,
      trainName: booking.trainName,
      coach: booking.coach,
      seatNumbers: seatNumbers,
      bookingStatus: booking.status.name,
      paymentStatus: _derivePaymentStatus(booking.paymentSummary.paymentMethod),
      maskedPassengerName: maskedName,
    );

    await firestore
        .collection(_collection)
        .doc(token)
        .set(dto.toFirestore());

    return token;
  }

  Future<void> revokeShareLink(String bookingId, String ownerUid) async {
    final snap = await firestore
        .collection(_collection)
        .where('bookingId', isEqualTo: bookingId)
        .where('ownerUid', isEqualTo: ownerUid)
        .where('revoked', isEqualTo: false)
        .get();

    final batch = firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'revoked': true});
    }
    await batch.commit();
  }

  Future<ResolveShareResult> resolveShare(String token) async {
    try {
      final doc = await firestore.collection(_collection).doc(token).get();
      if (!doc.exists || doc.data() == null) return const ShareNotFound();

      final dto = TicketShareDTO.fromFirestore(doc.id, doc.data()!);
      if (dto.revoked) return const ShareRevoked();
      if (dto.isExpired) return const ShareExpired();
      return ShareFound(dto);
    } on FirebaseException catch (e) {
      return ShareNetworkError(e.message ?? 'Firestore error');
    } catch (e) {
      return ShareNetworkError(e.toString());
    }
  }


  static String _derivePaymentStatus(String methodLabel) {
    final lower = methodLabel.toLowerCase();
    if (lower.contains('cash') || lower.contains('station')) {
      return 'pay_at_station';
    }
    return 'paid';
  }
}
