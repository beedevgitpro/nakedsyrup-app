import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/service.dart';

import 'Resources/AppColors.dart';
import 'modules/login_flow/login_page.dart';

class GlobalRouteObserver extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (shouldSkipRoute(route)) {
      return;
    } else {
      callApi();
    }
  }

  bool shouldSkipRoute(Route route) {
    final name = route.settings.name;
    return name == '/' ||
        name == '/splash' ||
        name == '/LoginPage' ||
        name == '/RegisterPage';
  }

  callApi() async {
    var loginApi = await ApiClass().accessPay();
    if (loginApi != null) {
      if (loginApi['success'] == true) {
        if (loginApi['pay_by_account'] != null) {
          if (loginApi['pay_by_account'] == 'yes') {
          } else {
            Get.offAll(LoginPage());
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
                          "Your pay by account is disable.",
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
                            Get.back();
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
          Get.offAll(LoginPage());
        }
      } else {}
    } else {}
  }
}
