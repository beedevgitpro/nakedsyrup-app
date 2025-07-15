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
    dashboardController.orderHistory();
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
                    child: ListView.builder(
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
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  Text(
                                    "Order Id:  ${dashboardController.orderHistoryModel.value.orders?[j].orderId}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Order  ${dashboardController.orderHistoryModel.value.orders?[j].status}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Placed on at $convertedDate"),
                                      Text(
                                        "\$${double.parse(dashboardController.orderHistoryModel.value.orders?[j].total.toString() ?? "0").toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.nakedSyrup,
                                        ),
                                      ),
                                    ],
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
