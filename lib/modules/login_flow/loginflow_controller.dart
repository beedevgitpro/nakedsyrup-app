import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Resources/AppColors.dart';
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
    if (emailController.text.trim().isEmpty) {
      isReset.value = false;
      return Get.snackbar(
        'Please enter email address',
        "",
        backgroundColor: Colors.white,
      );
    }
    // if (confirmPassWordController.text.trim().isEmpty) {
    //   isReset.value = false;
    //
    //   return Get.snackbar(
    //     'Please enter confirm password',
    //     "",
    //     backgroundColor: Colors.white,
    //   );
    // }
    // if (newPassWordController.text != confirmPassWordController.text) {
    //   isReset.value = false;
    //   return Get.snackbar(
    //     'Passwords Mismatch',
    //     "",
    //     backgroundColor: Colors.white,
    //   );
    // }
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
          if (loginApi['user']['has_app_access'] == 'yes') {
            if (loginApi['user']['pay_by_account'] == 'yes') {
              Get.offAll(const DashboardPage());
            } else {
              showDialog<void>(
                context: Get.context!,
                barrierDismissible: false,
                // user must tap button!
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text(
                          "Sorry, you can not complete the login",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        content: const SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            "Your account is in review,Our team will get back to you within 48 hours.",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                AppColors.nakedSyrup,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.all(8),
                              ),
                            ),
                            child: const Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              Get.back();
                              prefs.clear();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }
          } else {
            showDialog<void>(
              context: Get.context!,
              barrierDismissible: false,
              // user must tap button!
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text(
                        "Sorry, you can not complete the login",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      content: const SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Your account is deactivate",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              AppColors.nakedSyrup,
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.all(8),
                            ),
                          ),
                          child: const Text(
                            "Close",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            Get.back();
                            prefs.clear();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }
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
