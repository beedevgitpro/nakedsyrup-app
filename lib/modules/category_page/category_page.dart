import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../Resources/AppColors.dart';
import '../../model/product_model.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../dashboard_flow/dashboard_controller.dart';
import 'product_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.findCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        'Most Viewed Product',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),

          onPressed: () {
            Get.back();
          },
        ),
        context,
      ),
      body: LiquidPullToRefresh(
        key: dashboardController.refreshIndicatorKey,
        onRefresh: dashboardController.dashBoardRefresh,
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
                        .dashboardList
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Most viewed product',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: 'Euclid Circular B',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(
                                ProductPage(
                                  products: Products(
                                    id:
                                        dashboardController
                                            .dashboardList
                                            .value
                                            .products?[0]
                                            .id,
                                    price:
                                        dashboardController
                                            .dashboardList
                                            .value
                                            .products?[0]
                                            .price,
                                    name:
                                        dashboardController
                                            .dashboardList
                                            .value
                                            .products?[0]
                                            .name,
                                    shortDescription: "",
                                    image:
                                        dashboardController
                                            .dashboardList
                                            .value
                                            .products?[0]
                                            .image,
                                    qty: 1.obs,
                                  ),
                                ),
                              );
                            },
                            leading: Image.network(
                              dashboardController
                                      .dashboardList
                                      .value
                                      .products?[0]
                                      .image ??
                                  "",
                            ),
                            title: Text(
                              dashboardController
                                      .dashboardList
                                      .value
                                      .products?[0]
                                      .name ??
                                  "",
                              // textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                              "\$${dashboardController.dashboardList.value.products?[0].price}",
                              style: TextStyle(
                                color: AppColors.nakedSyrup,
                                fontFamily: 'Euclid Circular B',
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
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
                          "No recent viewed products",
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
