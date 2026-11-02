class PaymobConfig {
  static const baseUrl = 'https://accept.paymob.com/api';


  static const apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRJME16YzBNaXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5neG1MaWpKZDhMTzBhS3NYOG9tSk9FemM3a0tWTlpHZTdjZURvbzdGdkxhNTVFYVZybURKYTY0TzVJeUdXNkdzSS1UYmNSeExFYm8yTHBfaVlUbi1BZw==';

  static const cardIntegrationId = 5988989;
  static const walletIntegrationId = int.fromEnvironment(
    'PAYMOB_WALLET_INTEGRATION_ID',
  );
  static const iframeId = 1087966;
}
