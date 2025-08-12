import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/widgets/appbar_widget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'Resources/AppColors.dart';
import 'modules/dashboard_flow/dashboard_controller.dart';

class WebViewApp extends StatefulWidget {
  WebViewApp({super.key, this.name, this.url});
  String? name;
  String? url;
  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewControllerPlus controller;
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    if (Platform.isAndroid && widget.url?.endsWith('.pdf') == true) {
      widget.url =
          'https://docs.google.com/gview?embedded=true&url=${widget.url}';
    }
    dashboardController.loadWebView.value = true;
    controller =
        WebViewControllerPlus()
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                dashboardController.loadWebView.value = true;
              },
              onPageFinished: (url) async {
                dashboardController.loadWebView.value = false;
              },
            ),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..loadRequest(Uri.parse(widget.url ?? 'https://nakedsyrups.com.au/'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        '${widget.name}',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        context,
        actions: [],
      ),
      body: Obx(
        () =>
            dashboardController.loadWebView.value
                ? Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppColors.greenColor,
                    ),
                  ),
                )
                : WebViewWidget(controller: controller),
      ),
    );
  }
}
