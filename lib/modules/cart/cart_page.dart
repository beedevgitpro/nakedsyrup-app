import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:naked_syrups/modules/cart/check_out_page.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../service.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/mandtory_text_lables.dart';
import '../../widgets/text_form_fields.dart';

class CartPage extends StatefulWidget {
  // CartPage({super.key, this.categories});
  // Categories? categories;
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DashboardController dashboardController = Get.put(DashboardController());
  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((_) {
      dashboardController.findCart();
      dashboardController.getCountryList();
    });
    if (dashboardController.cartModel.value.coupons?.isNotEmpty == true) {
      if (dashboardController.cartModel.value.coupons?[0].code?.isNotEmpty ==
          true) {
        dashboardController.promoCodeController.text =
            (dashboardController.cartModel.value.coupons?[0].code ?? "")
                .toUpperCase();
        dashboardController.promoCodeFiled.value = true;
      } else {
        dashboardController.promoCodeFiled.value = false;
      }
    } else {
      dashboardController.promoCodeFiled.value = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        'Your Cart',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        context,
      ),
      body: LiquidPullToRefresh(
        key: dashboardController.cartRefreshIndicatorKey,
        onRefresh: dashboardController.cartRefresh,
        color: AppColors.nakedSyrup,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(() {
              if (dashboardController.getCart.value) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: AppColors.greenColor,
                      ),
                    ),
                  ),
                );
              } else {
                if (dashboardController.cartModel.value.cartItems?.isNotEmpty ==
                    true) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 15,
                      right: 15,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              dashboardController
                                  .cartModel
                                  .value
                                  .cartItems
                                  ?.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, j) {
                            int quntity = int.parse(
                              dashboardController
                                      .cartModel
                                      .value
                                      .cartItems?[j]
                                      .quantity
                                      .toString() ??
                                  "",
                            );
                            return Stack(
                              children: [
                                Card(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                          dashboardController
                                                  .cartModel
                                                  .value
                                                  .cartItems?[j]
                                                  .productImage ??
                                              "",

                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(width: 25),
                                      SizedBox(
                                        width: Get.width - 190,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "${dashboardController.cartModel.value.cartItems?[j].productName ?? ""}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          Get.width >= 600
                                                              ? getFontSize(
                                                                context,
                                                                2,
                                                              )
                                                              : getFontSize(
                                                                context,
                                                                -1,
                                                              ),
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    // textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Text(
                                                  dashboardController
                                                              .cartModel
                                                              .value
                                                              .cartItems?[j]
                                                              .regularPrice !=
                                                          null
                                                      ? "\$${double.parse(dashboardController.cartModel.value.cartItems?[j].regularPrice.toString() ?? "0.0").toStringAsFixed(2)}"
                                                      : "0.0",
                                                  style: TextStyle(
                                                    color: AppColors.nakedSyrup,
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontSize:
                                                        Get.width >= 600
                                                            ? getFontSize(
                                                              context,
                                                              2,
                                                            )
                                                            : getFontSize(
                                                              context,
                                                              -1,
                                                            ),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    quntity = quntity - 1;
                                                    dashboardController
                                                        .cartQuantityUpdate(
                                                          dashboardController
                                                              .cartModel
                                                              .value
                                                              .cartItems?[j]
                                                              .productId,
                                                          quntity,
                                                          dashboardController
                                                              .cartModel
                                                              .value
                                                              .cartItems?[j]
                                                              .variationId,
                                                        );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.nakedSyrup,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            3.0,
                                                          ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size:
                                                            Get.width >= 600
                                                                ? getFontSize(
                                                                  context,
                                                                  2,
                                                                )
                                                                : getFontSize(
                                                                  context,
                                                                  -1,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    3.0,
                                                  ),
                                                  child: Text(
                                                    quntity.toString() ?? "",
                                                    style: TextStyle(
                                                      fontSize:
                                                          Get.width >= 600
                                                              ? getFontSize(
                                                                context,
                                                                2,
                                                              )
                                                              : getFontSize(
                                                                context,
                                                                -1,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                InkWell(
                                                  onTap: () {
                                                    quntity = quntity + 1;
                                                    dashboardController
                                                        .cartQuantityUpdate(
                                                          dashboardController
                                                              .cartModel
                                                              .value
                                                              .cartItems?[j]
                                                              .productId,
                                                          quntity,
                                                          dashboardController
                                                              .cartModel
                                                              .value
                                                              .cartItems?[j]
                                                              .variationId,
                                                        );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.nakedSyrup,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            3.0,
                                                          ),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size:
                                                            Get.width >= 600
                                                                ? getFontSize(
                                                                  context,
                                                                  2,
                                                                )
                                                                : getFontSize(
                                                                  context,
                                                                  -1,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: () {
                                      dashboardController.deleteCartItem(
                                        dashboardController
                                            .cartModel
                                            .value
                                            .cartItems?[j]
                                            .productId,
                                      );
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: textLabel('Promo code', context, false),
                        ),
                        AppTextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: dashboardController.promoCodeController,
                          onChanged: (value) {
                            if (value.toString().trim().isNotEmpty) {
                              dashboardController.promoCodeFiled.value = true;
                            } else {
                              dashboardController.promoCodeFiled.value = false;
                            }
                          },
                          lable: 'Enter Promo code',
                          function: (value) {},
                        ),
                        Obx(
                          () =>
                              dashboardController.promoCodeFiled.value
                                  ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            minimumSize: WidgetStatePropertyAll(
                                              Size((Get.width / 2) - 30, 45),
                                            ),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                  AppColors.nakedSyrup,
                                                ),
                                          ),
                                          onPressed: () async {
                                            dashboardController.getCart.value =
                                                true;
                                            var verify = await ApiClass()
                                                .applyCoupon(
                                                  dashboardController
                                                      .promoCodeController
                                                      .text,
                                                );
                                            dashboardController.getCart.value =
                                                true;
                                            if (verify != null) {
                                              if (verify['success'] == true) {
                                                dashboardController.findCart();
                                              } else {
                                                dashboardController
                                                    .getCart
                                                    .value = false;
                                              }
                                            } else {
                                              dashboardController
                                                  .getCart
                                                  .value = false;
                                            }
                                          },
                                          child: Text(
                                            "Apply",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            minimumSize: WidgetStatePropertyAll(
                                              Size((Get.width / 2) - 30, 45),
                                            ),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                  Colors.red,
                                                ),
                                          ),
                                          onPressed: () async {
                                            if (dashboardController
                                                        .cartModel
                                                        .value
                                                        .discountTotal !=
                                                    null &&
                                                dashboardController
                                                        .cartModel
                                                        .value
                                                        .discountTotal !=
                                                    0.0) {
                                              dashboardController
                                                  .getCart
                                                  .value = true;
                                              var verify = await ApiClass()
                                                  .removeCoupon('');
                                              dashboardController
                                                  .getCart
                                                  .value = true;
                                              if (verify != null) {
                                                if (verify['success'] == true) {
                                                  dashboardController
                                                      .findCart();
                                                  dashboardController
                                                      .promoCodeFiled
                                                      .value = false;
                                                  dashboardController
                                                      .promoCodeController
                                                      .clear();
                                                } else {
                                                  dashboardController
                                                      .getCart
                                                      .value = false;
                                                }
                                              } else {
                                                dashboardController
                                                    .getCart
                                                    .value = false;
                                              }
                                            } else {
                                              dashboardController
                                                  .promoCodeFiled
                                                  .value = false;
                                              dashboardController
                                                  .promoCodeController
                                                  .clear();
                                            }
                                          },
                                          child: Text(
                                            "Remove",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : const SizedBox(),
                        ),
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
                          "Your Cart is Empty!",
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
      ),
      bottomNavigationBar: Obx(
        () =>
            dashboardController.cartModel.value.cartItems?.isNotEmpty == true &&
                    dashboardController.getCart.value == false
                ? Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: SizedBox(
                    height: 180,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Sub Total : ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  dashboardController
                                              .cartModel
                                              .value
                                              .cartTotal !=
                                          null
                                      ? "\$${double.parse(dashboardController.cartModel.value.cartTotal.toString() ?? "0.0").toStringAsFixed(2)}"
                                      : "0.0",
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "GST : ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "\$${double.parse(dashboardController.cartModel.value.gstTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  dashboardController
                                                  .cartModel
                                                  .value
                                                  .discountTotal !=
                                              null &&
                                          dashboardController
                                                  .cartModel
                                                  .value
                                                  .discountTotal !=
                                              0.0
                                      ? 3
                                      : 0,
                            ),
                            dashboardController.cartModel.value.discountTotal !=
                                        null &&
                                    dashboardController
                                            .cartModel
                                            .value
                                            .discountTotal !=
                                        0.0
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Discount : ",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "- \$${double.parse(dashboardController.cartModel.value.discountTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: AppColors.nakedSyrup,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                                : const SizedBox(),
                            SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Grant Total : ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  dashboardController
                                              .cartModel
                                              .value
                                              .grandTotal !=
                                          null
                                      ? "\$${double.parse(dashboardController.cartModel.value.grandTotal.toString() ?? "0.0").toStringAsFixed(2)}"
                                      : '0.0',
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.nakedSyrup,
                            ),
                          ),
                          onPressed: () {
                            dashboardController.getBillingDetails();
                            Get.to(CheckOutPage());
                          },
                          child: Text(
                            "Proceed To Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : const SizedBox(),
      ),
    );
  }
}
