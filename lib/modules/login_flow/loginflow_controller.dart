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

  Future<void> login() async {
    if (callLoginApi.value) {
      return;
    }

    final email =
    emailController.text.trim();

    final password =
        passwordController.text;

    if (email.isEmpty) {
      Get.snackbar(
        'Email required',
        'Please enter your email address.',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid email',
        'Please enter a valid email address.',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Password required',
        'Please enter your password.',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    callLoginApi.value = true;

    try {
      final prefs =
      await SharedPreferences.getInstance();

      prefs.clear();

      final response =
      await ApiClass().loginApi(
        email,
        password,
      );

      if (response == null) {
        return;
      }

      if (response['success'] != true) {
        Get.snackbar(
          'Unable to sign in',
          response['message']?.toString() ??
              'Please check your email and password.',
          backgroundColor: Colors.white,
          colorText: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      if (response['user'] == null) {
        prefs.clear();
        Get.snackbar(
          'Unable to sign in',
          'The account information could not be loaded.',
          backgroundColor: Colors.white,
          colorText: Colors.red,
        );

        return;
      }

      emailController.clear();
      passwordController.clear();

      await initAuthSessionFromPrefs();

      Get.offAll(
            () => const DashboardPage(),
      );
    } finally {
      callLoginApi.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


}
