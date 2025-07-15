import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service.dart';
import '../dashboard_flow/dashboard.dart';
import 'login_page.dart';

class LoginFlowController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPassWordController = TextEditingController();
  TextEditingController confirmPassWordController = TextEditingController();
  RxBool callLoginApi = false.obs;
  RxBool isOnline = false.obs;
  RxBool isReset = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxInt role = 0.obs;

  resetValidate() async {
    isReset.value = true;
    if (newPassWordController.text.trim().isEmpty) {
      isReset.value = false;
      return Get.snackbar(
        'Please enter new password',
        "",
        backgroundColor: Colors.white,
      );
    }
    if (confirmPassWordController.text.trim().isEmpty) {
      isReset.value = false;

      return Get.snackbar(
        'Please enter confirm password',
        "",
        backgroundColor: Colors.white,
      );
    }
    if (newPassWordController.text != confirmPassWordController.text) {
      isReset.value = false;
      return Get.snackbar(
        'Passwords Mismatch',
        "",
        backgroundColor: Colors.white,
      );
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var data;
    // var data = await ApiClass().resetPassword(
    //     newPassWordController.text, confirmPassWordController.text);
    print("data : $data :: ${data is String}");
    isReset.value = false;
    if (data != null) {
      if (data['success'] == true) {
        newPassWordController.clear();
        confirmPassWordController.clear();

        await prefs.remove('reset_password');
        Get.snackbar("${data['message']}", "", backgroundColor: Colors.white);
      } else {
        print("forgotPass response : $data");
        Get.snackbar("${data['message']}", "", backgroundColor: Colors.white);
      }
    }
  }

  login() async {
    if (emailController.text.trim().isEmpty) {
      return Get.snackbar(
        "Email field is empty",
        '',
        backgroundColor: Colors.white,
      );
    }
    if (passwordController.text.trim().isEmpty) {
      return Get.snackbar(
        "Password field is empty",
        "",
        backgroundColor: Colors.white,
      );
    }
    callLoginApi.value = true;
    var loginApi = await ApiClass().loginApi(
      emailController.text.trim(),
      passwordController.text,
    );
    if (loginApi != null) {
      if (loginApi['success'] == true) {
        if (loginApi['user'] != null) {
          Get.offAll(const DashboardPage());
        } else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Get.offAll(LoginPage());
        }
        callLoginApi.value = false;
        emailController.clear();
        passwordController.clear();
      } else {
        callLoginApi.value = false;
        Get.snackbar(
          loginApi['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      callLoginApi.value = false;
      Get.snackbar(
        "Login response empty",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }
}
