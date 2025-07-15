import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/modules/login_flow/login_page.dart';
import 'package:naked_syrups/service.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../Resources/AppColors.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/drop_down_field.dart';
import '../../widgets/mandtory_text_lables.dart';
import '../../widgets/text_form_fields.dart';
import '../dashboard_flow/dashboard_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DashboardController dashboardController = Get.put(DashboardController());
  late WebViewControllerPlus controler;
  @override
  void initState() {
    // TODO: implement initState
    dashboardController.getCountryList();
    controler =
        WebViewControllerPlus()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'Captcha',
            onMessageReceived: (message) async {
              final token = message.message;
              print('reCAPTCHA token received: $token');
              var verify = await ApiClass().verifyCaptchaToken(token);
              if (verify != null) {
                if (verify['success'] == true) {
                  dashboardController.enableRegistration.value = true;
                }
              }
            },
          )
          // ..addJavaScriptChannel(
          //   'CaptchaClicked',
          //   onMessageReceived: (message) async {
          //     dashboardController.isVerifying.value = true;
          //     var respose = await ApiClass().verifyCaptcha(message.message);
          //     Future.delayed(const Duration(seconds: 2), () {
          //       if (!dashboardController.isCaptchaVerified.value) {
          //         dashboardController.isImageChallengeLikelyVisible.value =
          //             true;
          //       }
          //     });
          //   },
          // )
          ..loadRequest(
            Uri.parse('https://www.nakedsyrups.com.au/captcha.html'),
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        'Register',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        context,
      ),
      body: Obx(
        () =>
            dashboardController.getCheckOut.value
                ? Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppColors.greenColor,
                    ),
                  ),
                )
                : ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  children: [
                    Card(
                      color: Colors.white,
                      child: Form(
                        key: dashboardController.registerationForm,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel('First Name', context, true),
                              ),
                              AppTextFormField(
                                controller:
                                    dashboardController.firstNameController,
                                lable: 'First Name',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel('Last Name', context, true),
                              ),
                              AppTextFormField(
                                controller:
                                    dashboardController.lastNameController,
                                lable: 'Last Name',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel('Phone', context, true),
                              ),
                              AppTextFormField(
                                controller: dashboardController.phoneController,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                lable: 'Phone',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel(
                                  'Company Name',
                                  context,
                                  false,
                                ),
                              ),
                              AppTextFormField(
                                controller:
                                    dashboardController.companyNameController,
                                lable: 'Company Name',
                                function: (value) {},
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: textLabel(
                                  'Country / Region',
                                  context,
                                  true,
                                ),
                              ),
                              AppDropDownField(
                                lable: 'Country / Region',
                                value:
                                    dashboardController
                                            .selectedCountry
                                            .value
                                            .isNotEmpty
                                        ? dashboardController
                                            .selectedCountry
                                            .value
                                        : null, // 👈 ADD THIS LINE
                                itemList:
                                    dashboardController.countryMap.value.entries
                                        .map((entry) {
                                          return DropdownMenuItem<String>(
                                            onTap: () {
                                              dashboardController
                                                  .selectedCountry
                                                  .value = entry.key;
                                              dashboardController
                                                  .selectedState
                                                  .value = "";
                                              dashboardController.getStateList(
                                                entry.key,
                                                false,
                                              );
                                            },
                                            value: entry.key,
                                            child: Text(entry.value),
                                          );
                                        })
                                        .toList(),
                                function: (value) {
                                  if (value != null) {
                                    dashboardController.selectedCountry.value =
                                        value;
                                    dashboardController.selectedState.value =
                                        "";
                                    dashboardController.getStateList(
                                      value,
                                      false,
                                    );
                                  }
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel(
                                  'Street address',
                                  context,
                                  true,
                                ),
                              ),
                              AppTextFormField(
                                controller:
                                    dashboardController.streetAddressController,
                                lable: 'Street address',
                                function: (value) {},
                              ),
                              AppTextFormField(
                                controller:
                                    dashboardController
                                        .streetAddress2Controller,
                                lable: 'Street address',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel('Town / City', context, true),
                              ),
                              AppTextFormField(
                                controller: dashboardController.townController,
                                lable: 'Town / City',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel(
                                  'State / County',
                                  context,
                                  true,
                                ),
                              ),
                              Obx(
                                () =>
                                    dashboardController.getCheckOut.value
                                        ? Center(
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              color: AppColors.greenColor,
                                            ),
                                          ),
                                        )
                                        : AppDropDownField(
                                          lable: 'State / County',
                                          itemList:
                                              dashboardController
                                                  .stateMap
                                                  .value
                                                  .entries
                                                  .map((entry) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      onTap: () {
                                                        dashboardController
                                                            .selectedState
                                                            .value = entry.key;
                                                      },
                                                      value: entry.key,
                                                      child: Text(entry.value),
                                                    );
                                                  })
                                                  .toList(),
                                          function: (value) {},
                                        ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel(
                                  'Postcode / ZIP',
                                  context,
                                  true,
                                ),
                              ),
                              AppTextFormField(
                                controller:
                                    dashboardController.postCodeController,
                                keyboardType: TextInputType.number,
                                lable: 'Postcode / ZIP',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel('User Name', context, true),
                              ),
                              AppTextFormField(
                                controller:
                                    dashboardController.userNameController,

                                lable: 'User Name',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel(
                                  'Email address',
                                  context,
                                  true,
                                ),
                              ),
                              AppTextFormField(
                                controller: dashboardController.emailController,

                                lable: 'Email address',
                                function: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: textLabel('Password', context, true),
                              ),
                              Obx(
                                () => AppTextFormField(
                                  obscureText:
                                      !dashboardController
                                          .isPasswordVisible
                                          .value,
                                  controller:
                                      dashboardController.passwordController,
                                  lable: 'Password',
                                  function: (value) {},
                                  suffix: InkWell(
                                    onTap: () {
                                      dashboardController
                                          .isPasswordVisible
                                          .value = !dashboardController
                                              .isPasswordVisible
                                              .value;
                                    },
                                    child: Icon(
                                      dashboardController
                                              .isPasswordVisible
                                              .value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      double height;

                      if (dashboardController.enableRegistration.value) {
                        height = Get.width >= 600 ? 200 : 30;
                      } else {
                        height = Get.width >= 600 ? 500 : 200;
                      }
                      return Center(
                        child: SizedBox(
                          height: height,
                          width:
                              Get.width >= 600
                                  ? (Get.width / 2) - 50
                                  : Get.width - 50,
                          child: WebViewWidget(controller: controler),
                        ),
                      );
                    }),
                    const SizedBox(height: 15),
                    Obx(() {
                      if (dashboardController.callRegisterApi.value) {
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
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                dashboardController.enableRegistration.value
                                    ? AppColors.nakedSyrup
                                    : AppColors.lightColor,
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
                            onPressed:
                                dashboardController.enableRegistration.value
                                    ? () {
                                      dashboardController.registration();
                                    }
                                    : null,
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Euclid Circular B",
                                fontWeight: FontWeight.w700,
                                fontSize: getFontSize(context, -2),
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
                                  text: "Already a Member? ",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(context, -3),
                                  ),
                                ),
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(context, -3),
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(LoginPage());
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
      ),
    );
  }
}
