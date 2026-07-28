import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Resources/AppColors.dart';
import 'modules/login_flow/login_page.dart';

class GlobalRouteObserver extends GetObserver {
  bool _isChecking = false; // prevents multiple API calls

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (shouldSkipRoute(route)) return;

    if (!_isChecking) {
      _isChecking = true;
      // callApi().whenComplete(() => _isChecking = false);
    }
  }

  bool shouldSkipRoute(Route route) {
    final name = route.settings.name;

    // Skip if no name or one of these routes
    if (name == null) return true;

    return name == '/' ||
        name == '/splash' ||
        name == '/LoginPage' ||
        name == '/WebViewApp' ||
        name == '/ResetPassword' ||
        name == '/RegisterPage';
  }

  // Future<void> callApi() async {
  //   if (Get.currentRoute == '/LoginPage') return;
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   if (token != null && token.isNotEmpty) {
  //     var loginApi = await ApiClass().accessPay();
  //     if (loginApi != null && loginApi['success'] == true) {
  //     }
  //   }
  // }
}
