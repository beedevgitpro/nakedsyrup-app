import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../../NkedSyrps.dart';
import '../../Resources/AppColors.dart';
import '../../model/order_history_model.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../cart/cart_page.dart';
import '../category_page/product_list_page.dart';
import '../order_history/order_detail_page.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  DashboardController dashboardController = Get.put(DashboardController());

  final newVersion = NewVersionPlus(
    iOSId: 'nakedsyrups.com.au',
    androidId: 'nakedsyrups.com.au',
    androidPlayStoreCountry: "au_AU",
    androidHtmlReleaseNotes: true,
  );
  @override
  void initState() {
    dashboardController.getName();
    dashboardController.viewedProduct();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.findCategory();
      dashboardController.orderHistory();
      dashboardController.findCart();
      advancedStatusCheck(newVersion);
    });
    super.initState();
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update available',
        dialogText: 'Update app version',
        launchModeVersion: LaunchModeVersion.external,
        allowDismissal: false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: dashboardController.scaffolKey,
        appBar: AppBarWidget(
          'Dashboard',
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              dashboardController.scaffolKey.currentState?.openDrawer();
            },
          ),
          context,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Get.to(CartPage());
              },
            ),
          ],
        ),
        drawer: NakedSyrupsDrawer(),
        body: LiquidPullToRefresh(
          key: dashboardController.categoryPageRefreshIndicatorKey,
          onRefresh: dashboardController.handleRefresh,
          color: AppColors.nakedSyrup,
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: 6,
                  ),
                  child: Text(
                    'Hello, ${dashboardController.name.value} ',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      fontFamily: 'Euclid Circular B',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),

              Obx(() {
                if (dashboardController.getData.value) {
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
                  if (dashboardController
                          .categoryModel
                          .value
                          .categories
                          ?.isNotEmpty ==
                      true) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount:
                            dashboardController
                                .categoryModel
                                .value
                                .categories
                                ?.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.95,
                        ),
                        physics: ScrollPhysics(),

                        itemBuilder: (context, j) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                ProductListPage(
                                  categories:
                                      dashboardController
                                          .categoryModel
                                          .value
                                          .categories?[j],
                                ),
                              );
                            },
                            child:
                                dashboardController
                                            .categoryModel
                                            .value
                                            .categories?[j]
                                            .image
                                            ?.isNotEmpty ==
                                        true
                                    ? Image.network(
                                      dashboardController
                                              .categoryModel
                                              .value
                                              .categories?[j]
                                              .image ??
                                          "",
                                      fit: BoxFit.cover,
                                    )
                                    : dashboardController
                                            .categoryModel
                                            .value
                                            .categories?[j]
                                            .name
                                            .toString()
                                            .toLowerCase()
                                            .contains('flavourings') ==
                                        true
                                    ? Image.asset("assets/images/flovoring.png")
                                    : dashboardController
                                            .categoryModel
                                            .value
                                            .categories?[j]
                                            .name
                                            .toString()
                                            .toLowerCase()
                                            .contains('powders') ==
                                        true
                                    ? Image.asset("assets/images/powders.png")
                                    : dashboardController
                                            .categoryModel
                                            .value
                                            .categories?[j]
                                            .name
                                            .toString()
                                            .toLowerCase()
                                            .contains('merch') ==
                                        true
                                    ? Image.asset("assets/images/merch.png")
                                    : dashboardController
                                            .categoryModel
                                            .value
                                            .categories?[j]
                                            .name
                                            .toString()
                                            .toLowerCase()
                                            .contains('toppings') ==
                                        true
                                    ? Image.asset("assets/images/topping.png")
                                    : Image.asset("assets/images/Logo.png"),
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
                            "No Category",
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              fontFamily: 'Euclid Circular B',
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                    top: 5,
                                    // left: 15,
                                    // right: 15,
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

                                      if (j < 5) {
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
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          separatorBuilder: (
                                                            context,
                                                            i,
                                                          ) {
                                                            return SizedBox(
                                                              width: 10,
                                                            );
                                                          },
                                                          physics:
                                                              ScrollPhysics(),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Order  ${dashboardController.orderHistoryModel.value.orders?[j].status}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Placed on at $convertedDate",
                                                      ),
                                                      Text(
                                                        "\$${double.parse(dashboardController.orderHistoryModel.value.orders?[j].total.toString() ?? "0").toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors
                                                                  .nakedSyrup,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return Center(child: const SizedBox());
                              }
                            }
                          }),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                    //   Center(
                    //   child: Card(
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //         vertical: 8,
                    //         horizontal: 15,
                    //       ),
                    //       child: Text(
                    //         "No recent viewed products",
                    //         style: TextStyle(
                    //           fontSize: getFontSize(context, 3),
                    //           fontFamily: 'Montserrat',
                    //           fontWeight: FontWeight.bold,
                    //           color: AppColors.lightColor,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showNoInternetDialog(GlobalKey<ScaffoldState> scaffoldContext) {
  return showDialog<void>(
    context: scaffoldContext.currentContext!,
    barrierDismissible: false,
    // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.wifi_off, color: Colors.black),
            ),
            Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: getFontSize(context, 0),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'It appears you are offline.\nThis function is unavailable until connectivity resumes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: getFontSize(context, -2),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.redColor,
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      9.0,
                    ), // Adjust border radius as needed
                  ),
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    },
  );
}
