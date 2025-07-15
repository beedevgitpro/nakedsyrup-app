import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Resources/AppColors.dart';
import '../../utility/responsive_text.dart';
import 'loginflow_controller.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  LoginFlowController loginFlowController = Get.put(LoginFlowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: (Get.height - 250) * 0.2),
                child: const SizedBox(
                    // height: loginFlowController.isItTablet.value ? 50 : 0,
                    ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "New Password",
                        style: TextStyle(
                            fontSize: getFontSize(context, -2),
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 7, left: 15, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color(0XFFced4da),
                            ),
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              // loginFlowController.newPassword.value = value;
                            },
                            obscureText: true,
                            controller:
                                loginFlowController.newPassWordController,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: getFontSize(context, 0)),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              hintText: 'New Password',
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: getFontSize(context, 0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "Confirm Password",
                        style: TextStyle(
                            fontSize: getFontSize(context, -2),
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 7, left: 15, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color(0XFFced4da),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(0),
                          child: TextField(
                            onChanged: (value) {
                              // loginFlowController.confirmPassword.value = value;
                            },
                            obscureText: true,
                            controller:
                                loginFlowController.confirmPassWordController,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: getFontSize(context, 0)),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: getFontSize(context, 0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: Obx(() {
                        if (loginFlowController.isReset.value) {
                          return Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: AppColors.greenColor,
                              ),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(
                                  Size(Get.width, 49),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                    AppColors.greenColor)),
                            onPressed: () {
                              loginFlowController.resetValidate();
                            },
                            child: Text(
                              "Reset Password".toUpperCase(),
                              style:
                                  TextStyle(fontSize: getFontSize(context, 2)),
                            ),
                          );
                        }
                      }),
                    ),
                    const SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
