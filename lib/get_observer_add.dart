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
      callApi().whenComplete(() => _isChecking = false);
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

  Future<void> callApi() async {
    if (Get.currentRoute == '/LoginPage') return;

    var loginApi = await ApiClass().accessPay();
    if (loginApi != null && loginApi['success'] == true) {
      if (loginApi['has_app_access'] != null) {
        if (loginApi['has_app_access'] == 'no') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          Get.offAll(() => LoginPage(), routeName: '/LoginPage');

          // Show dialog AFTER pushing login page
          Future.delayed(Duration(milliseconds: 100), () {
            showDialog<void>(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Sorry, you can not continue.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  content: const Text(
                    "Your account is deactivate.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.nakedSyrup,
                        padding: const EdgeInsets.all(8),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          });
        } else {
          // if (loginApi['pay_by_account'] != null) {
          //   if (loginApi['pay_by_account'] == 'no') {
          //     final prefs = await SharedPreferences.getInstance();
          //     await prefs.clear();
          //
          //     Get.offAll(() => LoginPage(), routeName: '/LoginPage');
          //
          //     // Show dialog AFTER pushing login page
          //     Future.delayed(Duration(milliseconds: 100), () {
          //       showDialog<void>(
          //         context: Get.context!,
          //         barrierDismissible: false,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             title: const Text(
          //               "Sorry, you can not continue.",
          //               style: TextStyle(
          //                 color: Colors.black87,
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w800,
          //               ),
          //             ),
          //             content: const Text(
          //               "Your pay by account is disable.",
          //               style: TextStyle(
          //                 color: Colors.black87,
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //             actions: [
          //               ElevatedButton(
          //                 style: ElevatedButton.styleFrom(
          //                   backgroundColor: AppColors.nakedSyrup,
          //                   padding: const EdgeInsets.all(8),
          //                 ),
          //                 child: const Text(
          //                   "Close",
          //                   style: TextStyle(color: Colors.white, fontSize: 14),
          //                 ),
          //                 onPressed: () {
          //                   Get.back();
          //                 },
          //               ),
          //             ],
          //           );
          //         },
          //       );
          //     });
          //   }
          // } else {
          //   final prefs = await SharedPreferences.getInstance();
          //   await prefs.clear();
          //   Get.offAll(() => LoginPage(), routeName: '/LoginPage');
          // }
        }
      }
      // else {
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.clear();
      //   Get.offAll(() => LoginPage(), routeName: '/LoginPage');
      // }
    }
  }
}
