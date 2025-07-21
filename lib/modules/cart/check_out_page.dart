import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../Resources/AppColors.dart';
import '../../service.dart';
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
                  dashboardController.enableCheckOut.value = true;
                }
              }
            },
          )
          ..addJavaScriptChannel(
            'Resize',
            onMessageReceived: (message) {
              print("is collapse :::: ${message.message}");
              if (message.message == "expand") {
                Future.delayed(Duration(milliseconds: 10), () {
                  dashboardController.recaptchaHeight.value = 400;
                  setState(() {});
                }); // expanded
              } else if (message.message == "collapse") {
                dashboardController.recaptchaHeight.value = 0;
                Future.delayed(Duration(milliseconds: 10), () {
                  dashboardController.recaptchaHeight.value = 500;
                  setState(() {});
                });
              }
            },
          )
          ..loadRequest(
            Uri.parse('https://www.nakedsyrups.com.au/captcha.html'),
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                controler.runJavaScript('document.body.style.zoom="1";');
              },
            ),
          );
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

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: textLabel(
                                                  'Company Name (optional)',
                                                  context,
                                                  false,
                                                ),
                                              ),
                                              AppTextFormField(
                                                controller:
                                                    dashboardController
                                                        .companyName2Controller,
                                                lable: 'Company Name',
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
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      dashboardController
                                                          .shippingMethodsModel
                                                          .value
                                                          .shippingMethods
                                                          ?.length,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, j) {
                                                    return Obx(
                                                      () => RadioListTile(
                                                        activeColor:
                                                            AppColors
                                                                .nakedSyrup,
                                                        value:
                                                            dashboardController
                                                                .shippingMethodsModel
                                                                .value
                                                                .shippingMethods?[j]
                                                                .id,
                                                        groupValue:
                                                            dashboardController
                                                                .shippingMethods
                                                                .value,
                                                        onChanged: (value) {
                                                          dashboardController
                                                              .shippingMethods
                                                              .value = value!;
                                                        },
                                                        title: Text(
                                                          dashboardController
                                                                  .shippingMethodsModel
                                                                  .value
                                                                  .shippingMethods?[j]
                                                                  .label ??
                                                              "",
                                                        ),
                                                        subtitle: Text(
                                                          "\$${double.parse(dashboardController.shippingMethodsModel.value.shippingMethods?[j].costRaw ?? "0.0").toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                AppColors
                                                                    .nakedSyrup,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(child: SizedBox());
                                      }
                                    }
                                  }),
                                  Obx(() {
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: Text(
                                              'Payment Method',
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
                                            child: RadioListTile(
                                              activeColor: AppColors.nakedSyrup,
                                              value: 'cod',
                                              groupValue:
                                                  dashboardController
                                                      .selectedPaymentMethods
                                                      .value,
                                              onChanged: (value) {
                                                dashboardController
                                                    .selectedPaymentMethods
                                                    .value = value!;
                                              },
                                              title: Text("Pay by account"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  Obx(() {
                                    final screenWidth =
                                        MediaQuery.of(context).size.width;
                                    final screenHeight =
                                        MediaQuery.of(context).size.height;

                                    double width =
                                        screenWidth >= 600
                                            ? (screenWidth / 2) - 50
                                            : screenWidth - 50;
                                    double height =
                                        dashboardController
                                                .enableRegistration
                                                .value
                                            ? screenHeight *
                                                0.1 // 20% of screen height
                                            : screenWidth >= 600
                                            ? screenHeight * 0.36
                                            : screenHeight *
                                                0.24; // 50% of screen height

                                    return Center(
                                      child: SizedBox(
                                        height:
                                            dashboardController
                                                .recaptchaHeight
                                                .value,
                                        width: width,
                                        child: WebViewWidget(
                                          controller: controler,
                                        ),
                                      ),
                                    );
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
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                        dashboardController
                                                                .enableCheckOut
                                                                .value
                                                            ? AppColors
                                                                .nakedSyrup
                                                            : AppColors
                                                                .lightColor,
                                                      ),
                                                ),
                                                onPressed:
                                                    dashboardController
                                                            .enableCheckOut
                                                            .value
                                                        ? () {
                                                          dashboardController
                                                              .placeOrderApi();
                                                        }
                                                        : null,
                                                child: Text(
                                                  'Place Order',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
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

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: textLabel(
                                                'Company Name (optional)',
                                                context,
                                                false,
                                              ),
                                            ),
                                            AppTextFormField(
                                              controller:
                                                  dashboardController
                                                      .companyName2Controller,
                                              lable: 'Company Name',
                                              function: (value) {},
                                            ),
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
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                dashboardController
                                                    .shippingMethodsModel
                                                    .value
                                                    .shippingMethods
                                                    ?.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, j) {
                                              return Obx(
                                                () => RadioListTile(
                                                  activeColor:
                                                      AppColors.nakedSyrup,
                                                  value:
                                                      dashboardController
                                                          .shippingMethodsModel
                                                          .value
                                                          .shippingMethods?[j]
                                                          .id,
                                                  groupValue:
                                                      dashboardController
                                                          .shippingMethods
                                                          .value,
                                                  onChanged: (value) {
                                                    dashboardController
                                                        .shippingMethods
                                                        .value = value!;
                                                  },
                                                  title: Text(
                                                    dashboardController
                                                            .shippingMethodsModel
                                                            .value
                                                            .shippingMethods?[j]
                                                            .label ??
                                                        "",
                                                  ),
                                                  subtitle: Text(
                                                    "\$${double.parse(dashboardController.shippingMethodsModel.value.shippingMethods?[j].costRaw ?? "0.0").toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          AppColors.nakedSyrup,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(child: SizedBox());
                                }
                              }
                            }),
                            Obx(() {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 8,
                                  right: 8,
                                ),
                                child: Column(
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
                                    Card(
                                      color: Colors.white,
                                      child: RadioListTile(
                                        activeColor: AppColors.nakedSyrup,
                                        value: 'cod',
                                        groupValue:
                                            dashboardController
                                                .selectedPaymentMethods
                                                .value,
                                        onChanged: (value) {
                                          dashboardController
                                              .selectedPaymentMethods
                                              .value = value!;
                                        },
                                        title: Text("Pay by account"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            Obx(() {
                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              final screenHeight =
                                  MediaQuery.of(context).size.height;

                              double width =
                                  screenWidth >= 600
                                      ? (screenWidth / 2) - 50
                                      : screenWidth - 50;
                              double height =
                                  dashboardController.enableRegistration.value
                                      ? screenHeight *
                                          0.1 // 20% of screen height
                                      : screenWidth >= 600
                                      ? screenHeight * 0.36
                                      : screenHeight *
                                          0.5; // 50% of screen height

                              return Center(
                                child: SizedBox(
                                  height:
                                      dashboardController.recaptchaHeight.value,
                                  width: width,
                                  child: WebViewWidget(
                                    key: ValueKey(
                                      dashboardController.recaptchaHeight.value,
                                    ),
                                    controller: controler,
                                  ),
                                ),
                              );
                            }),
                            // Obx(() {
                            //   double height;
                            //   if (dashboardController.enableCheckOut.value) {
                            //     height = Get.width >= 600 ? 200 : 50;
                            //   } else {
                            //     height = Get.width >= 600 ? 500 : 350;
                            //   }
                            //   return Center(
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: SizedBox(
                            //         height: height,
                            //         // width: Get.width,
                            //         child: Transform.scale(
                            //           origin: Offset(-190, -180),
                            //           scale: 2, // Adjust as needed
                            //           child: WebViewWidget(
                            //             controller: controler,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   );
                            // }),
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
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                  dashboardController
                                                          .enableCheckOut
                                                          .value
                                                      ? AppColors.nakedSyrup
                                                      : AppColors.lightColor,
                                                ),
                                          ),
                                          onPressed:
                                              dashboardController
                                                      .enableCheckOut
                                                      .value
                                                  ? () {
                                                    dashboardController
                                                        .placeOrderApi();
                                                  }
                                                  : null,
                                          child: Text(
                                            'Place Order',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
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
