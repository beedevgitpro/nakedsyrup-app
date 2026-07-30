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
  RxBool isCerti = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxInt role = 0.obs;
  RxList certificateList = [].obs;
  RxString name = "".obs;
  RxString token = "".obs;
  RxBool isLoading = false.obs;
  getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('name') ?? "Guest User";
  }

  void loadToken() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? "";
    isLoading.value = false;
  }

  resetValidate() async {
    isReset.value = true;
    if (emailController.text.trim().isEmpty) {
      isReset.value = false;
      return Get.snackbar(
        'Please enter email address',
        "",
        backgroundColor: Colors.white,
      );
    }
    var data = await ApiClass().resetPass(emailController.text);
    print("data : $data :: ${data is String}");
    isReset.value = false;
    if (data != null) {
      if (data['success'] == true) {
        emailController.clear();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(LoginPage());
        Get.snackbar("${data['message']}", "", backgroundColor: Colors.white);
      } else {
        print("forgotPass response : $data");
        Get.snackbar("${data['message']}", "", backgroundColor: Colors.white);
      }
    }
  }

  getCerti() async {
    isCerti.value = true;
    certificateList.clear();
    var category = await ApiClass().getCertificate();
    if (category != null) {
      certificateList.value.addAll(category);
    }
    isCerti.value = false;
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
