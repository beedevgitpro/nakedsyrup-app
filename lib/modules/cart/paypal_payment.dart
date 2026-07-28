import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service.dart';

class PaypalWebView extends StatefulWidget {
  final String approvalUrl;
  final String orderID;

  const PaypalWebView({
    super.key,
    required this.approvalUrl,
    required this.orderID,
  });

  @override
  State<PaypalWebView> createState() => _PaypalWebViewState();
}

class _PaypalWebViewState extends State<PaypalWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) async {
                final url = request.url;

                print("URL: $url");

                if (url.contains("paypal-success") || url.contains("return")) {
                  await ApiClass().capturePaypal(widget.orderID);

                  Navigator.pop(context, {"status": "success"});
                  return NavigationDecision.prevent;
                }

                if (url.contains("paypal-cancel") || url.contains("cancel")) {
                  Navigator.pop(context, {"status": "cancel"});
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PayPal Checkout")),
      body: WebViewWidget(controller: controller),
    );
  }
}
