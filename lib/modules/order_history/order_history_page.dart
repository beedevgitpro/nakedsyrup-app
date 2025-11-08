import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../model/order_history_model.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../dashboard_flow/dashboard.dart';
import 'order_detail_page.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  DashboardController dashboardController = Get.put(DashboardController());
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.orderHistory();
      // dashboardController.findCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        'Order History',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.offAll(const DashboardPage());
          },
        ),
        context,
        actions: [dashboardController.cartUI()],
      ),
      body: LiquidPullToRefresh(
        key: dashboardController.orderHistoryIndicatorKey,
        onRefresh: dashboardController.historyRefresh,
        color: AppColors.nakedSyrup,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(() {
              if (dashboardController.getHistory.value) {
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
                        .orderHistoryModel
                        .value
                        .orders
                        ?.isNotEmpty ==
                    true) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                      left: getFontSize(context, 2),
                      right: getFontSize(context, 2),
                    ),
                    child: ListView.separated(
                      separatorBuilder: (context, ii) {
                        return const SizedBox(height: 25);
                      },
                      shrinkWrap: true,
                      itemCount:
                          dashboardController
                              .orderHistoryModel
                              .value
                              .orders
                              ?.length ??
                          0,

                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, j) {
                        String date =
                            dashboardController
                                .orderHistoryModel
                                .value
                                .orders?[j]
                                .orderDate
                                .toString() ??
                            "";
                        String convertedDate = DateFormat(
                          "dd MMM yyyy, hh:mm a",
                        ).format(DateTime.parse(date));
                        return InkWell(
                          onTap: () {
                            Get.to(
                              OrderDetailPage(
                                orders:
                                    dashboardController
                                        .orderHistoryModel
                                        .value
                                        .orders?[j] ??
                                    Orders(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.yellowColor.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.yellowColor.withOpacity(0.5),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(getFontSize(context, -4)),
                              child:
                                  Get.width < 600
                                      ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              dashboardController
                                                      .orderHistoryModel
                                                      .value
                                                      .orders![j]
                                                      .items!
                                                      .isNotEmpty
                                                  ? Container(
                                                    decoration: BoxDecoration(
                                                      // color: AppColors.yellowColor.withOpacity(0.02),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .yellowColor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    height:
                                                        (getFontSize(
                                                              context,
                                                              2,
                                                            ) *
                                                            4),
                                                    child: ListView.separated(
                                                      itemCount:
                                                          dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .items
                                                              ?.length ??
                                                          0,
                                                      separatorBuilder: (
                                                        context,
                                                        i,
                                                      ) {
                                                        return SizedBox(
                                                          width: 0,
                                                        );
                                                      },
                                                      physics: ScrollPhysics(),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder: (
                                                        context,
                                                        x,
                                                      ) {
                                                        if (dashboardController
                                                                    .orderHistoryModel
                                                                    .value
                                                                    .orders?[j]
                                                                    .items?[x]
                                                                    .image
                                                                    .toString()
                                                                    .isNotEmpty ==
                                                                true &&
                                                            x == 0) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                            child: CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl:
                                                                  dashboardController
                                                                      .orderHistoryModel
                                                                      .value
                                                                      .orders?[j]
                                                                      .items?[x]
                                                                      .image
                                                                      .toString() ??
                                                                  "",
                                                              placeholder:
                                                                  (
                                                                    context,
                                                                    url,
                                                                  ) => CircularProgressIndicator(
                                                                    color:
                                                                        Colors
                                                                            .transparent,
                                                                  ),
                                                              errorWidget:
                                                                  (
                                                                    context,
                                                                    url,
                                                                    error,
                                                                  ) => Icon(
                                                                    Icons.error,
                                                                  ),
                                                            ),
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      },
                                                    ),
                                                  )
                                                  : const SizedBox(),

                                              const SizedBox(width: 8),
                                              SizedBox(
                                                height:
                                                    (getFontSize(context, 2) *
                                                        4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "Order ID: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black,
                                                          fontSize: getFontSize(
                                                            context,
                                                            -2,
                                                          ),
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                " #${dashboardController.orderHistoryModel.value.orders?[j].orderNumber}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColors
                                                                      .nakedSyrup,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "Date: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              AppColors
                                                                  .fontLightColor,
                                                          fontSize: getFontSize(
                                                            context,
                                                            -4,
                                                          ),
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                " ${convertedDate} ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  AppColors
                                                                      .fontLightColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "Amount: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              AppColors
                                                                  .fontLightColor,
                                                          fontSize: getFontSize(
                                                            context,
                                                            -4,
                                                          ),
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                " \$${double.parse(dashboardController.orderHistoryModel.value.orders?[j].total.toString() ?? "0").toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  AppColors
                                                                      .fontLightColor,
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
                                          const SizedBox(height: 8),
                                          Container(
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color:
                                                  dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .status
                                                              .toString() ==
                                                          "cancelled"
                                                      ? AppColors.redColor
                                                          .withOpacity(0.15)
                                                      : dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .status
                                                              .toString() ==
                                                          "completed"
                                                      ? Color(
                                                        0XFF3FD75A,
                                                      ).withOpacity(0.2)
                                                      : Color(
                                                        0XFFFFAE00,
                                                      ).withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 8,
                                                  bottom: 8,
                                                ),
                                                child: Text(
                                                  (dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .status
                                                              .toString() ??
                                                          "")
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color:
                                                        dashboardController
                                                                    .orderHistoryModel
                                                                    .value
                                                                    .orders?[j]
                                                                    .status
                                                                    .toString() ==
                                                                "cancelled"
                                                            ? AppColors.redColor
                                                            : dashboardController
                                                                    .orderHistoryModel
                                                                    .value
                                                                    .orders?[j]
                                                                    .status
                                                                    .toString() ==
                                                                "completed"
                                                            ? Color(0XFF3FD75A)
                                                            : Color(0XFFFFAE00),
                                                    fontSize: getFontSize(
                                                      context,
                                                      -4,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Euclid Circular B",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              dashboardController
                                                      .orderHistoryModel
                                                      .value
                                                      .orders![j]
                                                      .items!
                                                      .isNotEmpty
                                                  ? Container(
                                                    decoration: BoxDecoration(
                                                      // color: AppColors.yellowColor.withOpacity(0.02),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .yellowColor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    height:
                                                        (getFontSize(
                                                              context,
                                                              2,
                                                            ) *
                                                            6),
                                                    child: ListView.separated(
                                                      itemCount:
                                                          dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .items
                                                              ?.length ??
                                                          0,
                                                      separatorBuilder: (
                                                        context,
                                                        i,
                                                      ) {
                                                        return SizedBox(
                                                          width: 0,
                                                        );
                                                      },
                                                      physics: ScrollPhysics(),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder: (
                                                        context,
                                                        x,
                                                      ) {
                                                        if (dashboardController
                                                                    .orderHistoryModel
                                                                    .value
                                                                    .orders?[j]
                                                                    .items?[x]
                                                                    .image
                                                                    .toString()
                                                                    .isNotEmpty ==
                                                                true &&
                                                            x == 0) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                            child: CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl:
                                                                  dashboardController
                                                                      .orderHistoryModel
                                                                      .value
                                                                      .orders?[j]
                                                                      .items?[x]
                                                                      .image
                                                                      .toString() ??
                                                                  "",
                                                              placeholder:
                                                                  (
                                                                    context,
                                                                    url,
                                                                  ) => CircularProgressIndicator(
                                                                    color:
                                                                        Colors
                                                                            .transparent,
                                                                  ),
                                                              errorWidget:
                                                                  (
                                                                    context,
                                                                    url,
                                                                    error,
                                                                  ) => Icon(
                                                                    Icons.error,
                                                                  ),
                                                            ),
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      },
                                                    ),
                                                  )
                                                  : const SizedBox(),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                height:
                                                    (getFontSize(context, 2) *
                                                        6),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "Order ID: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black,
                                                          fontSize: getFontSize(
                                                            context,
                                                            2,
                                                          ),
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                " #${dashboardController.orderHistoryModel.value.orders?[j].orderId}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColors
                                                                      .nakedSyrup,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "Date: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              AppColors
                                                                  .fontLightColor,
                                                          fontSize: getFontSize(
                                                            context,
                                                            0,
                                                          ),
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                " ${convertedDate} ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  AppColors
                                                                      .fontLightColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "Amount: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              AppColors
                                                                  .fontLightColor,
                                                          fontSize: getFontSize(
                                                            context,
                                                            0,
                                                          ),
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                " \$${double.parse(dashboardController.orderHistoryModel.value.orders?[j].total.toString() ?? "0").toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  AppColors
                                                                      .fontLightColor,
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
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .status
                                                              .toString() ==
                                                          "cancelled"
                                                      ? AppColors.redColor
                                                          .withOpacity(0.15)
                                                      : dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .status
                                                              .toString() ==
                                                          "completed"
                                                      ? Color(
                                                        0XFF3FD75A,
                                                      ).withOpacity(0.2)
                                                      : Color(
                                                        0XFFFFAE00,
                                                      ).withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 10,
                                                  bottom: 10,
                                                ),
                                                child: Text(
                                                  (dashboardController
                                                              .orderHistoryModel
                                                              .value
                                                              .orders?[j]
                                                              .status
                                                              .toString() ??
                                                          "")
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color:
                                                        dashboardController
                                                                    .orderHistoryModel
                                                                    .value
                                                                    .orders?[j]
                                                                    .status
                                                                    .toString() ==
                                                                "cancelled"
                                                            ? AppColors.redColor
                                                            : dashboardController
                                                                    .orderHistoryModel
                                                                    .value
                                                                    .orders?[j]
                                                                    .status
                                                                    .toString() ==
                                                                "completed"
                                                            ? Color(0XFF3FD75A)
                                                            : Color(0XFFFFAE00),
                                                    fontSize: getFontSize(
                                                      context,
                                                      0,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Euclid Circular B",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        );
                      },
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
                          "Order history not available!",
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
    );
  }
}
