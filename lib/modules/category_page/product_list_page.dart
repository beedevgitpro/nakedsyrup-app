import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:naked_syrups/model/product_model.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../model/category_model.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import 'product_page.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage({super.key, this.categories});
  Categories? categories;
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  DashboardController dashboardController = Get.put(DashboardController());
  @override
  void initState() {
    // TODO: implement initState
    dashboardController.fetchDataForTab(widget.categories?.slug);
    dashboardController.findCart();
    super.initState();
  }

  Future<void> handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    dashboardController.fetchDataForTab(widget.categories?.slug);
    return completer.future.then<void>((_) {
      Get.snackbar(
        'Refresh complete',
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    });
  }

  double? getLowestPrice(List<Variations> variations) {
    final prices =
        variations
            .map((v) => double.tryParse(v.price ?? ''))
            .where((p) => p != null)
            .cast<double>()
            .toList();

    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  double? getHighestPrice(List<Variations> variations) {
    final prices =
        variations
            .map((v) => double.tryParse(v.price ?? ''))
            .where((p) => p != null)
            .cast<double>()
            .toList();

    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        '${widget.categories?.name}',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        context,
        actions: [dashboardController.cartUI()],
      ),
      body: LiquidPullToRefresh(
        key: dashboardController.productListRefreshIndicatorKey,
        onRefresh: handleRefresh,
        color: AppColors.nakedSyrup,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(() {
              if (dashboardController.getProduct.value) {
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
                        .productModel
                        .value
                        .products
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
                              .productModel
                              .value
                              .products
                              ?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Get.width >= 600 ? 3 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      physics: ScrollPhysics(),

                      itemBuilder: (context, j) {
                        String price = "";
                        int selectedd = -1;
                        if (dashboardController
                                .productModel
                                .value
                                .products?[j]
                                .variations
                                ?.isNotEmpty ==
                            true) {
                          String lowPrice =
                              (getLowestPrice(
                                        dashboardController
                                                .productModel
                                                .value
                                                .products?[j]
                                                .variations ??
                                            [],
                                      ) ??
                                      0.0)
                                  .toStringAsFixed(2)
                                  .toString();
                          String highPrice =
                              (getHighestPrice(
                                        dashboardController
                                                .productModel
                                                .value
                                                .products?[j]
                                                .variations ??
                                            [],
                                      ) ??
                                      0.0)
                                  .toStringAsFixed(2)
                                  .toString();
                          if (highPrice == lowPrice) {
                            price = "\$${lowPrice}";
                          } else {
                            price = "\$${lowPrice} - \$${highPrice}";
                          }
                        } else {
                          price =
                              "\$${double.parse(dashboardController.productModel.value.products?[j].price ?? "0").toStringAsFixed(2)}";
                        }
                        return InkWell(
                          onTap: () {
                            Get.to(
                              ProductPage(
                                products:
                                    dashboardController
                                        .productModel
                                        .value
                                        .products?[j] ??
                                    Products(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.nakedSyrup.withOpacity(0.3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 5),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              dashboardController
                                                  .productModel
                                                  .value
                                                  .products?[j]
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
                                        ),
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "${dashboardController.productModel.value.products?[j].name ?? ""} (${dashboardController.productModel.value.products?[j].sku ?? ""})",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          Get.width >= 600
                                              ? getFontSize(context, 0)
                                              : getFontSize(context, -4),
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      "${price}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.nakedSyrup,
                                        fontSize:
                                            Get.width >= 600
                                                ? getFontSize(context, -1)
                                                : getFontSize(context, -5),
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () =>
                                        dashboardController.addToBasket.value ==
                                                    true &&
                                                selectedd == j
                                            ? SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: CircularProgressIndicator(
                                                color: AppColors.greenColor,
                                              ),
                                            )
                                            : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    dashboardController.cartModel.value.cartItems?.any(
                                                              (item) =>
                                                                  item.productId
                                                                      .toString() ==
                                                                  dashboardController
                                                                      .productModel
                                                                      .value
                                                                      .products?[j]
                                                                      .id
                                                                      .toString(),
                                                            ) ??
                                                            false
                                                        ? Colors.green
                                                        : AppColors.nakedSyrup,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 5,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (dashboardController
                                                        .productModel
                                                        .value
                                                        .products?[j]
                                                        .variations
                                                        ?.isNotEmpty ==
                                                    true) {
                                                  Get.to(
                                                    ProductPage(
                                                      products:
                                                          dashboardController
                                                              .productModel
                                                              .value
                                                              .products?[j] ??
                                                          Products(),
                                                    ),
                                                  );
                                                } else {
                                                  selectedd = j;
                                                  dashboardController.addToCart(
                                                    dashboardController
                                                        .productModel
                                                        .value
                                                        .products?[j]
                                                        .id,
                                                    dashboardController
                                                        .productModel
                                                        .value
                                                        .products?[j]
                                                        .qty
                                                        ?.value,
                                                    0,
                                                  );
                                                }
                                              },
                                              child: Text(
                                                dashboardController
                                                            .cartModel
                                                            .value
                                                            .cartItems
                                                            ?.any(
                                                              (item) =>
                                                                  item.productId
                                                                      .toString() ==
                                                                  dashboardController
                                                                      .productModel
                                                                      .value
                                                                      .products?[j]
                                                                      .id
                                                                      .toString(),
                                                            ) ??
                                                        false
                                                    ? "Added"
                                                    : dashboardController
                                                            .productModel
                                                            .value
                                                            .products?[j]
                                                            .variations
                                                            ?.isNotEmpty ==
                                                        true
                                                    ? "Select Option"
                                                    : "Add to cart",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
                                  const SizedBox(height: 5),
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
                          "No Products",
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
