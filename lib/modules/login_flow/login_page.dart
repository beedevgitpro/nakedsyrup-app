import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/modules/login_flow/register_page.dart';

import '../../Resources/AppColors.dart';
import '../../Resources/AppStrings.dart';
import '../../utility/responsive_text.dart';
import '../../web_view_app.dart';
import '../../widgets/mandtory_text_lables.dart';
import '../../widgets/text_form_fields.dart';
import 'loginflow_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  LoginFlowController loginFlowController = Get.put(LoginFlowController());

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login-background.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // <-- Adjust opacity here
                BlendMode.darken, // <-- Darken effect
              ),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.width >= 600 ? Get.height / 7 : Get.height / 13,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: orientation == Orientation.portrait ? 10 : 100,
                      right: orientation == Orientation.portrait ? 10 : 100,
                      top:
                          orientation == Orientation.portrait
                              ? Get.width / 6
                              : 70,
                      bottom: 5,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width:
                                Get.width >= 600
                                    ? Get.width * 0.7
                                    : Get.width - 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9),
                              // border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 30,
                                bottom: 20,
                                right: 20,
                                left: 20,
                              ),
                              child: Column(
                                children: [
                                  orientation == Orientation.portrait
                                      ? SizedBox(
                                        // width: Get.width * 0.6,
                                        child: Image.asset(
                                          "assets/images/Logo.png",
                                        ),
                                        // child: Center(
                                        //   child: Text(
                                        //     "My Account",
                                        //     style: TextStyle( v
                                        //       fontWeight: FontWeight.w800,
                                        //       fontSize: 30,
                                        //       fontFamily: 'Euclid Circular B',
                                        //       fontStyle: FontStyle.italic,
                                        //       letterSpacing: -1.5,
                                        //     ),
                                        //   ),
                                        // ),
                                      )
                                      : SizedBox(
                                        // height: Get.width / 15,
                                        child: Image.asset(
                                          "assets/images/Logo.png",
                                        ),
                                      ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: textLabel(
                                      'Username or Email Address',
                                      context,
                                      true,
                                    ),
                                  ),
                                  AppTextFormField(
                                    controller:
                                        loginFlowController.emailController,
                                    lable: 'Email (Username)',
                                    function: (value) {},
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: textLabel('Password', context, true),
                                  ),
                                  Obx(
                                    () => AppTextFormField(
                                      obscureText:
                                          !loginFlowController
                                              .isPasswordVisible
                                              .value,
                                      controller:
                                          loginFlowController
                                              .passwordController,
                                      lable: 'Password',
                                      function: (value) {},
                                      suffix: InkWell(
                                        onTap: () {
                                          loginFlowController
                                              .isPasswordVisible
                                              .value = !loginFlowController
                                                  .isPasswordVisible
                                                  .value;
                                        },
                                        child: Icon(
                                          loginFlowController
                                                  .isPasswordVisible
                                                  .value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Obx(() {
                                    if (loginFlowController
                                        .callLoginApi
                                        .value) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            color: AppColors.nakedSyrup,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: Get.width - 60,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll<Color>(
                                                  AppColors.nakedSyrup,
                                                ),
                                            shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder
                                            >(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                  9.0,
                                                ), // Adjust border radius as needed
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            loginFlowController.login();
                                          },
                                          child: Text(
                                            'LOGIN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Euclid Circular B",
                                              fontWeight: FontWeight.w700,
                                              fontSize: getFontSize(
                                                context,
                                                -2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 0,
                                        left: 5,
                                        right: 0,
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: RichText(
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.end,
                                          softWrap: true,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Not a Customer? ",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: getFontSize(
                                                    context,
                                                    -3,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Signup Now",
                                                style: TextStyle(
                                                  color: AppColors.nakedSyrup,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: getFontSize(
                                                    context,
                                                    -3,
                                                  ),
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Get.offAll(
                                                          RegisterPage(),
                                                        );
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppStrings.version,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: getFontSize(context, -2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(
                                    WebViewApp(
                                      name: 'Privacy Policy',
                                      url:
                                          'https://nakedsyrups.com.au/privacy-policy/',
                                    ),
                                  );
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              Text(
                                ' | ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  Get.to(
                                    WebViewApp(
                                      name: 'Deliveries and Returns',
                                      url:
                                          'https://nakedsyrups.com.au/deliveries-returns/',
                                    ),
                                  );
                                },
                                child: Text(
                                  'Deliveries and Returns',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Stack(
          //   children: [
          //
          //
          //     // Positioned(
          //     //   bottom: 10,
          //     //   child: Padding(
          //     //     padding: const EdgeInsets.only(left: 12, right: 12),
          //     //     child: SizedBox(
          //     //       width: Get.width - 20,
          //     //       child: Column(
          //     //         children: [
          //     //           Row(
          //     //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     //             crossAxisAlignment: CrossAxisAlignment.start,
          //     //             children: [
          //     //               InkWell(
          //     //                 onTap: () async {
          //     //                   Get.to(
          //     //                     WebViewApp(
          //     //                       name: 'Vegan Australia Certified',
          //     //                       url:
          //     //                           'https://nakedsyrups.com.au/wp-content/uploads/2025/07/Vegan-Australia-Certificate-Naked-Syrups-2025.pdf',
          //     //                     ),
          //     //                   );
          //     //                 },
          //     //                 child: Text(
          //     //                   'Vegan Australia Certified',
          //     //                   style: TextStyle(color: Colors.white),
          //     //                 ),
          //     //               ),
          //     //               InkWell(
          //     //                 onTap: () async {
          //     //                   Get.to(
          //     //                     WebViewApp(
          //     //                       name: 'HACCP Certification',
          //     //                       url:
          //     //                           'https://nakedsyrups.com.au/wp-content/uploads/2024/11/Naked-Syrups-HACCP-Certificate-Exp-2025-11-08a.pdf',
          //     //                     ),
          //     //                   );
          //     //                 },
          //     //                 child: Text(
          //     //                   'HACCP Certification',
          //     //                   style: TextStyle(color: Colors.white),
          //     //                 ),
          //     //               ),
          //     //             ],
          //     //           ),
          //     //           Row(
          //     //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     //             children: [
          //     //               InkWell(
          //     //                 onTap: () async {
          //     //                   Get.to(
          //     //                     WebViewApp(
          //     //                       name: 'Deliveries and Returns',
          //     //                       url:
          //     //                           'https://nakedsyrups.com.au/deliveries-returns/',
          //     //                     ),
          //     //                   );
          //     //                 },
          //     //                 child: Text(
          //     //                   'Deliveries and Returns',
          //     //                   style: TextStyle(color: Colors.white),
          //     //                 ),
          //     //               ),
          //     //               InkWell(
          //     //                 onTap: () async {
          //     //                   Get.to(
          //     //                     WebViewApp(
          //     //                       name: 'Privacy Policy',
          //     //                       url:
          //     //                           'https://nakedsyrups.com.au/privacy-policy/',
          //     //                     ),
          //     //                   );
          //     //                 },
          //     //                 child: Text(
          //     //                   'Privacy Policy',
          //     //                   style: TextStyle(color: Colors.white),
          //     //                 ),
          //     //               ),
          //     //             ],
          //     //           ),
          //     //         ],
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
