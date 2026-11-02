import 'dart:developer';

import 'package:ride_way_app/core/error/failures.dart';
import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_record.dart';
import '../../domain/entities/payment_session.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_firestore_datasource.dart';
import '../datasources/paymob_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymobRemoteDataSource _paymob;
  final PaymentFirestoreDataSource _firestore;

  const PaymentRepositoryImpl(this._paymob, this._firestore);

  @override
  Future<PaymentSession> startPayment({
    required String userId,
    required int amountEgp,
    required PaymentMethodType method,
    String? walletPhone,
  }) async {
    if (method == PaymentMethodType.vodafoneCash &&
        (walletPhone == null || walletPhone.isEmpty)) {
      throw const PaymentFailure('رقم المحفظة مطلوب');
    }

    final id = await _firestore.createPending(
      userId: userId,
      amountEgp: amountEgp,
      method: method,
    );

    try {
      final url = switch (method) {
        PaymentMethodType.creditCard => await _paymob.getCardUrl(amountEgp),
        PaymentMethodType.vodafoneCash => await _paymob.getWalletUrl(
          amountEgp,
          walletPhone!,
        ),

        PaymentMethodType.cashAtStation => throw UnimplementedError(),
      };
      log('Payment URL: $url');
      return PaymentSession(paymentId: id, url: url, amountEgp: amountEgp);
    } catch (e) {
      await _firestore.updateStatus(id, PaymentStatus.error);
      if (e is PaymentFailure) rethrow;
      log('Payment Failure: $e');
      throw PaymentFailure(e.toString());
    }
  }

  @override
  Future<void> updateStatus(String paymentId, PaymentStatus status) {
    return _firestore.updateStatus(paymentId, status);
  }

  @override
  Stream<List<PaymentRecord>> watchPayments(String userId) {
    return _firestore.watch(userId);
  }
}
