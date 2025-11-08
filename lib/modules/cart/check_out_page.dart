import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../Resources/AppColors.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/drop_down_field.dart';
import '../../widgets/mandtory_text_lables.dart';
import '../../widgets/text_form_fields.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  DashboardController dashboardController = Get.put(DashboardController());
  late WebViewControllerPlus controler;
  @override
  void initState() {
    // TODO: implement initState
    dashboardController.differentAddress.value = false;
    dashboardController.enableCheckOut.value = false;
    dashboardController.getPayByAcc();
    // controler =
    //     WebViewControllerPlus()
    //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //       ..addJavaScriptChannel(
    //         'Captcha',
    //         onMessageReceived: (message) async {
    //           final token = message.message;
    //           print('reCAPTCHA token received: $token');
    //           var verify = await ApiClass().verifyCaptchaToken(token);
    //           if (verify != null) {
    //             if (verify['success'] == true) {
    //               dashboardController.enableCheckOut.value = true;
    //               // dashboardController.recaptchaHeight.value = 100;
    //             }
    //           }
    //         },
    //       )
    //       ..addJavaScriptChannel(
    //         'Resize',
    //         onMessageReceived: (message) {
    //           print("is collapse :::: ${message.message}");
    //           if (message.message == "expand") {
    //             // dashboardController.recaptchaHeight.value = 500;
    //           } else if (message.message == "collapse") {
    //             // dashboardController.recaptchaHeight.value = 100;
    //           }
    //         },
    //       )
    //       ..loadRequest(
    //         Uri.parse('https://www.nakedsyrups.com.au/captcha.html'),
    //       )
    //       ..setNavigationDelegate(
    //         NavigationDelegate(
    //           onPageFinished: (_) {
    //             controler.runJavaScript('initResizeObserver()');
    //           },
    //         ),
    //       );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        'Checkout',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
            dashboardController.shippingMethods.value = "";
            dashboardController.selectedPaymentMethods.value = 'cod';
          },
        ),
        context,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Obx(() {
            if (dashboardController.getCheckOut.value) {
              return Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(color: AppColors.greenColor),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Get.width >= 600
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (Get.width / 2) - 30,
                              child: Form(
                                key: dashboardController.addressFormKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Text(
                                          'Billing Details',
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: getFontSize(context, 0),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'First Name',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .firstNameController,
                                                lable: 'First Name',
                                                function: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "First name is required!";
                                                  }
                                                  return null; // <-- must return null if valid
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Last Name',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .lastNameController,
                                                lable: 'Last Name',
                                                function: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "Last name is required!";
                                                  }
                                                  return null; // <-- must return null if valid
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Company Name',
                                                  context,
                                                  false,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .companyNameController,
                                                lable: 'Company Name',
                                                function: (value) {},
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
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
                                                        : null,
                                                itemList:
                                                    dashboardController
                                                        .countryMap
                                                        .value
                                                        .entries
                                                        .map((entry) {
                                                          return DropdownMenuItem<
                                                            String
                                                          >(
                                                            onTap: () {
                                                              dashboardController
                                                                  .selectedCountry
                                                                  .value = entry
                                                                      .key;
                                                              dashboardController
                                                                  .selectedState
                                                                  .value = "";
                                                              dashboardController
                                                                  .getStateList(
                                                                    entry.key,
                                                                    false,
                                                                  );
                                                            },
                                                            value:
                                                                entry
                                                                    .key, // country code (e.g., "IN")
                                                            child: Text(
                                                              entry.value,
                                                            ), // country name (e.g., "India")
                                                          );
                                                        })
                                                        .toList(),
                                                function: (value) {
                                                  if (value != null ||
                                                      value.trim().isNotEmpty) {
                                                    // dashboardController.selectedCountry.value =
                                                    //     value;
                                                    // dashboardController.selectedState.value =
                                                    //     "";
                                                    // dashboardController.getStateList(
                                                    //   value,
                                                    //   false,
                                                    // );
                                                  } else {
                                                    return "Please select country";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Street address',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .streetAddressController,
                                                lable: 'Street address',
                                                function: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "Add your address!";
                                                  }
                                                  return null; // <-- must return null if valid
                                                },
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .streetAddress2Controller,
                                                lable: 'Street address',
                                                function: (value) {},
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Town / City',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .townController,
                                                lable: 'Town / City',
                                                function: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "Add town or city name!";
                                                  }
                                                  return null; // <-- must return null if valid
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'State / County',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              Obx(
                                                () =>
                                                    dashboardController
                                                            .getCheckOut
                                                            .value
                                                        ? Center(
                                                          child: SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: CircularProgressIndicator(
                                                              color:
                                                                  AppColors
                                                                      .greenColor,
                                                            ),
                                                          ),
                                                        )
                                                        : AppDropDownField(
                                                          lable:
                                                              'State / County',
                                                          value:
                                                              dashboardController
                                                                      .stateMap
                                                                      .value
                                                                      .containsKey(
                                                                        dashboardController
                                                                            .selectedState
                                                                            .value,
                                                                      )
                                                                  ? dashboardController
                                                                      .selectedState
                                                                      .value
                                                                  : null,
                                                          itemList:
                                                              dashboardController
                                                                  .stateMap
                                                                  .value
                                                                  .entries
                                                                  .map((entry) {
                                                                    return DropdownMenuItem<
                                                                      String
                                                                    >(
                                                                      onTap:
                                                                          () {},
                                                                      value:
                                                                          entry
                                                                              .key,
                                                                      child: Text(
                                                                        entry
                                                                            .value,
                                                                      ),
                                                                    );
                                                                  })
                                                                  .toList(),
                                                          function: (value) {
                                                            if (value == null ||
                                                                value
                                                                    .trim()
                                                                    .isEmpty) {
                                                              return "State name is required!";
                                                            }
                                                            return null; // <-- must return null if valid
                                                          },
                                                        ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Postcode / ZIP',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .postCodeController,
                                                keyboardType:
                                                    TextInputType.number,
                                                lable: 'Postcode / ZIP',
                                                function: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "Please add postcode!";
                                                  }
                                                  return null; // <-- must return null if valid
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Phone',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .phoneController,
                                                keyboardType:
                                                    TextInputType.number,
                                                lable: 'Phone',
                                                function: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "Phone number is required!";
                                                  }
                                                  return null; // <-- must return null if valid
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Email address',
                                                  context,
                                                  true,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .emailController,

                                                lable: 'Email address',
                                                function: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "email address is required!";
                                                  }
                                                  return null; // <-- must return null if valid
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'PO Number (optional)',
                                                  context,
                                                  false,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .pOController,

                                                lable: 'PO Number',
                                                function: (value) {},
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Subscribe to Our Newsletter as  (optional)',
                                                  context,
                                                  false,
                                                ),
                                              ),
                                              AppDropDownField(
                                                lable: 'State / County',
                                                value:
                                                    dashboardController
                                                            .selectedNewsLetter
                                                            .value
                                                            .isNotEmpty
                                                        ? dashboardController
                                                            .selectedNewsLetter
                                                            .value
                                                        : null,
                                                itemList:
                                                    dashboardController
                                                        .newsletter
                                                        .map((item) {
                                                          return DropdownMenuItem<
                                                            String
                                                          >(
                                                            onTap: () {
                                                              dashboardController
                                                                  .selectedNewsLetter
                                                                  .value = item;
                                                            },
                                                            value: item,
                                                            child: Text(item),
                                                          );
                                                        })
                                                        .toList(),
                                                function: (value) {},
                                              ),

                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //     top: 10,
                                              //   ),
                                              //   child: textLabel(
                                              //     'Company Name (optional)',
                                              //     context,
                                              //     false,
                                              //   ),
                                              // ),
                                              // AppTextFormField(
                                              //   controller:
                                              //       dashboardController
                                              //           .companyName2Controller,
                                              //   lable: 'Company Name',
                                              //   function: (value) {},
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (Get.width / 2),
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    value:
                                        dashboardController
                                            .differentAddress
                                            .value,
                                    onChanged: (value) {
                                      dashboardController
                                          .differentAddress
                                          .value = value!;
                                    },
                                    title: Text(
                                      'Deliver to a different address?',
                                    ),
                                  ),
                                  Obx(() {
                                    if (dashboardController
                                        .differentAddress
                                        .value) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: Text(
                                              'Shipping Address',
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: getFontSize(
                                                  context,
                                                  0,
                                                ),
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              child: Form(
                                                key:
                                                    dashboardController
                                                        .shippingAddressFormKey,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                      child: textLabel(
                                                        'First Name',
                                                        context,
                                                        true,
                                                      ),
                                                    ),
                                                    AppTextFormField(
                                                      controller:
                                                          dashboardController
                                                              .firstNameDiffController,
                                                      lable: 'First Name',
                                                      function: (value) {
                                                        if (value == null ||
                                                            value
                                                                .trim()
                                                                .isEmpty) {
                                                          return "First name is required!";
                                                        }
                                                        return null; // <-- must return null if valid
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                      child: textLabel(
                                                        'Last Name',
                                                        context,
                                                        true,
                                                      ),
                                                    ),
                                                    AppTextFormField(
                                                      controller:
                                                          dashboardController
                                                              .lastNameDiffController,
                                                      lable: 'Last Name',
                                                      function: (value) {
                                                        if (value == null ||
                                                            value
                                                                .trim()
                                                                .isEmpty) {
                                                          return "Last name is required!";
                                                        }
                                                        return null; // <-- must return null if valid
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                      child: textLabel(
                                                        'Company Name',
                                                        context,
                                                        false,
                                                      ),
                                                    ),
                                                    AppTextFormField(
                                                      controller:
                                                          dashboardController
                                                              .companyNameDiffController,
                                                      lable: 'Company Name',
                                                      function: (value) {},
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
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
                                                                  .selectedCountryDiff
                                                                  .value
                                                                  .isNotEmpty
                                                              ? dashboardController
                                                                  .selectedCountryDiff
                                                                  .value
                                                              : null,
                                                      itemList:
                                                          dashboardController.countryMap.value.entries.map((
                                                            entry,
                                                          ) {
                                                            return DropdownMenuItem<
                                                              String
                                                            >(
                                                              onTap: () {
                                                                dashboardController
                                                                    .selectedCountryDiff
                                                                    .value = entry
                                                                        .key;
                                                                dashboardController
                                                                    .selectedStateDiff
                                                                    .value = "";
                                                                dashboardController
                                                                    .getStateList(
                                                                      entry.key,
                                                                      true,
                                                                    );
                                                              },
                                                              value:
                                                                  entry
                                                                      .key, // country code (e.g., "IN")
                                                              child: Text(
                                                                entry.value,
                                                              ), // country name (e.g., "India")
                                                            );
                                                          }).toList(),
                                                      function: (value) {
                                                        if (value != null ||
                                                            value
                                                                .trim()
                                                                .isNotEmpty) {
                                                          // dashboardController.selectedCountry.value =
                                                          //     value;
                                                          // dashboardController.selectedState.value =
                                                          //     "";
                                                          // dashboardController.getStateList(
                                                          //   value,
                                                          //   false,
                                                          // );
                                                        } else {
                                                          return "Please select country";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                      child: textLabel(
                                                        'Street address',
                                                        context,
                                                        true,
                                                      ),
                                                    ),
                                                    AppTextFormField(
                                                      controller:
                                                          dashboardController
                                                              .streetAddressDiffController,
                                                      lable: 'Street address',
                                                      function: (value) {
                                                        if (value == null ||
                                                            value
                                                                .trim()
                                                                .isEmpty) {
                                                          return "Add your address!";
                                                        }
                                                        return null; // <-- must return null if valid
                                                      },
                                                    ),
                                                    AppTextFormField(
                                                      controller:
                                                          dashboardController
                                                              .streetAddress2DiffController,
                                                      lable: 'Street address',
                                                      function: (value) {},
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                      child: textLabel(
                                                        'Town / City',
                                                        context,
                                                        true,
                                                      ),
                                                    ),
                                                    Focus(
                                                      child: AppTextFormField(
                                                        controller:
                                                            dashboardController
                                                                .townDiffController,
                                                        lable: 'Town / City',
                                                        function: (value) {
                                                          if (value == null ||
                                                              value
                                                                  .trim()
                                                                  .isEmpty) {
                                                            return "Add town or city name!";
                                                          }
                                                          return null; // <-- must return null if valid
                                                        },
                                                      ),
                                                      onFocusChange: (
                                                        hasFocus,
                                                      ) {
                                                        if (hasFocus) {
                                                          print(
                                                            'Name GAINED focus',
                                                          );
                                                        } else {
                                                          dashboardController
                                                              .getShippingMethods();
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                      child: textLabel(
                                                        'State / County',
                                                        context,
                                                        true,
                                                      ),
                                                    ),
                                                    Obx(
                                                      () =>
                                                          dashboardController
                                                                  .getCheckOut
                                                                  .value
                                                              ? Center(
                                                                child: SizedBox(
                                                                  width: 50,
                                                                  height: 50,
                                                                  child: CircularProgressIndicator(
                                                                    color:
                                                                        AppColors
                                                                            .greenColor,
                                                                  ),
                                                                ),
                                                              )
                                                              : AppDropDownField(
                                                                lable:
                                                                    'State / County',
                                                                value:
                                                                    dashboardController
                                                                            .stateMapDiff
                                                                            .value
                                                                            .containsKey(
                                                                              dashboardController.selectedStateDiff.value,
                                                                            )
                                                                        ? dashboardController
                                                                            .selectedStateDiff
                                                                            .value
                                                                        : null,
                                                                itemList:
                                                                    dashboardController.stateMapDiff.value.entries.map((
                                                                      entry,
                                                                    ) {
                                                                      return DropdownMenuItem<
                                                                        String
                                                                      >(
                                                                        onTap: () {
                                                                          dashboardController
                                                                              .selectedStateDiff
                                                                              .value = entry.key;
                                                                          dashboardController
                                                                              .getShippingMethods();
                                                                        },
                                                                        value:
                                                                            entry.key,
                                                                        child: Text(
                                                                          entry
                                                                              .value,
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                function: (
                                                                  value,
                                                                ) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .trim()
                                                                          .isEmpty) {
                                                                    return "State name is required!";
                                                                  }
                                                                  return null; // <-- must return null if valid
                                                                },
                                                              ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                      child: textLabel(
                                                        'Postcode / ZIP',
                                                        context,
                                                        true,
                                                      ),
                                                    ),
                                                    Focus(
                                                      child: AppTextFormField(
                                                        controller:
                                                            dashboardController
                                                                .postCodeDiffController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        lable: 'Postcode / ZIP',
                                                        function: (value) {
                                                          if (value == null ||
                                                              value
                                                                  .trim()
                                                                  .isEmpty) {
                                                            return "Please add postcode!";
                                                          }
                                                          return null; // <-- must return null if valid
                                                        },
                                                      ),
                                                      onFocusChange: (
                                                        hasFocus,
                                                      ) {
                                                        if (hasFocus) {
                                                          print(
                                                            'Name GAINED focus',
                                                          );
                                                        } else {
                                                          dashboardController
                                                              .getShippingMethods();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  }),
                                  Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: textLabel(
                                              'Order notes (optional)',
                                              context,
                                              false,
                                            ),
                                          ),
                                          AppTextFormField(
                                            controller:
                                                dashboardController
                                                    .orderNotesController,
                                            lable: 'Order notes',
                                            function: (value) {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    if (dashboardController.getShipping.value) {
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
                                      if (dashboardController
                                                  .cartModel
                                                  .value
                                                  .cartItems
                                                  ?.isNotEmpty ==
                                              true &&
                                          dashboardController
                                                  .shippingMethodsModel
                                                  .value
                                                  .shippingMethods
                                                  ?.isNotEmpty ==
                                              true &&
                                          ((dashboardController
                                                      .selectedStateDiff
                                                      .value
                                                      .isNotEmpty &&
                                                  dashboardController
                                                      .differentAddress
                                                      .value) ||
                                              dashboardController
                                                      .differentAddress
                                                      .value ==
                                                  false)) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 8,
                                            right: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Text(
                                                  'Shipping',
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: getFontSize(
                                                      context,
                                                      0,
                                                    ),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                color: Colors.white,
                                                child: Obx(() {
                                                  final methods =
                                                      dashboardController
                                                          .shippingMethodsModel
                                                          .value
                                                          .shippingMethods ??
                                                      [];

                                                  return RadioGroup<String>(
                                                    groupValue:
                                                        dashboardController
                                                            .shippingMethods
                                                            .value,
                                                    onChanged: (value) {
                                                      dashboardController
                                                          .shippingMethods
                                                          .value = value!;
                                                      dashboardController
                                                          .priceDetails();
                                                    },
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: methods.length,
                                                      itemBuilder: (
                                                        context,
                                                        j,
                                                      ) {
                                                        final method =
                                                            methods[j];
                                                        final cost =
                                                            double.tryParse(
                                                              method.costRaw ??
                                                                  "0.0",
                                                            ) ??
                                                            0.0;

                                                        return RadioListTile<
                                                          String
                                                        >(
                                                          value:
                                                              method.id ?? '',
                                                          activeColor:
                                                              AppColors
                                                                  .nakedSyrup,
                                                          title: Text(
                                                            method.label ?? "",
                                                          ),
                                                          subtitle: Text(
                                                            "\$${cost.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColors
                                                                      .nakedSyrup,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(child: SizedBox());
                                      }
                                    }
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Text(
                                            'Payment Method',
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: getFontSize(context, 0),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          child: Obx(
                                            () => RadioGroup<String>(
                                              groupValue:
                                                  dashboardController
                                                      .selectedPaymentMethods
                                                      .value,
                                              onChanged: (value) {
                                                dashboardController
                                                    .selectedPaymentMethods
                                                    .value = value!;
                                                dashboardController
                                                    .priceDetails();
                                              },
                                              child: Column(
                                                children: [
                                                  // if (dashboardController
                                                  //         .isPayByAcc
                                                  //         .value ==
                                                  //     'yes')
                                                  RadioListTile<String>(
                                                    value: 'cod',
                                                    activeColor:
                                                        AppColors.nakedSyrup,
                                                    title: const Text(
                                                      "Pay By Account",
                                                    ),
                                                  ),
                                                  // RadioListTile<String>(
                                                  //   value: 'ppcp',
                                                  //   activeColor:
                                                  //       AppColors.nakedSyrup,
                                                  //   title: const Text("Paypal"),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Obx(() {
                                    if (dashboardController
                                        .getPriceDetails
                                        .value) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            color: AppColors.greenColor,
                                          ),
                                        ),
                                      );
                                    } else if (dashboardController
                                        .shippingMethods
                                        .value
                                        .isEmpty) {
                                      return SizedBox();
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 8,
                                          right: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //     left: 10,
                                            //   ),
                                            //   child: Text(
                                            //     'Price Details',
                                            //     style: TextStyle(
                                            //       fontFamily: "Montserrat",
                                            //       fontSize: getFontSize(
                                            //         context,
                                            //         0,
                                            //       ),
                                            //       color: Colors.black87,
                                            //       fontWeight: FontWeight.w600,
                                            //     ),
                                            //   ),
                                            // ),
                                            Card(
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "Sub Total : ",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Euclid Circular B',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: getFontSize(
                                                            context,
                                                            -2,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        dashboardController
                                                                    .priceModel
                                                                    .value
                                                                    .subtotal !=
                                                                null
                                                            ? "\$${double.parse(dashboardController.priceModel.value.subtotal.toString() ?? "0.0").toStringAsFixed(2)}"
                                                            : "0.0",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .nakedSyrup,
                                                          fontFamily:
                                                              'Euclid Circular B',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: getFontSize(
                                                            context,
                                                            -2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 3),
                                                  dashboardController
                                                              .priceModel
                                                              .value
                                                              .gstTotal !=
                                                          null
                                                      ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "GST : ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Euclid Circular B',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -2,
                                                                  ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "\$${double.parse(dashboardController.priceModel.value.gstTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors
                                                                      .nakedSyrup,
                                                              fontFamily:
                                                                  'Euclid Circular B',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -2,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                      : const SizedBox(),
                                                  SizedBox(
                                                    height:
                                                        dashboardController
                                                                        .priceModel
                                                                        .value
                                                                        .fees !=
                                                                    null &&
                                                                dashboardController
                                                                        .priceModel
                                                                        .value
                                                                        .fees
                                                                        ?.isNotEmpty ==
                                                                    true
                                                            ? 3
                                                            : 0,
                                                  ),
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        dashboardController
                                                            .priceModel
                                                            .value
                                                            .fees
                                                            ?.length ??
                                                        0,
                                                    itemBuilder: (
                                                      context,
                                                      fee,
                                                    ) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "${dashboardController.priceModel.value.fees?[fee].name} : ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Euclid Circular B',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -2,
                                                                  ),
                                                            ),
                                                          ),
                                                          Text(
                                                            dashboardController
                                                                        .priceModel
                                                                        .value
                                                                        .fees?[fee]
                                                                        .amount !=
                                                                    null
                                                                ? "\$${double.parse(dashboardController.priceModel.value.fees?[fee].amount.toString() ?? "0.0").toStringAsFixed(2)}"
                                                                : "\$${double.parse(dashboardController.priceModel.value.fees?[fee].shippingModel.toString() ?? "0.0").toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors
                                                                      .nakedSyrup,
                                                              fontFamily:
                                                                  'Euclid Circular B',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -2,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    separatorBuilder: (
                                                      context,
                                                      i,
                                                    ) {
                                                      return SizedBox(
                                                        height: 3,
                                                      );
                                                    },
                                                  ),
                                                  // dashboardController
                                                  //                 .priceModel
                                                  //                 .value
                                                  //                 .discountTotal !=
                                                  //             null &&
                                                  //         dashboardController
                                                  //                 .priceModel
                                                  //                 .value
                                                  //                 .discountTotal !=
                                                  //             0.0
                                                  //     ? Row(
                                                  //       mainAxisAlignment:
                                                  //           MainAxisAlignment.end,
                                                  //       children: [
                                                  //         Text(
                                                  //           "Discount : ",
                                                  //           style: TextStyle(
                                                  //             color: Colors.black,
                                                  //             fontFamily:
                                                  //                 'Euclid Circular B',
                                                  //             fontWeight:
                                                  //                 FontWeight.w600,
                                                  //             fontSize: getFontSize(
                                                  //               context,
                                                  //               -2,
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //         Text(
                                                  //           "- \$${double.parse(dashboardController.cartModel.value.discountTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                                  //           style: TextStyle(
                                                  //             color:
                                                  //                 AppColors
                                                  //                     .nakedSyrup,
                                                  //             fontFamily:
                                                  //                 'Euclid Circular B',
                                                  //             fontWeight:
                                                  //                 FontWeight.bold,
                                                  //             fontSize: getFontSize(
                                                  //               context,
                                                  //               -2,
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //       ],
                                                  //     )
                                                  //     : const SizedBox(),
                                                  SizedBox(height: 3),

                                                  dashboardController
                                                              .priceModel
                                                              .value
                                                              .grandTotal !=
                                                          null
                                                      ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "Grant Total : ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Euclid Circular B',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -2,
                                                                  ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "\$${double.parse(dashboardController.priceModel.value.grandTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors
                                                                      .nakedSyrup,
                                                              fontFamily:
                                                                  'Euclid Circular B',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -2,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                                  Obx(
                                    () =>
                                        dashboardController.placeOrder.value
                                            ? Center(
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                      color:
                                                          AppColors.greenColor,
                                                    ),
                                              ),
                                            )
                                            : Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  minimumSize: Size(
                                                    Get.width,
                                                    42,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 5,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  dashboardController
                                                      .placeOrderApi();
                                                },
                                                child: Text(
                                                  'Place Order',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        Get.width >= 600
                                                            ? getFontSize(
                                                              context,
                                                              -1,
                                                            )
                                                            : getFontSize(
                                                              context,
                                                              -5,
                                                            ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        : Column(
                          children: [
                            Form(
                              key: dashboardController.addressFormKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Billing Details',
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: getFontSize(context, 0),
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'First Name',
                                                context,
                                                true,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .firstNameController,
                                              lable: 'First Name',
                                              function: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "First name is required!";
                                                }
                                                return null; // <-- must return null if valid
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Last Name',
                                                context,
                                                true,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .lastNameController,
                                              lable: 'Last Name',
                                              function: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "Last name is required!";
                                                }
                                                return null; // <-- must return null if valid
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Company Name',
                                                context,
                                                false,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .companyNameController,
                                              lable: 'Company Name',
                                              function: (value) {},
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
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
                                                      : null,
                                              itemList:
                                                  dashboardController
                                                      .countryMap
                                                      .value
                                                      .entries
                                                      .map((entry) {
                                                        return DropdownMenuItem<
                                                          String
                                                        >(
                                                          onTap: () {
                                                            dashboardController
                                                                .selectedCountry
                                                                .value = entry
                                                                    .key;
                                                            dashboardController
                                                                .selectedState
                                                                .value = "";
                                                            dashboardController
                                                                .getStateList(
                                                                  entry.key,
                                                                  false,
                                                                );
                                                          },
                                                          value:
                                                              entry
                                                                  .key, // country code (e.g., "IN")
                                                          child: Text(
                                                            entry.value,
                                                          ), // country name (e.g., "India")
                                                        );
                                                      })
                                                      .toList(),
                                              function: (value) {
                                                if (value != null ||
                                                    value.trim().isNotEmpty) {
                                                  // dashboardController.selectedCountry.value =
                                                  //     value;
                                                  // dashboardController.selectedState.value =
                                                  //     "";
                                                  // dashboardController.getStateList(
                                                  //   value,
                                                  //   false,
                                                  // );
                                                } else {
                                                  return "Please select country";
                                                }
                                                return null;
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Street address',
                                                context,
                                                true,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .streetAddressController,
                                              lable: 'Street address',
                                              function: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "Add your address!";
                                                }
                                                return null; // <-- must return null if valid
                                              },
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .streetAddress2Controller,
                                              lable: 'Street address',
                                              function: (value) {},
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Town / City',
                                                context,
                                                true,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .townController,
                                              lable: 'Town / City',
                                              function: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "Add town or city name!";
                                                }
                                                return null; // <-- must return null if valid
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'State / County',
                                                context,
                                                true,
                                              ),
                                            ),
                                            Obx(
                                              () =>
                                                  dashboardController
                                                          .getCheckOut
                                                          .value
                                                      ? Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: CircularProgressIndicator(
                                                            color:
                                                                AppColors
                                                                    .greenColor,
                                                          ),
                                                        ),
                                                      )
                                                      : AppDropDownField(
                                                        lable: 'State / County',
                                                        value:
                                                            dashboardController
                                                                    .stateMap
                                                                    .value
                                                                    .containsKey(
                                                                      dashboardController
                                                                          .selectedState
                                                                          .value,
                                                                    )
                                                                ? dashboardController
                                                                    .selectedState
                                                                    .value
                                                                : null,
                                                        itemList:
                                                            dashboardController
                                                                .stateMap
                                                                .value
                                                                .entries
                                                                .map((entry) {
                                                                  return DropdownMenuItem<
                                                                    String
                                                                  >(
                                                                    onTap:
                                                                        () {},
                                                                    value:
                                                                        entry
                                                                            .key,
                                                                    child: Text(
                                                                      entry
                                                                          .value,
                                                                    ),
                                                                  );
                                                                })
                                                                .toList(),
                                                        function: (value) {
                                                          if (value == null ||
                                                              value
                                                                  .trim()
                                                                  .isEmpty) {
                                                            return "State name is required!";
                                                          }
                                                          return null; // <-- must return null if valid
                                                        },
                                                      ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Postcode / ZIP',
                                                context,
                                                true,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .postCodeController,
                                              keyboardType:
                                                  TextInputType.number,
                                              lable: 'Postcode / ZIP',
                                              function: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "Please add postcode!";
                                                }
                                                return null; // <-- must return null if valid
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Phone',
                                                context,
                                                true,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .phoneController,
                                              keyboardType:
                                                  TextInputType.number,
                                              lable: 'Phone',
                                              function: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "Phone number is required!";
                                                }
                                                return null; // <-- must return null if valid
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Email address',
                                                context,
                                                true,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .emailController,

                                              lable: 'Email address',
                                              function: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "email address is required!";
                                                }
                                                return null; // <-- must return null if valid
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'PO Number (optional)',
                                                context,
                                                false,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .pOController,

                                              lable: 'PO Number',
                                              function: (value) {},
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Subscribe to Our Newsletter as  (optional)',
                                                context,
                                                false,
                                              ),
                                            ),
                                            AppDropDownField(
                                              lable: 'State / County',
                                              value:
                                                  dashboardController
                                                          .selectedNewsLetter
                                                          .value
                                                          .isNotEmpty
                                                      ? dashboardController
                                                          .selectedNewsLetter
                                                          .value
                                                      : null,
                                              itemList:
                                                  dashboardController.newsletter
                                                      .map((item) {
                                                        return DropdownMenuItem<
                                                          String
                                                        >(
                                                          onTap: () {
                                                            dashboardController
                                                                .selectedNewsLetter
                                                                .value = item;
                                                          },
                                                          value: item,
                                                          child: Text(item),
                                                        );
                                                      })
                                                      .toList(),
                                              function: (value) {},
                                            ),

                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //     top: 10,
                                            //   ),
                                            //   child: textLabel(
                                            //     'Company Name (optional)',
                                            //     context,
                                            //     false,
                                            //   ),
                                            // ),
                                            // AppTextFormField(
                                            //   controller:
                                            //       dashboardController
                                            //           .companyName2Controller,
                                            //   lable: 'Company Name',
                                            //   function: (value) {},
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CheckboxListTile(
                                      value:
                                          dashboardController
                                              .differentAddress
                                              .value,
                                      onChanged: (value) {
                                        dashboardController
                                            .differentAddress
                                            .value = value!;
                                      },
                                      title: Text(
                                        'Deliver to a different address?',
                                      ),
                                    ),

                                    Obx(() {
                                      if (dashboardController
                                          .differentAddress
                                          .value) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Text(
                                                'Shipping Address',
                                                style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: getFontSize(
                                                    context,
                                                    0,
                                                  ),
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: Form(
                                                  key:
                                                      dashboardController
                                                          .shippingAddressFormKey,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'First Name',
                                                          context,
                                                          true,
                                                        ),
                                                      ),
                                                      AppTextFormField(
                                                        controller:
                                                            dashboardController
                                                                .firstNameDiffController,
                                                        lable: 'First Name',
                                                        function: (value) {
                                                          if (value == null ||
                                                              value
                                                                  .trim()
                                                                  .isEmpty) {
                                                            return "First name is required!";
                                                          }
                                                          return null; // <-- must return null if valid
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'Last Name',
                                                          context,
                                                          true,
                                                        ),
                                                      ),
                                                      AppTextFormField(
                                                        controller:
                                                            dashboardController
                                                                .lastNameDiffController,
                                                        lable: 'Last Name',
                                                        function: (value) {
                                                          if (value == null ||
                                                              value
                                                                  .trim()
                                                                  .isEmpty) {
                                                            return "Last name is required!";
                                                          }
                                                          return null; // <-- must return null if valid
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'Company Name',
                                                          context,
                                                          false,
                                                        ),
                                                      ),
                                                      AppTextFormField(
                                                        controller:
                                                            dashboardController
                                                                .companyNameDiffController,
                                                        lable: 'Company Name',
                                                        function: (value) {},
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'Country / Region',
                                                          context,
                                                          true,
                                                        ),
                                                      ),
                                                      AppDropDownField(
                                                        lable:
                                                            'Country / Region',
                                                        value:
                                                            dashboardController
                                                                    .selectedCountryDiff
                                                                    .value
                                                                    .isNotEmpty
                                                                ? dashboardController
                                                                    .selectedCountryDiff
                                                                    .value
                                                                : null,
                                                        itemList:
                                                            dashboardController.countryMap.value.entries.map((
                                                              entry,
                                                            ) {
                                                              return DropdownMenuItem<
                                                                String
                                                              >(
                                                                onTap: () {
                                                                  dashboardController
                                                                      .selectedCountryDiff
                                                                      .value = entry
                                                                          .key;
                                                                  dashboardController
                                                                      .selectedStateDiff
                                                                      .value = "";
                                                                  dashboardController
                                                                      .getStateList(
                                                                        entry
                                                                            .key,
                                                                        true,
                                                                      );
                                                                },
                                                                value:
                                                                    entry
                                                                        .key, // country code (e.g., "IN")
                                                                child: Text(
                                                                  entry.value,
                                                                ), // country name (e.g., "India")
                                                              );
                                                            }).toList(),
                                                        function: (value) {
                                                          if (value != null ||
                                                              value
                                                                  .trim()
                                                                  .isNotEmpty) {
                                                            // dashboardController.selectedCountry.value =
                                                            //     value;
                                                            // dashboardController.selectedState.value =
                                                            //     "";
                                                            // dashboardController.getStateList(
                                                            //   value,
                                                            //   false,
                                                            // );
                                                          } else {
                                                            return "Please select country";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'Street address',
                                                          context,
                                                          true,
                                                        ),
                                                      ),
                                                      AppTextFormField(
                                                        controller:
                                                            dashboardController
                                                                .streetAddressDiffController,
                                                        lable: 'Street address',
                                                        function: (value) {
                                                          if (value == null ||
                                                              value
                                                                  .trim()
                                                                  .isEmpty) {
                                                            return "Add your address!";
                                                          }
                                                          return null; // <-- must return null if valid
                                                        },
                                                      ),
                                                      AppTextFormField(
                                                        controller:
                                                            dashboardController
                                                                .streetAddress2DiffController,
                                                        lable: 'Street address',
                                                        function: (value) {},
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'Town / City',
                                                          context,
                                                          true,
                                                        ),
                                                      ),
                                                      Focus(
                                                        child: AppTextFormField(
                                                          controller:
                                                              dashboardController
                                                                  .townDiffController,
                                                          lable: 'Town / City',
                                                          function: (value) {
                                                            if (value == null ||
                                                                value
                                                                    .trim()
                                                                    .isEmpty) {
                                                              return "Add town or city name!";
                                                            }
                                                            return null; // <-- must return null if valid
                                                          },
                                                        ),
                                                        onFocusChange: (
                                                          hasFocus,
                                                        ) {
                                                          if (hasFocus) {
                                                            print(
                                                              'Name GAINED focus',
                                                            );
                                                          } else {
                                                            dashboardController
                                                                .getShippingMethods();
                                                          }
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'State / County',
                                                          context,
                                                          true,
                                                        ),
                                                      ),
                                                      Obx(
                                                        () =>
                                                            dashboardController
                                                                    .getCheckOut
                                                                    .value
                                                                ? Center(
                                                                  child: SizedBox(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child: CircularProgressIndicator(
                                                                      color:
                                                                          AppColors
                                                                              .greenColor,
                                                                    ),
                                                                  ),
                                                                )
                                                                : AppDropDownField(
                                                                  lable:
                                                                      'State / County',
                                                                  value:
                                                                      dashboardController
                                                                              .stateMapDiff
                                                                              .value
                                                                              .containsKey(
                                                                                dashboardController.selectedStateDiff.value,
                                                                              )
                                                                          ? dashboardController
                                                                              .selectedStateDiff
                                                                              .value
                                                                          : null,
                                                                  itemList:
                                                                      dashboardController.stateMapDiff.value.entries.map((
                                                                        entry,
                                                                      ) {
                                                                        return DropdownMenuItem<
                                                                          String
                                                                        >(
                                                                          onTap: () {
                                                                            dashboardController.selectedStateDiff.value =
                                                                                entry.key;
                                                                            dashboardController.getShippingMethods();
                                                                          },
                                                                          value:
                                                                              entry.key,
                                                                          child: Text(
                                                                            entry.value,
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                  function: (
                                                                    value,
                                                                  ) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .trim()
                                                                            .isEmpty) {
                                                                      return "State name is required!";
                                                                    }
                                                                    return null; // <-- must return null if valid
                                                                  },
                                                                ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 10,
                                                            ),
                                                        child: textLabel(
                                                          'Postcode / ZIP',
                                                          context,
                                                          true,
                                                        ),
                                                      ),
                                                      Focus(
                                                        child: AppTextFormField(
                                                          controller:
                                                              dashboardController
                                                                  .postCodeDiffController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          lable:
                                                              'Postcode / ZIP',
                                                          function: (value) {
                                                            if (value == null ||
                                                                value
                                                                    .trim()
                                                                    .isEmpty) {
                                                              return "Please add postcode!";
                                                            }
                                                            return null; // <-- must return null if valid
                                                          },
                                                        ),
                                                        onFocusChange: (
                                                          hasFocus,
                                                        ) {
                                                          if (hasFocus) {
                                                            print(
                                                              'Name GAINED focus',
                                                            );
                                                          } else {
                                                            dashboardController
                                                                .getShippingMethods();
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
                                    Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Order notes (optional)',
                                                context,
                                                false,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .orderNotesController,
                                              lable: 'Order notes',
                                              function: (value) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(() {
                              if (dashboardController.getShipping.value) {
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
                                if (dashboardController
                                            .cartModel
                                            .value
                                            .cartItems
                                            ?.isNotEmpty ==
                                        true &&
                                    dashboardController
                                            .shippingMethodsModel
                                            .value
                                            .shippingMethods
                                            ?.isNotEmpty ==
                                        true &&
                                    ((dashboardController
                                                .selectedStateDiff
                                                .value
                                                .isNotEmpty &&
                                            dashboardController
                                                .differentAddress
                                                .value) ||
                                        dashboardController
                                                .differentAddress
                                                .value ==
                                            false)) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Text(
                                            'Shipping',
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: getFontSize(context, 0),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          child: Obx(() {
                                            final methods =
                                                dashboardController
                                                    .shippingMethodsModel
                                                    .value
                                                    .shippingMethods ??
                                                [];

                                            return RadioGroup<String>(
                                              groupValue:
                                                  dashboardController
                                                      .shippingMethods
                                                      .value,
                                              onChanged: (value) {
                                                dashboardController
                                                    .shippingMethods
                                                    .value = value!;
                                                dashboardController
                                                    .priceDetails();
                                              },
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: methods.length,
                                                itemBuilder: (context, j) {
                                                  final method = methods[j];
                                                  final cost =
                                                      double.tryParse(
                                                        method.costRaw
                                                                .toString() ??
                                                            "0.0",
                                                      ) ??
                                                      0.0;

                                                  return RadioListTile<String>(
                                                    value: method.id ?? '',
                                                    activeColor:
                                                        AppColors.nakedSyrup,
                                                    title: Text(
                                                      method.label ?? "",
                                                    ),
                                                    subtitle: Text(
                                                      "\$${cost.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            AppColors
                                                                .nakedSyrup,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(child: SizedBox());
                                }
                              }
                            }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Payment Method',
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: getFontSize(context, 0),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Card(
                                    color: Colors.white,
                                    child: Obx(
                                      () => RadioGroup<String>(
                                        groupValue:
                                            dashboardController
                                                .selectedPaymentMethods
                                                .value,
                                        onChanged: (value) {
                                          dashboardController
                                              .selectedPaymentMethods
                                              .value = value!;
                                          dashboardController.priceDetails();
                                        },
                                        child: Column(
                                          children: [
                                            // if (dashboardController
                                            //         .isPayByAcc
                                            //         .value ==
                                            //     'yes')
                                            RadioListTile<String>(
                                              value: 'cod',
                                              activeColor: AppColors.nakedSyrup,
                                              title: const Text(
                                                "Pay By Account",
                                              ),
                                            ),
                                            // RadioListTile<String>(
                                            //   value: 'ppcp',
                                            //   activeColor: AppColors.nakedSyrup,
                                            //   title: const Text("Paypal"),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Obx(() {
                              if (dashboardController.getPriceDetails.value) {
                                return Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: AppColors.greenColor,
                                    ),
                                  ),
                                );
                              } else if (dashboardController
                                  .shippingMethods
                                  .value
                                  .isEmpty) {
                                return SizedBox();
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //     left: 10,
                                      //   ),
                                      //   child: Text(
                                      //     'Price Details',
                                      //     style: TextStyle(
                                      //       fontFamily: "Montserrat",
                                      //       fontSize: getFontSize(context, 0),
                                      //       color: Colors.black87,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      // ),
                                      Card(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Sub Total : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getFontSize(
                                                      context,
                                                      -2,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  dashboardController
                                                              .priceModel
                                                              .value
                                                              .subtotal !=
                                                          null
                                                      ? "\$${double.parse(dashboardController.priceModel.value.subtotal.toString() ?? "0.0").toStringAsFixed(2)}"
                                                      : "0.0",
                                                  style: TextStyle(
                                                    color: AppColors.nakedSyrup,
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: getFontSize(
                                                      context,
                                                      -2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 3),
                                            dashboardController
                                                        .priceModel
                                                        .value
                                                        .gstTotal !=
                                                    null
                                                ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "GST : ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -2,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "\$${double.parse(dashboardController.priceModel.value.gstTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .nakedSyrup,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : const SizedBox(),
                                            SizedBox(
                                              height:
                                                  dashboardController
                                                                  .priceModel
                                                                  .value
                                                                  .fees !=
                                                              null &&
                                                          dashboardController
                                                                  .priceModel
                                                                  .value
                                                                  .fees
                                                                  ?.isNotEmpty ==
                                                              true
                                                      ? 3
                                                      : 0,
                                            ),
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  dashboardController
                                                      .priceModel
                                                      .value
                                                      .fees
                                                      ?.length ??
                                                  0,
                                              itemBuilder: (context, fee) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${dashboardController.priceModel.value.fees?[fee].name} : ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -2,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      dashboardController
                                                                  .priceModel
                                                                  .value
                                                                  .fees?[fee]
                                                                  .amount !=
                                                              null
                                                          ? "\$${double.parse(dashboardController.priceModel.value.fees?[fee].amount.toString() ?? "0.0").toStringAsFixed(2)}"
                                                          : "\$${double.parse(dashboardController.priceModel.value.fees?[fee].shippingModel.toString() ?? "0.0").toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .nakedSyrup,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder: (context, i) {
                                                return SizedBox(height: 3);
                                              },
                                            ),
                                            // dashboardController
                                            //                 .priceModel
                                            //                 .value
                                            //                 .discountTotal !=
                                            //             null &&
                                            //         dashboardController
                                            //                 .priceModel
                                            //                 .value
                                            //                 .discountTotal !=
                                            //             0.0
                                            //     ? Row(
                                            //       mainAxisAlignment:
                                            //           MainAxisAlignment.end,
                                            //       children: [
                                            //         Text(
                                            //           "Discount : ",
                                            //           style: TextStyle(
                                            //             color: Colors.black,
                                            //             fontFamily:
                                            //                 'Euclid Circular B',
                                            //             fontWeight:
                                            //                 FontWeight.w600,
                                            //             fontSize: getFontSize(
                                            //               context,
                                            //               -2,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //         Text(
                                            //           "- \$${double.parse(dashboardController.cartModel.value.discountTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                            //           style: TextStyle(
                                            //             color:
                                            //                 AppColors
                                            //                     .nakedSyrup,
                                            //             fontFamily:
                                            //                 'Euclid Circular B',
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             fontSize: getFontSize(
                                            //               context,
                                            //               -2,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     )
                                            //     : const SizedBox(),
                                            SizedBox(height: 3),

                                            dashboardController
                                                        .priceModel
                                                        .value
                                                        .grandTotal !=
                                                    null
                                                ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Grant Total : ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -2,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "\$${double.parse(dashboardController.priceModel.value.grandTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .nakedSyrup,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                            Obx(
                              () =>
                                  dashboardController.placeOrder.value
                                      ? Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            color: AppColors.greenColor,
                                          ),
                                        ),
                                      )
                                      : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            minimumSize: Size(Get.width, 42),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            dashboardController.placeOrderApi();
                                          },
                                          child: Text(
                                            'Place Order',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, -1)
                                                      : getFontSize(
                                                        context,
                                                        -5,
                                                      ),
                                            ),
                                          ),
                                        ),
                                      ),
                            ),
                          ],
                        ),
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
