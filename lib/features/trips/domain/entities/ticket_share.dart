import 'package:equatable/equatable.dart';

class TicketShare extends Equatable {
  final String token;
  final String bookingId;
  final String ownerUid;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool revoked;

  final String originCode;
  final String originName;
  final String destinationCode;
  final String destinationName;
  final String travelDate;        
  final String departureTime;
  final String arrivalTime;
  final String trainCode;
  final String trainName;
  final String coach;
  final String seatNumbers;       
  final String bookingStatus;     
  final String paymentStatus;     
  final String maskedPassengerName; 

  const TicketShare({
    required this.token,
    required this.bookingId,
    required this.ownerUid,
    required this.createdAt,
    required this.expiresAt,
    required this.revoked,
    required this.originCode,
    required this.originName,
    required this.destinationCode,
    required this.destinationName,
    required this.travelDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.trainCode,
    required this.trainName,
    required this.coach,
    required this.seatNumbers,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.maskedPassengerName,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [token, bookingId, revoked, expiresAt];
}

sealed class ResolveShareResult {
  const ResolveShareResult();
}

class ShareFound extends ResolveShareResult {
  final TicketShare share;
  const ShareFound(this.share);
}

class ShareNotFound extends ResolveShareResult {
  const ShareNotFound();
}

class ShareExpired extends ResolveShareResult {
  const ShareExpired();
}

class ShareRevoked extends ResolveShareResult {
  const ShareRevoked();
}

class ShareNetworkError extends ResolveShareResult {
  final String message;
  const ShareNetworkError(this.message);
}
