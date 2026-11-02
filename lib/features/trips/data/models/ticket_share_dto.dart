import '../../domain/entities/ticket_share.dart';

class TicketShareDTO extends TicketShare {
  const TicketShareDTO({
    required super.token,
    required super.bookingId,
    required super.ownerUid,
    required super.createdAt,
    required super.expiresAt,
    required super.revoked,
    required super.originCode,
    required super.originName,
    required super.destinationCode,
    required super.destinationName,
    required super.travelDate,
    required super.departureTime,
    required super.arrivalTime,
    required super.trainCode,
    required super.trainName,
    required super.coach,
    required super.seatNumbers,
    required super.bookingStatus,
    required super.paymentStatus,
    required super.maskedPassengerName,
  });

  factory TicketShareDTO.fromFirestore(
      String docId, Map<String, dynamic> map) {
    return TicketShareDTO(
      token: docId,
      bookingId: (map['bookingId'] as String?) ?? '',
      ownerUid: (map['ownerUid'] as String?) ?? '',
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? '') ??
          DateTime.now(),
      expiresAt: DateTime.tryParse((map['expiresAt'] as String?) ?? '') ??
          DateTime.now(),
      revoked: (map['revoked'] as bool?) ?? false,
      originCode: (map['originCode'] as String?) ?? '',
      originName: (map['originName'] as String?) ?? '',
      destinationCode: (map['destinationCode'] as String?) ?? '',
      destinationName: (map['destinationName'] as String?) ?? '',
      travelDate: (map['travelDate'] as String?) ?? '',
      departureTime: (map['departureTime'] as String?) ?? '',
      arrivalTime: (map['arrivalTime'] as String?) ?? '',
      trainCode: (map['trainCode'] as String?) ?? '',
      trainName: (map['trainName'] as String?) ?? '',
      coach: (map['coach'] as String?) ?? '',
      seatNumbers: (map['seatNumbers'] as String?) ?? '',
      bookingStatus: (map['bookingStatus'] as String?) ?? 'upcoming',
      paymentStatus: (map['paymentStatus'] as String?) ?? 'pending',
      maskedPassengerName: (map['maskedPassengerName'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'bookingId': bookingId,
        'ownerUid': ownerUid,
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'revoked': revoked,
        'originCode': originCode,
        'originName': originName,
        'destinationCode': destinationCode,
        'destinationName': destinationName,
        'travelDate': travelDate,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'trainCode': trainCode,
        'trainName': trainName,
        'coach': coach,
        'seatNumbers': seatNumbers,
        'bookingStatus': bookingStatus,
        'paymentStatus': paymentStatus,
        'maskedPassengerName': maskedPassengerName,
      };

  static String maskName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    final first = parts.first;
    final lastInitial =
        parts.length > 1 ? '${parts.last[0].toUpperCase()}.' : '';
    return lastInitial.isNotEmpty ? '$first $lastInitial' : first;
  }

  @override
  String toString() {
    final preview = token.length > 8 ? '${token.substring(0, 8)}…' : token;
    return 'TicketShareDTO(token: $preview, '
        'booking: $bookingId, revoked: $revoked, expires: $expiresAt)';
  }
}
