class PaypalCreateOrderResult {
  final bool success;
  final int wooCommerceOrderId;
  final String paypalOrderId;
  final String approvalUrl;
  final String paypalStatus;
  final bool reused;
  final String message;

  const PaypalCreateOrderResult({
    required this.success,
    required this.wooCommerceOrderId,
    required this.paypalOrderId,
    required this.approvalUrl,
    required this.paypalStatus,
    required this.reused,
    required this.message,
  });

  factory PaypalCreateOrderResult.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaypalCreateOrderResult(
      success: json['success'] == true,
      wooCommerceOrderId:
      int.tryParse(
        json['wc_order_id']
            ?.toString() ??
            '0',
      ) ??
          0,
      paypalOrderId:
      json['orderID']
          ?.toString() ??
          '',
      approvalUrl:
      json['approveUrl']
          ?.toString() ??
          '',
      paypalStatus:
      json['paypal_status']
          ?.toString() ??
          '',
      reused: json['reused'] == true,
      message:
      json['message']
          ?.toString() ??
          '',
    );
  }
}