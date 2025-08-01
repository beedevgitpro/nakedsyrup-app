import 'package:cached_network_image/cached_network_image.dart';
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.yellowColor.withOpacity(
                                      0.25,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.nakedSyrup.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(
                                    getFontSize(context, -6),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              dashboardController
                                                  .cartModel
                                                  .value
                                                  .cartItems?[j]
                                                  .productImage ??
                                              "",
                                          placeholder:
                                              (context, url) =>
                                                  CircularProgressIndicator(
                                                    color: Colors.transparent,
                                                  ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Icon(Icons.error),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      SizedBox(
                                        width: Get.width - 190,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          Get.width >= 600
                                                              ? getFontSize(
                                                                context,
                                                                0,
                                                              )
                                                              : getFontSize(
                                                                context,
                                                                -4,
                                                              ),
                                                      color: Colors.black,
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
                                            const SizedBox(height: 8),
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
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: AppColors
                                                            .nakedSyrup
                                                            .withOpacity(0.8),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.remove,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(width: 10),
                                                Text(
                                                  quntity.toString() ?? "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontSize: getFontSize(
                                                      context,
                                                      -4,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
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
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: AppColors
                                                            .nakedSyrup
                                                            .withOpacity(0.8),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.add,
                                                      size: 24,
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.nakedSyrup,
                                            minimumSize: Size(
                                              (Get.width / 2) - 30,
                                              45,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 5,
                                            ),
                                            minimumSize: Size(
                                              (Get.width / 2) - 30,
                                              45,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                    height: (getFontSize(context, 0) * 9),
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
                                    color: Colors.black,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.w600,
                                    fontSize: getFontSize(context, -2),
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
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(context, -2),
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
                                    color: Colors.black,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.w600,
                                    fontSize: getFontSize(context, -2),
                                  ),
                                ),
                                Text(
                                  "\$${double.parse(dashboardController.cartModel.value.gstTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(context, -2),
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
                                        color: Colors.black,
                                        fontFamily: 'Euclid Circular B',
                                        fontWeight: FontWeight.w600,
                                        fontSize: getFontSize(context, -2),
                                      ),
                                    ),
                                    Text(
                                      "- \$${double.parse(dashboardController.cartModel.value.discountTotal.toString() ?? "0.0").toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: AppColors.nakedSyrup,
                                        fontFamily: 'Euclid Circular B',
                                        fontWeight: FontWeight.bold,
                                        fontSize: getFontSize(context, -2),
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
                                    color: Colors.black,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.w600,
                                    fontSize: getFontSize(context, -2),
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
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(context, -2),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.nakedSyrup,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                              fontWeight: FontWeight.bold,
                              fontSize: getFontSize(context, -5),
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
