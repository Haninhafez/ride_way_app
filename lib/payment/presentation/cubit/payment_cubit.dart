
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';
import 'package:ride_way_app/payment/domain/entities/payment_session.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/confirm_payment.dart';
import '../../domain/usecases/start_payment.dart';
import 'payment_state.dart';



class PaymentCubit extends Cubit<PaymentState> {
  final StartPayment _startPayment;
  final ConfirmPayment _confirmPayment;

  PaymentCubit({
    required StartPayment startPayment,
    required ConfirmPayment confirmPayment,
  })  : _startPayment = startPayment,
        _confirmPayment = confirmPayment,
        super(const PaymentState());

  Future<void> pay({
    required String userId,
    required int amountEgp,
    required PaymentMethodType method,
    String? walletPhone,
  }) async {
    emit(
      state.copyWith(
        status: PaymentStatus.loading,
        amountEgp: amountEgp,
        clearError: true,
        clearSession: true,
      ),
    );

    try {
      final session = await _startPayment(
  userId: userId,
  amountEgp: amountEgp,
  method: method,
  walletPhone: walletPhone,
);

      emit(
        state.copyWith(
          status: PaymentStatus.awaitingUser,
          session: session,
        ),
      );
    
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> confirm(
    PaymentSession session,
    bool paid,
  ) async {
    if (!paid) {
      emit(
        state.copyWith(
          status: PaymentStatus.error,
          errorMessage: 'تم إلغاء عملية الدفع أو لم تكتمل',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PaymentStatus.loading,
        clearError: true,
      ),
    );

    try {
      await _confirmPayment(
        session.paymentId,
      paid ? PaymentStatus.success : PaymentStatus.error,
      );

      emit(
        state.copyWith(
          status: PaymentStatus.success,
          amountEgp: state.amountEgp,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
