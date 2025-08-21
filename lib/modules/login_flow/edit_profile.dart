import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/drop_down_field.dart';
import '../../widgets/mandtory_text_lables.dart';
import '../../widgets/text_form_fields.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<EditProfilePage> {
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    // TODO: implement initState
    dashboardController.getCountryList();

    dashboardController.fillProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        'Edit Profile',
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
            if (dashboardController.getProfile.value) {
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
                        ? Form(
                          key: dashboardController.addressFormKey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (Get.width / 2) - 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: textLabel(
                                          'First Name',
                                          context,
                                          true,
                                        ),
                                      ),
                                      AppTextFormField(
                                        controller:
                                            dashboardController
                                                .firstNormalController,
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
                                        padding: const EdgeInsets.only(top: 10),
                                        child: textLabel(
                                          'Last Name',
                                          context,
                                          true,
                                        ),
                                      ),
                                      AppTextFormField(
                                        controller:
                                            dashboardController
                                                .lastNormalController,
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
                                        padding: const EdgeInsets.only(top: 10),
                                        child: textLabel(
                                          'Display Name',
                                          context,
                                          true,
                                        ),
                                      ),
                                      AppTextFormField(
                                        controller:
                                            dashboardController
                                                .userNameController,

                                        lable: 'Display Name',
                                        function: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "display name is required!";
                                          }
                                          return null; // <-- must return null if valid
                                        },
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
                                        controller:
                                            dashboardController
                                                .emailNormalController,
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                          left: 10,
                                          top: 10,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (Get.width / 2),
                                child: Column(
                                  children: [
                                    Column(
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
                                                        value.trim().isEmpty) {
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
                                                        value.trim().isEmpty) {
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
                                                        value.trim().isEmpty) {
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
                                                                          dashboardController
                                                                              .selectedStateDiff
                                                                              .value,
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
                                                                          .value = entry
                                                                              .key;
                                                                      dashboardController
                                                                          .getShippingMethods();
                                                                    },
                                                                    value:
                                                                        entry
                                                                            .key,
                                                                    child: Text(
                                                                      entry
                                                                          .value,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                            function: (value) {
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
                                                        TextInputType.number,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Obx(
                                      () =>
                                          dashboardController.saveProfile.value
                                              ? Center(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            AppColors
                                                                .greenColor,
                                                      ),
                                                ),
                                              )
                                              : Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.nakedSyrup,
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
                                                        .updateProfile();
                                                  },
                                                  child: Text(
                                                    'Update Profile',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 5,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          dashboardController.deActiveAcc();
                                        },
                                        child: Text(
                                          'Deactivate Account',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                Get.width >= 600
                                                    ? getFontSize(context, -1)
                                                    : getFontSize(context, -5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                      padding: const EdgeInsets.only(top: 0),
                                      child: textLabel(
                                        'First Name',
                                        context,
                                        true,
                                      ),
                                    ),
                                    AppTextFormField(
                                      controller:
                                          dashboardController
                                              .firstNormalController,
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
                                      padding: const EdgeInsets.only(top: 10),
                                      child: textLabel(
                                        'Last Name',
                                        context,
                                        true,
                                      ),
                                    ),
                                    AppTextFormField(
                                      controller:
                                          dashboardController
                                              .lastNormalController,
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
                                      padding: const EdgeInsets.only(top: 10),
                                      child: textLabel(
                                        'Display Name',
                                        context,
                                        true,
                                      ),
                                    ),
                                    AppTextFormField(
                                      controller:
                                          dashboardController
                                              .userNameController,

                                      lable: 'Display Name',
                                      function: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "display name is required!";
                                        }
                                        return null; // <-- must return null if valid
                                      },
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
                                      controller:
                                          dashboardController
                                              .emailNormalController,
                                      keyboardType: TextInputType.emailAddress,
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
                                        left: 10,
                                        top: 10,
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
                                                if (value != null &&
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
                                          ],
                                        ),
                                      ),
                                    ),

                                    Column(
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
                                                        value.trim().isEmpty) {
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
                                                        value.trim().isEmpty) {
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
                                                    if (value != null &&
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
                                                        value.trim().isEmpty) {
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
                                                                          dashboardController
                                                                              .selectedStateDiff
                                                                              .value,
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
                                                                          .value = entry
                                                                              .key;
                                                                      dashboardController
                                                                          .getShippingMethods();
                                                                    },
                                                                    value:
                                                                        entry
                                                                            .key,
                                                                    child: Text(
                                                                      entry
                                                                          .value,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                            function: (value) {
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
                                                        TextInputType.number,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Obx(
                              () =>
                                  dashboardController.saveProfile.value
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
                                            backgroundColor:
                                                AppColors.nakedSyrup,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 5,
                                            ),
                                            minimumSize: Size(Get.width, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            dashboardController.updateProfile();
                                          },
                                          child: Text(
                                            'Update Profile',
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 5,
                                  ),
                                  minimumSize: Size(Get.width, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  dashboardController.deActiveAcc();
                                },
                                child: Text(
                                  'Deactivate Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        Get.width >= 600
                                            ? getFontSize(context, -1)
                                            : getFontSize(context, -5),
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
