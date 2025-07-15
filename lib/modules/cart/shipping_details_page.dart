import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';

class ShippingDetailsPage extends StatefulWidget {
  const ShippingDetailsPage({super.key});

  @override
  State<ShippingDetailsPage> createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        'Shipping Details',
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
            if (dashboardController.getShipping.value) {
              return Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(color: AppColors.greenColor),
                ),
              );
            } else {
              if (dashboardController.cartModel.value.cartItems?.isNotEmpty ==
                  true) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            dashboardController
                                .shippingMethodsModel
                                .value
                                .shippingMethods
                                ?.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, j) {
                          return Card(
                            child: Obx(
                              () => RadioListTile(
                                activeColor: AppColors.nakedSyrup,
                                value:
                                    dashboardController
                                        .shippingMethodsModel
                                        .value
                                        .shippingMethods?[j]
                                        .id,
                                groupValue:
                                    dashboardController.shippingMethods.value,
                                onChanged: (value) {
                                  dashboardController.shippingMethods.value =
                                      value!;
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
                                  "\$${dashboardController.shippingMethodsModel.value.shippingMethods?[j].costRaw}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.nakedSyrup,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
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
                                : ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      AppColors.nakedSyrup,
                                    ),
                                  ),
                                  onPressed: () {
                                    dashboardController.placeOrderApi();
                                  },
                                  child: Text(
                                    'Place Order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                      ),
                      // SizedBox(height: 30),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      child: Text(
                        "Your Shipping is Empty!",
                        style: TextStyle(
                          fontSize: getFontSize(context, 3),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightColor,
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }
}
