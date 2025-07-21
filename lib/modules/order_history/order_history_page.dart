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
  // CartPage({super.key, this.categories});
  // Categories? categories;
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
      dashboardController.findCart();
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
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 15,
                      right: 15,
                    ),
                    child: ListView.separated(
                      separatorBuilder: (context, ii) {
                        return Divider(color: AppColors.lightColor);
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              // width: Get.width * 0.6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: "Order Id: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: getFontSize(
                                                  context,
                                                  -1,
                                                ),
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      " #${dashboardController.orderHistoryModel.value.orders?[j].orderId}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.nakedSyrup,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: "Date: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: getFontSize(
                                                  context,
                                                  -2,
                                                ),
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: " ${convertedDate} ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.nakedSyrup,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: "Amount: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: getFontSize(
                                                  context,
                                                  -2,
                                                ),
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      " \$${double.parse(dashboardController.orderHistoryModel.value.orders?[j].total.toString() ?? "0").toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.nakedSyrup,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      dashboardController
                                              .orderHistoryModel
                                              .value
                                              .orders![j]
                                              .items!
                                              .isNotEmpty
                                          ? SizedBox(
                                            height: 70,
                                            child: ListView.separated(
                                              itemCount:
                                                  dashboardController
                                                      .orderHistoryModel
                                                      .value
                                                      .orders?[j]
                                                      .items
                                                      ?.length ??
                                                  0,
                                              separatorBuilder: (context, i) {
                                                return SizedBox(width: 10);
                                              },
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, x) {
                                                if (dashboardController
                                                        .orderHistoryModel
                                                        .value
                                                        .orders?[j]
                                                        .items?[x]
                                                        .image
                                                        .toString()
                                                        .isNotEmpty ==
                                                    true) {
                                                  return Image.network(
                                                    dashboardController
                                                            .orderHistoryModel
                                                            .value
                                                            .orders?[j]
                                                            .items?[x]
                                                            .image
                                                            .toString() ??
                                                        "",
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              },
                                            ),
                                          )
                                          : const SizedBox(),
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
                                              ? Colors.red
                                              : dashboardController
                                                      .orderHistoryModel
                                                      .value
                                                      .orders?[j]
                                                      .status
                                                      .toString() ==
                                                  "completed"
                                              ? Color(0XFF008000)
                                              : Color(0XFFFFBF00),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              dashboardController
                                                          .orderHistoryModel
                                                          .value
                                                          .orders?[j]
                                                          .status
                                                          .toString() ==
                                                      "cancelled"
                                                  ? Icons.cancel_outlined
                                                  : dashboardController
                                                          .orderHistoryModel
                                                          .value
                                                          .orders?[j]
                                                          .status
                                                          .toString() ==
                                                      "completed"
                                                  ? Icons.check_circle_outline
                                                  : Icons
                                                      .incomplete_circle_rounded,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              dashboardController
                                                      .orderHistoryModel
                                                      .value
                                                      .orders?[j]
                                                      .status
                                                      .toString() ??
                                                  "",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: getFontSize(
                                                  context,
                                                  -4,
                                                ),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Open Sans",
                                              ),
                                            ),
                                          ],
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
