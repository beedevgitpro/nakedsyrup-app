import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/responsive_text.dart';
import '../../widgets/mandtory_text_lables.dart';
import '../../widgets/text_form_fields.dart';
import 'loginflow_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  LoginFlowController loginFlowController = Get.put(LoginFlowController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 4),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   "Login",
                      //   overflow: TextOverflow.visible,
                      //   softWrap: true,
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       fontFamily: "Montserrat",
                      //       fontSize: getFontSize(context, 3),
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.normal),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: textLabel('Email', context, true),
                      ),
                      AppTextFormField(
                        controller: loginFlowController.emailController,
                        lable: 'Email',
                        function: (value) {},
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10),
                      //   child: textLabel('Password', context, true),
                      // ),
                      // AppTextFormField(
                      //   controller: loginFlowController.passwordController,
                      //   lable: 'Password',
                      //   function: (value) {},
                      // ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              Colors.black,
                            ),
                          ),
                          onPressed: () {
                            // loginFlowController.forgotPass();
                          },
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontSize: getFontSize(context, -2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
