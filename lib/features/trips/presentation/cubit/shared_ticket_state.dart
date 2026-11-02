import 'package:equatable/equatable.dart';
import '../../domain/entities/ticket_share.dart';

enum SharedTicketStatus {
  initial,
  loading,
  found,
  notFound,
  expired,
  revoked,
  networkError,
}

class SharedTicketState extends Equatable {
  final SharedTicketStatus status;
  final TicketShare? ticketShare;
  final String? errorMessage;

  const SharedTicketState({
    this.status = SharedTicketStatus.initial,
    this.ticketShare,
    this.errorMessage,
  });

  SharedTicketState copyWith({
    SharedTicketStatus? status,
    TicketShare? ticketShare,
    String? errorMessage,
  }) {
    return SharedTicketState(
      status: status ?? this.status,
      ticketShare: ticketShare ?? this.ticketShare,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, ticketShare, errorMessage];
}
