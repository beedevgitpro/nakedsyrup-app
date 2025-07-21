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
          actions: [dashboardController.cartUI()],
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
                          mainAxisSpacing: 10,
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),

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
                                      ? Image.asset(
                                        "assets/images/flovoring.jpg",
                                        fit: BoxFit.cover,
                                      )
                                      : dashboardController
                                              .categoryModel
                                              .value
                                              .categories?[j]
                                              .name
                                              .toString()
                                              .toLowerCase()
                                              .contains('powders') ==
                                          true
                                      ? Image.asset(
                                        "assets/images/powders.jpg",
                                        fit: BoxFit.cover,
                                      )
                                      : dashboardController
                                              .categoryModel
                                              .value
                                              .categories?[j]
                                              .name
                                              .toString()
                                              .toLowerCase()
                                              .contains('merch') ==
                                          true
                                      ? Image.asset(
                                        "assets/images/merch.jpg",
                                        fit: BoxFit.cover,
                                      )
                                      : dashboardController
                                              .categoryModel
                                              .value
                                              .categories?[j]
                                              .name
                                              .toString()
                                              .toLowerCase()
                                              .contains('toppings') ==
                                          true
                                      ? Image.asset(
                                        "assets/images/topping.jpg",
                                        fit: BoxFit.cover,
                                      )
                                      : Image.asset(
                                        "assets/images/Logo.jpg",
                                        fit: BoxFit.cover,
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
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              fontSize: getFontSize(context, 2),
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
                                  child: ListView.separated(
                                    separatorBuilder: (context, ii) {
                                      return Divider(
                                        color: AppColors.lightColor,
                                      );
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
                                      List<String> parts = convertedDate.split(
                                        RegExp(r'[\s,:]+'),
                                      );

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
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width:
                                                  Get.width >= 600
                                                      ? Get.width * 0.6
                                                      : Get.width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Order Id: ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                                fontSize:
                                                                    getFontSize(
                                                                      context,
                                                                      -2,
                                                                    ),
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      " #${dashboardController.orderHistoryModel.value.orders?[j].orderId}",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Date: ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                                fontSize:
                                                                    getFontSize(
                                                                      context,
                                                                      -2,
                                                                    ),
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      " ${parts[0]} ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " ${parts[1]} ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " ${parts[2]} ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " ${parts[3]} ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " ${parts[4]} ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      " ${parts[5]} ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Amount: ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                                fontSize:
                                                                    getFontSize(
                                                                      context,
                                                                      -2,
                                                                    ),
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      " \$${double.parse(dashboardController.orderHistoryModel.value.orders?[j].total.toString() ?? "0").toStringAsFixed(2)}",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .nakedSyrup,
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
                                                              ? Color(
                                                                0XFF008000,
                                                              )
                                                              : Color(
                                                                0XFFFFBF00,
                                                              ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            9,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              top: 5,
                                                              bottom: 5,
                                                            ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              dashboardController
                                                                          .orderHistoryModel
                                                                          .value
                                                                          .orders?[j]
                                                                          .status
                                                                          .toString() ==
                                                                      "cancelled"
                                                                  ? Icons
                                                                      .cancel_outlined
                                                                  : dashboardController
                                                                          .orderHistoryModel
                                                                          .value
                                                                          .orders?[j]
                                                                          .status
                                                                          .toString() ==
                                                                      "completed"
                                                                  ? Icons
                                                                      .check_circle_outline
                                                                  : Icons
                                                                      .incomplete_circle_rounded,
                                                              size: getFontSize(
                                                                context,
                                                                -0,
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  getFontSize(
                                                                    context,
                                                                    -15,
                                                                  ),
                                                            ),
                                                            Text(
                                                              dashboardController
                                                                      .orderHistoryModel
                                                                      .value
                                                                      .orders?[j]
                                                                      .status
                                                                      .toString() ??
                                                                  "",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize:
                                                                    getFontSize(
                                                                      context,
                                                                      -5,
                                                                    ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Open Sans",
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
