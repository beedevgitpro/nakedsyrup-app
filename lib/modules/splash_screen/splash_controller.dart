import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard_flow/dashboard.dart';
import '../login_flow/login_page.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    validateUser();
  }

  Future<void> validateUser() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token')?.trim() ?? '';
    final userId = prefs.getInt('user_id');

    // Keep a very short splash delay for branding,
    // not the current forced three-second delay.
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (token.isNotEmpty && userId != null) {
      Get.offAll(() => const DashboardPage());
      return;
    }

    Get.offAll(() => LoginPage());
  }
}