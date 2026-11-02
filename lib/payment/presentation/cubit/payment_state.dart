
import 'package:equatable/equatable.dart';
import 'package:ride_way_app/payment/domain/entities/payment_method.dart';

import '../../domain/entities/payment_session.dart';


class PaymentState extends Equatable {
  final PaymentStatus status;
  final PaymentSession? session;
  final int? amountEgp;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.session,
    this.amountEgp,
    this.errorMessage,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentSession? session,
    int? amountEgp,
    String? errorMessage,
    bool clearSession = false,
    bool clearAmount = false,
    bool clearError = false,
  }) {
    return PaymentState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      amountEgp: clearAmount ? null : amountEgp ?? this.amountEgp,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        session,
        amountEgp,
        errorMessage,
      ];
}
