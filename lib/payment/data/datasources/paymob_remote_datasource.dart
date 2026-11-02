import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ride_way_app/core/error/failures.dart';

import '../../../../../../core/config/paymob_config.dart';

abstract class PaymobRemoteDataSource {
  Future<String> getCardUrl(int amountEgp);

  Future<String> getWalletUrl(int amountEgp, String phone);
}

class PaymobRemoteDataSourceImpl implements PaymobRemoteDataSource {
  final http.Client _client;
  const PaymobRemoteDataSourceImpl(this._client);

  Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> body) async {
    final res = await _client.post(
      Uri.parse('${PaymobConfig.baseUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode >= 400) {
      throw PaymentFailure('Paymob ${res.statusCode}: ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<String> _getPaymentToken(int amountEgp, int integrationId) async {
    final cents = amountEgp * 100;

    final auth = await _post('/auth/tokens', {'api_key': PaymobConfig.apiKey});
    final authToken = auth['token'];

    final order = await _post('/ecommerce/orders', {
      'auth_token': authToken,
      'delivery_needed': false,
      'amount_cents': cents,
      'currency': 'EGP',
      'items': [],
    });

    final key = await _post('/acceptance/payment_keys', {
      'auth_token': authToken,
      'amount_cents': cents,
      'expiration': 3600,
      'order_id': order['id'],
      'currency': 'EGP',
      'integration_id': integrationId,
      'billing_data': {
        'first_name': 'Test',
        'last_name': 'User',
        'email': 'test@example.com',
        'phone_number': '01000000000',
        'apartment': 'NA',
        'floor': 'NA',
        'street': 'NA',
        'building': 'NA',
        'shipping_method': 'NA',
        'postal_code': 'NA',
        'city': 'NA',
        'country': 'EG',
        'state': 'NA',
      },
    });
    return key['token'] as String;
  }

  @override
  Future<String> getCardUrl(int amountEgp) async {
    final token =
        await _getPaymentToken(amountEgp, PaymobConfig.cardIntegrationId);
    return '${PaymobConfig.baseUrl}/acceptance/iframes/'
        '${PaymobConfig.iframeId}?payment_token=$token';
  }

  @override
  Future<String> getWalletUrl(int amountEgp, String phone) async {
    if (PaymobConfig.walletIntegrationId == 0) {
      throw const PaymentFailure(
          'ضيفي PAYMOB_WALLET_INTEGRATION_ID (Mobile Wallet integration)');
    }
    final token =
        await _getPaymentToken(amountEgp, PaymobConfig.walletIntegrationId);

    final res = await _post('/acceptance/payments/pay', {
      'source': {'identifier': phone, 'subtype': 'WALLET'},
      'payment_token': token,
    });

    final url = res['redirect_url'] ?? res['iframe_redirection_url'];
    if (url == null) {
      throw const PaymentFailure('Paymob ماردتش برابط الدفع بالمحفظة');
    }
    return url as String;
  }
}

