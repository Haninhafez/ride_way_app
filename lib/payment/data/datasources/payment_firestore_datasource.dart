import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';

import '../../domain/entities/payment_method.dart';
import '../models/payment_model.dart';

class PaymentFirestoreDataSource {
  final FirebaseFirestore _db;
  const PaymentFirestoreDataSource(this._db);

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('payments');

  Future<String> createPending({
    required String userId,
    required int amountEgp,
    required PaymentMethodType method,
  }) async {
    final ref = await _col.add(PaymentModel.newPendingMap(
      userId: userId,
      amountEgp: amountEgp,
      method: method,
    ));
    return ref.id;
  }

  Future<void> updateStatus(String id, PaymentStatus status) {
    return _col.doc(id).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<PaymentModel>> watch(String userId) {
    return _col.where('userId', isEqualTo: userId).snapshots().map((snap) {
      final list = snap.docs.map(PaymentModel.fromDoc).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }
}
