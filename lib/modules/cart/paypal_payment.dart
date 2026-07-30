import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service.dart';

class PaypalWebView extends StatefulWidget {
  final String approvalUrl;
  final String paypalOrderId;
  final int wooCommerceOrderId;

  const PaypalWebView({
    super.key,
    required this.approvalUrl,
    required this.paypalOrderId,
    required this.wooCommerceOrderId,
  });

  @override
  State<PaypalWebView> createState() =>
      _PaypalWebViewState();
}

class _PaypalWebViewState extends State<PaypalWebView> {
  late final WebViewController controller;

  bool _isFinishingPayment = false;
  bool _pageLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) {
              return;
            }

            setState(() {
              _pageLoading = true;
            });
          },
          onPageFinished: (_) {
            if (!mounted) {
              return;
            }

            setState(() {
              _pageLoading = false;
            });
          },
          onWebResourceError: (error) {
            /*
             * Do not report an error after we have already intercepted
             * the success URL and started capture.
             */
            if (
            !mounted ||
                _isFinishingPayment
            ) {
              return;
            }

            debugPrint(
              'PayPal WebView error: '
                  '${error.errorCode} '
                  '${error.description}',
            );
          },
          onNavigationRequest:
          _handleNavigationRequest,
        ),
      )
      ..loadRequest(
        Uri.parse(widget.approvalUrl),
      );
  }

  Future<NavigationDecision>
  _handleNavigationRequest(
      NavigationRequest request,
      ) async {
    final Uri? uri = Uri.tryParse(request.url);

    if (uri == null) {
      return NavigationDecision.navigate;
    }

    debugPrint(
      'PayPal navigation: $uri',
    );

    if (_isPaypalSuccessUrl(uri)) {
      if (!_isFinishingPayment) {
        _isFinishingPayment = true;

        /*
         * Prevent PayPal's return page from loading while capture
         * is completed by the WordPress backend.
         */
        Future.microtask(
          _captureApprovedPayment,
        );
      }

      return NavigationDecision.prevent;
    }

    if (_isPaypalCancelUrl(uri)) {
      if (!_isFinishingPayment) {
        _isFinishingPayment = true;

        Future.microtask(() {
          if (!mounted) {
            return;
          }

          Navigator.of(context).pop({
            'status': 'cancelled',
            'wc_order_id':
            widget.wooCommerceOrderId,
            'orderID': widget.paypalOrderId,
          });
        });
      }

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  bool _isPaypalSuccessUrl(Uri uri) {
    final String host = uri.host.toLowerCase();
    final String path =
    uri.path.toLowerCase().replaceAll(
      RegExp(r'/+$'),
      '',
    );

    final bool correctHost =
        host == 'www.nakedsyrups.com.au' ||
            host == 'nakedsyrups.com.au';

    return correctHost &&
        path == '/paypal-success';
  }

  bool _isPaypalCancelUrl(Uri uri) {
    final String host = uri.host.toLowerCase();
    final String path =
    uri.path.toLowerCase().replaceAll(
      RegExp(r'/+$'),
      '',
    );

    final bool correctHost =
        host == 'www.nakedsyrups.com.au' ||
            host == 'nakedsyrups.com.au';

    return correctHost &&
        path == '/paypal-cancel';
  }

  Future<void> _captureApprovedPayment() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _pageLoading = true;
      _errorMessage = null;
    });

    final Map<String, dynamic>? capture =
    await ApiClass().capturePaypalOrder(
      wooCommerceOrderId:
      widget.wooCommerceOrderId,
      paypalOrderId: widget.paypalOrderId,
    );

    if (!mounted) {
      return;
    }

    if (capture == null) {
      _showCaptureFailure(
        'No response was received while confirming the payment.',
      );
      return;
    }

    final bool success =
        capture['success'] == true;

    final String status =
        capture['status']
            ?.toString()
            .toUpperCase() ??
            '';

    final bool completed =
        success && status == 'COMPLETED';

    /*
     * The backend can also return already_paid=true when an app retry
     * happens after the webhook or a previous request completed.
     */
    final bool alreadyPaid =
        success &&
            capture['already_paid'] == true;

    final bool alreadyCaptured =
        success &&
            capture['already_captured'] == true;

    if (
    completed ||
        alreadyPaid ||
        alreadyCaptured
    ) {
      Navigator.of(context).pop({
        'status': 'success',
        'wc_order_id':
        widget.wooCommerceOrderId,
        'orderID': widget.paypalOrderId,
        'transaction_id':
        capture['transaction_id'],
        'order_status':
        capture['order_status'],
        'capture': capture,
      });

      return;
    }

    final String code =
        capture['code']?.toString() ?? '';

    if (
    code ==
        'PAYPAL_ORDER_NOT_APPROVED'
    ) {
      _showCaptureFailure(
        'PayPal has not confirmed the approval yet. Please return to PayPal and complete the payment.',
        allowRetry: true,
      );

      return;
    }

    if (
    code ==
        'PAYPAL_CAPTURE_AMOUNT_MISMATCH' ||
        code ==
            'PAYPAL_CAPTURE_CURRENCY_MISMATCH'
    ) {
      /*
       * The backend says PayPal captured money but the order requires
       * administrative review. Do not tell the customer to pay again.
       */
      Navigator.of(context).pop({
        'status': 'review_required',
        'wc_order_id':
        widget.wooCommerceOrderId,
        'orderID': widget.paypalOrderId,
        'transaction_id':
        capture['transaction_id'],
        'message':
        capture['message'] ??
            'Your payment was received and is being reviewed.',
        'capture': capture,
      });

      return;
    }

    if (
    capture['code'] ==
        'CAPTURE_TIMEOUT'
    ) {
      Navigator.of(context).pop({
        'status':
        'confirmation_unknown',
        'code': 'CAPTURE_TIMEOUT',
        'wc_order_id':
        widget.wooCommerceOrderId,
        'orderID':
        widget.paypalOrderId,
        'message':
        capture['message'],
      });

      return;
    }

    _showCaptureFailure(
      capture['message']?.toString() ??
          'PayPal payment could not be confirmed.',
      allowRetry: true,
    );
  }

  void _showCaptureFailure(
      String message, {
        bool allowRetry = false,
      }) {
    if (!mounted) {
      return;
    }

    setState(() {
      _pageLoading = false;
      _errorMessage = message;
      _isFinishingPayment = false;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Payment not confirmed',
          ),
          content: Text(message),
          actions: [
            if (allowRetry)
              TextButton(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop();

                  controller.loadRequest(
                    Uri.parse(
                      widget.approvalUrl,
                    ),
                  );
                },
                child: const Text(
                  'Return to PayPal',
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();

                Navigator.of(context).pop({
                  'status': 'failed',
                  'wc_order_id':
                  widget.wooCommerceOrderId,
                  'orderID':
                  widget.paypalOrderId,
                  'message': message,
                });
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _handleBackPressed() async {
    if (_isFinishingPayment) {
      return false;
    }

    if (await controller.canGoBack()) {
      await controller.goBack();
      return false;
    }

    if (!mounted) {
      return false;
    }

    Navigator.of(context).pop({
      'status': 'cancelled',
      'wc_order_id':
      widget.wooCommerceOrderId,
      'orderID': widget.paypalOrderId,
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult:
          (didPop, result) async {
        if (!didPop) {
          await _handleBackPressed();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PayPal Checkout',
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed:
            _isFinishingPayment
                ? null
                : () {
              Navigator.of(context).pop({
                'status': 'cancelled',
                'wc_order_id':
                widget
                    .wooCommerceOrderId,
                'orderID':
                widget.paypalOrderId,
              });
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (_pageLoading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.white70,
                  child: Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                ),
              ),
            if (
            _errorMessage != null &&
                !_pageLoading
            )
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Material(
                  elevation: 4,
                  borderRadius:
                  BorderRadius.circular(8),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}