import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_record.dart';

class PaymentModel extends PaymentRecord {
  const PaymentModel({
    required super.id,
    required super.userId,
    required super.amountEgp,
    required super.method,
    required super.status,
    required super.createdAt,
  });

  factory PaymentModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return PaymentModel(
      id: doc.id,
      userId: d['userId'] as String,
      amountEgp: d['amountEgp'] as int,
      method: PaymentMethodType.values.byName(d['method'] as String),
      status: PaymentStatus.values.byName(d['status'] as String),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> newPendingMap({
    required String userId,
    required int amountEgp,
    required PaymentMethodType method,
  }) {
    return {
      'userId': userId,
      'amountEgp': amountEgp,
      'method': method.name,
      'status': PaymentStatus.loading.name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
