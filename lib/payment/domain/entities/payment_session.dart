class PaymentSession {
  final String paymentId;
  final String url;
  final int amountEgp;

  const PaymentSession({
    required this.paymentId,
    required this.url,
    required this.amountEgp,
  });
}
