import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/login_flow/login_page.dart';
import 'service.dart';

class GlobalRouteObserver extends GetObserver {
  bool _isChecking = false;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    debugPrint('🔍 Checking access for route: ${route.settings.name}');

    // Only run one API check at a time
    if (!_isChecking) {
      _isChecking = true;

      // Run after the current frame finishes
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _checkAccess();
        _isChecking = false;
      });
    }
  }

  Future<void> _checkAccess() async {
    try {
      final loginApi = await ApiClass().accessPay();
      if (loginApi == null) return;

      final hasAccess = loginApi['has_app_access'] == 'yes';
      final payByAccount = loginApi['pay_by_account'] == 'yes';

      // Only navigate if blocked
      if (!hasAccess || !payByAccount) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        Get.offAll(() => LoginPage(), routeName: '/LoginPage');

        // Show dialog after navigation
        Future.delayed(const Duration(milliseconds: 100), () {
          showDialog<void>(
            context: Get.context!,
            barrierDismissible: false,
            builder:
                (context) => AlertDialog(
                  title: const Text(
                    "Sorry, you cannot continue.",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  content: Text(
                    !hasAccess
                        ? "Your account is deactivated."
                        : "Your pay by account is disabled.",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
          );
        });
      }
      // If access allowed, just update state here (no navigation)
    } catch (e) {
      debugPrint('Error checking access: $e');
    }
  }
}
