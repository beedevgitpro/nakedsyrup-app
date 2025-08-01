import 'package:cached_network_image/cached_network_image.dart';
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
    iOSId: '6745474779',
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
      checkVersionStatus(
        status.localVersion,
        status.storeVersion,
        status,
        newVersion,
      );
    }
  }

  bool isUpdateAvailable(String localVersion, String storeVersion) {
    List<String> localParts = localVersion.split('.');
    List<String> storeParts = storeVersion.split('.');

    int maxLength =
        localParts.length > storeParts.length
            ? localParts.length
            : storeParts.length;

    for (int i = 0; i < maxLength; i++) {
      int localPart = i < localParts.length ? int.parse(localParts[i]) : 0;
      int storePart = i < storeParts.length ? int.parse(storeParts[i]) : 0;

      if (storePart > localPart) return true;
      if (storePart < localPart) return false;
    }

    return false; // Versions are equal
  }

  void checkVersionStatus(
    String localVersion,
    String storeVersion,
    status,
    newVersion,
  ) {
    if (isUpdateAvailable(localVersion, storeVersion)) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Available',
        dialogText:
            'You can update this app from ${localVersion} to ${storeVersion}',
        launchModeVersion: LaunchModeVersion.external,
        allowDismissal: true,
      );
    } else {
      debugPrint("App is up to date");
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
                                      ? CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            dashboardController
                                                .categoryModel
                                                .value
                                                .categories?[j]
                                                .image ??
                                            "",
                                        placeholder:
                                            (context, url) =>
                                                CircularProgressIndicator(
                                                  color: Colors.transparent,
                                                ),
                                        errorWidget:
                                            (context, url, error) =>
                                                Icon(Icons.error),
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
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              // left: 15,
                              // right: 15,
                            ),
                            child: ListView.separated(
                              separatorBuilder: (context, ii) {
                                return const SizedBox(height: 20);
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.yellowColor
                                            .withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: AppColors.yellowColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          getFontSize(context, -4),
                                        ),
                                        child:
                                            Get.width < 600
                                                ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                      .withOpacity(
                                                                        0.5,
                                                                      ),
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
                                                                physics:
                                                                    ScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
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
                                                                        fit:
                                                                            BoxFit.cover,
                                                                        imageUrl:
                                                                            dashboardController.orderHistoryModel.value.orders?[j].items?[x].image.toString() ??
                                                                            "",
                                                                        placeholder:
                                                                            (
                                                                              context,
                                                                              url,
                                                                            ) => CircularProgressIndicator(
                                                                              color:
                                                                                  Colors.transparent,
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

                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              (getFontSize(
                                                                    context,
                                                                    2,
                                                                  ) *
                                                                  4),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Order ID: ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                    fontSize:
                                                                        getFontSize(
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
                                                                            FontWeight.w700,
                                                                        color:
                                                                            AppColors.nakedSyrup,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Date: ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color:
                                                                        AppColors
                                                                            .fontLightColor,
                                                                    fontSize:
                                                                        getFontSize(
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
                                                                            FontWeight.normal,
                                                                        color:
                                                                            AppColors.fontLightColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Amount: ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color:
                                                                        AppColors
                                                                            .fontLightColor,
                                                                    fontSize:
                                                                        getFontSize(
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
                                                                            FontWeight.normal,
                                                                        color:
                                                                            AppColors.fontLightColor,
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
                                                                ? AppColors
                                                                    .redColor
                                                                    .withOpacity(
                                                                      0.15,
                                                                    )
                                                                : dashboardController
                                                                        .orderHistoryModel
                                                                        .value
                                                                        .orders?[j]
                                                                        .status
                                                                        .toString() ==
                                                                    "completed"
                                                                ? Color(
                                                                  0XFF3FD75A,
                                                                ).withOpacity(
                                                                  0.2,
                                                                )
                                                                : Color(
                                                                  0XFFFFAE00,
                                                                ).withOpacity(
                                                                  0.2,
                                                                ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
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
                                                                      ? AppColors
                                                                          .redColor
                                                                      : dashboardController
                                                                              .orderHistoryModel
                                                                              .value
                                                                              .orders?[j]
                                                                              .status
                                                                              .toString() ==
                                                                          "completed"
                                                                      ? Color(
                                                                        0XFF3FD75A,
                                                                      )
                                                                      : Color(
                                                                        0XFFFFAE00,
                                                                      ),
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -4,
                                                                  ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                                      .withOpacity(
                                                                        0.5,
                                                                      ),
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
                                                                physics:
                                                                    ScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
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
                                                                        fit:
                                                                            BoxFit.cover,
                                                                        imageUrl:
                                                                            dashboardController.orderHistoryModel.value.orders?[j].items?[x].image.toString() ??
                                                                            "",
                                                                        placeholder:
                                                                            (
                                                                              context,
                                                                              url,
                                                                            ) => CircularProgressIndicator(
                                                                              color:
                                                                                  Colors.transparent,
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
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              (getFontSize(
                                                                    context,
                                                                    2,
                                                                  ) *
                                                                  6),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Order ID: ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                    fontSize:
                                                                        getFontSize(
                                                                          context,
                                                                          2,
                                                                        ),
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          " #${dashboardController.orderHistoryModel.value.orders?[j].orderNumber}",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color:
                                                                            AppColors.nakedSyrup,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Date: ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color:
                                                                        AppColors
                                                                            .fontLightColor,
                                                                    fontSize:
                                                                        getFontSize(
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
                                                                            FontWeight.normal,
                                                                        color:
                                                                            AppColors.fontLightColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Amount: ",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color:
                                                                        AppColors
                                                                            .fontLightColor,
                                                                    fontSize:
                                                                        getFontSize(
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
                                                                            FontWeight.normal,
                                                                        color:
                                                                            AppColors.fontLightColor,
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
                                                                ? AppColors
                                                                    .redColor
                                                                    .withOpacity(
                                                                      0.15,
                                                                    )
                                                                : dashboardController
                                                                        .orderHistoryModel
                                                                        .value
                                                                        .orders?[j]
                                                                        .status
                                                                        .toString() ==
                                                                    "completed"
                                                                ? Color(
                                                                  0XFF3FD75A,
                                                                ).withOpacity(
                                                                  0.2,
                                                                )
                                                                : Color(
                                                                  0XFFFFAE00,
                                                                ).withOpacity(
                                                                  0.2,
                                                                ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
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
                                                                      ? AppColors
                                                                          .redColor
                                                                      : dashboardController
                                                                              .orderHistoryModel
                                                                              .value
                                                                              .orders?[j]
                                                                              .status
                                                                              .toString() ==
                                                                          "completed"
                                                                      ? Color(
                                                                        0XFF3FD75A,
                                                                      )
                                                                      : Color(
                                                                        0XFFFFAE00,
                                                                      ),
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    0,
                                                                  ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
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
