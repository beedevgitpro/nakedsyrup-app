import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard_flow/dashboard.dart';
import '../login_flow/login_page.dart';

class SplashController extends GetxController {
  void validateUser() async {
    var savedData = await checkToken();
    Timer(const Duration(seconds: 3), () async {
      if (savedData != null && savedData == true) {
        Get.offAll(DashboardPage());
      } else {
        Get.offAll(LoginPage());
      }
    });
  }

  checkToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('user_id') != null) {
      var type = prefs.getInt('user_id');
      if (type != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void onInit() {
    validateUser();

    super.onInit();
  }
}
