import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../model/product_model.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';

class ProductPage extends StatefulWidget {
  ProductPage({super.key, required this.products});
  Products products = Products();
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  DashboardController dashboardController = Get.put(DashboardController());
  List<String> allImages = [];
  String price = "";
  @override
  void initState() {
    // TODO: implement initState
    dashboardController.selectedVariance.value = "";
    dashboardController.selectedVariations.value = Variations();
    dashboardController.currentIndex = 0;
    allImages.add(widget.products.image ?? "");
    allImages.addAll(widget.products.gallery ?? []);
    if (widget.products.variations?.isNotEmpty == true) {
      String lowPrice =
          (getLowestPrice(widget.products.variations ?? []) ?? 0.0)
              .toStringAsFixed(2)
              .toString();
      String highPrice =
          (getHighestPrice(widget.products.variations ?? []) ?? 0.0)
              .toStringAsFixed(2)
              .toString();
      if (highPrice == lowPrice) {
        price = "\$${lowPrice}";
      } else {
        price = "\$${lowPrice} - \$${highPrice}";
      }
    } else {
      price =
          "\$${double.parse(widget.products.price ?? "0").toStringAsFixed(2)}";
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.findCart();
    });
    super.initState();
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
        widget.products.name ?? "",
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        context,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CarouselSlider(
                    carouselController: dashboardController.carouselController,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      viewportFraction: 0.9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          dashboardController.currentIndex = index;
                        });
                      },
                    ),
                    items:
                        allImages.map((imgUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:
                                      imgUrl.toLowerCase().endsWith(".svg")
                                          ? SvgPicture.network(
                                            imgUrl,
                                            placeholderBuilder:
                                                (context) => const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                            height: 200,
                                            fit: BoxFit.contain,
                                            alignment: Alignment.center,
                                          )
                                          : Image.network(
                                            imgUrl,
                                            fit: BoxFit.contain,
                                            alignment: Alignment.center,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    ),
                                          ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 12),

                  /// ✅ Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        allImages.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap:
                                () => dashboardController.carouselController
                                    .animateToPage(entry.key),
                            child: Container(
                              width:
                                  dashboardController.currentIndex == entry.key
                                      ? 12.0
                                      : 8.0,
                              height:
                                  dashboardController.currentIndex == entry.key
                                      ? 12.0
                                      : 8.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    dashboardController.currentIndex ==
                                            entry.key
                                        ? Colors.black87
                                        : Colors.grey[400],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Get.width >= 600
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.products.name ?? "",
                            style: TextStyle(
                              // color: AppColors.nakedSyrup,
                              fontFamily: 'Euclid Circular B',
                              // fontStyle: FontStyle.italic,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              price,
                              style: TextStyle(
                                color:
                                    widget.products.variations?.isNotEmpty ==
                                            true
                                        ? Colors.black87
                                        : AppColors.nakedSyrup,
                                fontFamily: 'Euclid Circular B',
                                fontSize: getFontSize(context, 1),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          widget.products.variations?.isNotEmpty == true
                              ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                ),
                                child: SizedBox(
                                  height: 42,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount:
                                        widget.products.variations?.length ?? 0,
                                    separatorBuilder: (context, ii) {
                                      return const SizedBox(width: 8);
                                    },
                                    itemBuilder: (context, item) {
                                      String teext = "";
                                      if (widget
                                                  .products
                                                  .variations?[item]
                                                  .attributes !=
                                              null &&
                                          widget
                                                  .products
                                                  .variations?[item]
                                                  .attributes
                                                  ?.isNotEmpty ==
                                              true) {
                                        teext =
                                            widget
                                                .products
                                                .variations?[item]
                                                .attributes ??
                                            "";
                                      } else {
                                        if (widget
                                                .products
                                                .variations?[item]
                                                .sku
                                                ?.contains('-') ==
                                            true) {
                                          teext =
                                              widget
                                                  .products
                                                  .variations?[item]
                                                  .sku
                                                  ?.split("-")
                                                  .last ??
                                              "";
                                        } else {
                                          teext =
                                              widget
                                                  .products
                                                  .variations?[item]
                                                  .sku
                                                  ?.split("/")
                                                  .last
                                                  .substring(1) ??
                                              "";
                                        }
                                      }
                                      return Obx(
                                        () => InkWell(
                                          onTap: () {
                                            dashboardController
                                                .selectedVariance
                                                .value = teext;
                                            dashboardController
                                                .selectedVariations
                                                .value = widget
                                                    .products
                                                    .variations?[item] ??
                                                Variations();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  dashboardController
                                                              .selectedVariance
                                                              .value ==
                                                          teext
                                                      ? AppColors.nakedSyrup
                                                      : AppColors.nakedSyrup
                                                          .withOpacity(0.3),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                color: Colors.black87,
                                              ),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                                child: Text(
                                                  teext,
                                                  style: TextStyle(
                                                    fontSize: getFontSize(
                                                      context,
                                                      -2,
                                                    ),
                                                    fontWeight: FontWeight.w600,

                                                    color:
                                                        dashboardController
                                                                    .selectedVariance
                                                                    .value ==
                                                                teext
                                                            ? Colors.white
                                                            : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    border: Border.all(color: Colors.black54),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (widget.products.qty!.value > 1) {
                                            widget.products.qty?.value =
                                                widget.products.qty!.value - 1;
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            border: Border.merge(
                                              Border(
                                                right: BorderSide(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Border(left: BorderSide.none),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 7),
                                      Obx(
                                        () => Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            widget.products.qty?.value
                                                    .toString() ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 7),
                                      InkWell(
                                        onTap: () {
                                          widget.products.qty?.value =
                                              widget.products.qty!.value + 1;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            border: Border.merge(
                                              Border(
                                                left: BorderSide(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Border(right: BorderSide.none),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.products.variations?.isNotEmpty == true
                                    ? Obx(
                                      () =>
                                          dashboardController
                                                  .selectedVariance
                                                  .value
                                                  .isNotEmpty
                                              ? RichText(
                                                text: TextSpan(
                                                  children: [
                                                    dashboardController
                                                                .selectedVariations
                                                                .value
                                                                .price !=
                                                            dashboardController
                                                                .selectedVariations
                                                                .value
                                                                .regularPrice
                                                        ? TextSpan(
                                                          text:
                                                              "\$${double.parse(dashboardController.selectedVariations.value.regularPrice ?? "0").toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color:
                                                                AppColors
                                                                    .nakedSyrup,
                                                            fontFamily:
                                                                'Euclid Circular B',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                getFontSize(
                                                                  context,
                                                                  1,
                                                                ),
                                                          ),
                                                        )
                                                        : WidgetSpan(
                                                          child: SizedBox(),
                                                        ),
                                                    TextSpan(
                                                      text:
                                                          dashboardController
                                                                      .selectedVariations
                                                                      .value
                                                                      .regularPrice ==
                                                                  dashboardController
                                                                      .selectedVariations
                                                                      .value
                                                                      .price
                                                              ? "  \$${double.parse(dashboardController.selectedVariations.value.price ?? "0").toStringAsFixed(2)}"
                                                              : "  \$${double.parse(dashboardController.selectedVariations.value.salePrice ?? "0").toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .nakedSyrup,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: getFontSize(
                                                          context,
                                                          2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              : const SizedBox(),
                                    )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (Get.width / 2) - 30,
                            child: Obx(
                              () =>
                                  dashboardController.addToBasket.value
                                      ? Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            color: AppColors.greenColor,
                                          ),
                                        ),
                                      )
                                      : (widget
                                                      .products
                                                      .variations
                                                      ?.isNotEmpty ==
                                                  true &&
                                              dashboardController
                                                  .selectedVariance
                                                  .value
                                                  .isNotEmpty) ||
                                          widget.products.variations?.isEmpty ==
                                              true
                                      ? ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.only(top: 10),
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all(
                                                dashboardController
                                                            .cartModel
                                                            .value
                                                            .cartItems
                                                            ?.any(
                                                              (item) =>
                                                                  item.productId
                                                                      .toString() ==
                                                                  widget
                                                                      .products
                                                                      .id
                                                                      .toString(),
                                                            ) ??
                                                        false
                                                    ? Colors.green
                                                    : AppColors.nakedSyrup,
                                              ),
                                            ),
                                            onPressed: () {
                                              dashboardController.addToCart(
                                                widget.products.id,
                                                widget.products.qty,
                                                dashboardController
                                                        .selectedVariations
                                                        .value
                                                        .variationId ??
                                                    0,
                                              );
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
                                                                widget
                                                                    .products
                                                                    .id
                                                                    .toString(),
                                                          ) ??
                                                      false
                                                  ? "Added"
                                                  : "Add to cart",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: getFontSize(
                                                  context,
                                                  -2,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          dashboardController
                                                      .selectedVariations
                                                      .value
                                                      .stockStatus !=
                                                  null
                                              ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text:
                                                          "  ${dashboardController.selectedVariations.value.stockStatus}",
                                                      style: TextStyle(
                                                        color:
                                                            dashboardController
                                                                        .selectedVariations
                                                                        .value
                                                                        .stockStatus ==
                                                                    'instock'
                                                                ? Colors.green
                                                                : Colors.red,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: getFontSize(
                                                          context,
                                                          0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : const SizedBox(),
                                        ],
                                      )
                                      : const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      if (widget.products.shortDescription != null &&
                          widget.products.shortDescription?.isNotEmpty == true)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              parse(
                                    widget.products.shortDescription,
                                  ).body?.text ??
                                  "",
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.products.name ?? "",
                        style: TextStyle(
                          // color: AppColors.nakedSyrup,
                          fontFamily: 'Euclid Circular B',
                          // fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          price,
                          style: TextStyle(
                            color:
                                widget.products.variations?.isNotEmpty == true
                                    ? Colors.black87
                                    : AppColors.nakedSyrup,
                            fontFamily: 'Euclid Circular B',
                            fontSize: getFontSize(context, 1),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      widget.products.variations?.isNotEmpty == true
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: SizedBox(
                              height: 42,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    widget.products.variations?.length ?? 0,
                                separatorBuilder: (context, ii) {
                                  return const SizedBox(width: 8);
                                },
                                itemBuilder: (context, item) {
                                  String teext = "";
                                  if (widget
                                              .products
                                              .variations?[item]
                                              .attributes !=
                                          null &&
                                      widget
                                              .products
                                              .variations?[item]
                                              .attributes
                                              ?.isNotEmpty ==
                                          true) {
                                    teext =
                                        widget
                                            .products
                                            .variations?[item]
                                            .attributes ??
                                        "";
                                  } else {
                                    if (widget.products.variations?[item].sku
                                            ?.contains('-') ==
                                        true) {
                                      teext =
                                          widget.products.variations?[item].sku
                                              ?.split("-")
                                              .last ??
                                          "";
                                    } else {
                                      teext =
                                          widget.products.variations?[item].sku
                                              ?.split("/")
                                              .last
                                              .substring(1) ??
                                          "";
                                    }
                                  }
                                  return Obx(
                                    () => InkWell(
                                      onTap: () {
                                        dashboardController
                                            .selectedVariance
                                            .value = teext;
                                        dashboardController
                                                .selectedVariations
                                                .value =
                                            widget.products.variations?[item] ??
                                            Variations();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              dashboardController
                                                          .selectedVariance
                                                          .value ==
                                                      teext
                                                  ? AppColors.nakedSyrup
                                                  : AppColors.nakedSyrup
                                                      .withOpacity(0.3),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          border: Border.all(
                                            color: Colors.black87,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Text(
                                              teext,
                                              style: TextStyle(
                                                fontSize: getFontSize(
                                                  context,
                                                  -2,
                                                ),
                                                fontWeight: FontWeight.w600,

                                                color:
                                                    dashboardController
                                                                .selectedVariance
                                                                .value ==
                                                            teext
                                                        ? Colors.white
                                                        : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                border: Border.all(color: Colors.black54),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (widget.products.qty!.value > 1) {
                                        widget.products.qty?.value =
                                            widget.products.qty!.value - 1;
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        border: Border.merge(
                                          Border(
                                            right: BorderSide(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Border(left: BorderSide.none),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        widget.products.qty?.value.toString() ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  InkWell(
                                    onTap: () {
                                      widget.products.qty?.value =
                                          widget.products.qty!.value + 1;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        border: Border.merge(
                                          Border(
                                            left: BorderSide(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Border(right: BorderSide.none),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.products.variations?.isNotEmpty == true
                                ? Obx(
                                  () =>
                                      dashboardController
                                              .selectedVariance
                                              .value
                                              .isNotEmpty
                                          ? RichText(
                                            text: TextSpan(
                                              children: [
                                                dashboardController
                                                            .selectedVariations
                                                            .value
                                                            .price !=
                                                        dashboardController
                                                            .selectedVariations
                                                            .value
                                                            .regularPrice
                                                    ? TextSpan(
                                                      text:
                                                          "\$${dashboardController.selectedVariations.value.regularPrice}",
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color:
                                                            AppColors
                                                                .nakedSyrup,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: getFontSize(
                                                          context,
                                                          1,
                                                        ),
                                                      ),
                                                    )
                                                    : WidgetSpan(
                                                      child: SizedBox(),
                                                    ),
                                                TextSpan(
                                                  text:
                                                      dashboardController
                                                                  .selectedVariations
                                                                  .value
                                                                  .regularPrice ==
                                                              dashboardController
                                                                  .selectedVariations
                                                                  .value
                                                                  .price
                                                          ? "  \$${dashboardController.selectedVariations.value.price}"
                                                          : "  \$${dashboardController.selectedVariations.value.salePrice}",
                                                  style: TextStyle(
                                                    color: AppColors.nakedSyrup,
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: getFontSize(
                                                      context,
                                                      2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          : const SizedBox(),
                                )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      // dashboardController.selectedVariance.value.isNotEmpty
                      //     ? InkWell(
                      //       onTap: () {
                      //         dashboardController.selectedVariance.value = "";
                      //       },
                      //       child: SizedBox(
                      //         width: 35,
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(top: 10),
                      //           child: Text(
                      //             "clear",
                      //             style: TextStyle(
                      //               // color: AppColors.nakedSyrup,
                      //               fontFamily: 'Euclid Circular B',
                      //               fontSize: 12,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //     : const SizedBox(),
                      Obx(
                        () =>
                            dashboardController.addToBasket.value
                                ? Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: AppColors.greenColor,
                                    ),
                                  ),
                                )
                                : (widget.products.variations?.isNotEmpty ==
                                            true &&
                                        dashboardController
                                            .selectedVariance
                                            .value
                                            .isNotEmpty) ||
                                    widget.products.variations?.isEmpty == true
                                ? ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(top: 10),
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(
                                          dashboardController
                                                      .cartModel
                                                      .value
                                                      .cartItems
                                                      ?.any(
                                                        (item) =>
                                                            item.productId
                                                                .toString() ==
                                                            widget.products.id
                                                                .toString(),
                                                      ) ??
                                                  false
                                              ? Colors.green
                                              : AppColors.nakedSyrup,
                                        ),
                                      ),
                                      onPressed: () {
                                        dashboardController.addToCart(
                                          widget.products.id,
                                          widget.products.qty,
                                          dashboardController
                                                  .selectedVariations
                                                  .value
                                                  .variationId ??
                                              0,
                                        );
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
                                                          widget.products.id
                                                              .toString(),
                                                    ) ??
                                                false
                                            ? "Added"
                                            : "Add to cart",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: getFontSize(context, -2),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    dashboardController
                                                .selectedVariations
                                                .value
                                                .stockStatus !=
                                            null
                                        ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text:
                                                    "  ${dashboardController.selectedVariations.value.stockStatus}",
                                                style: TextStyle(
                                                  color:
                                                      dashboardController
                                                                  .selectedVariations
                                                                  .value
                                                                  .stockStatus ==
                                                              'instock'
                                                          ? Colors.green
                                                          : Colors.red,
                                                  fontFamily:
                                                      'Euclid Circular B',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: getFontSize(
                                                    context,
                                                    0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                        : const SizedBox(),
                                  ],
                                )
                                : const SizedBox(),
                      ),
                      if (widget.products.shortDescription != null &&
                          widget.products.shortDescription?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            parse(
                                  widget.products.shortDescription,
                                ).body?.text ??
                                "",
                          ),
                        ),
                    ],
                  ),

              if (widget.products.description != null &&
                  widget.products.description?.isNotEmpty == true)
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Description",
                        style: TextStyle(
                          color: AppColors.nakedSyrup,
                          fontFamily: 'Euclid Circular B',

                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          parse(widget.products.description).body?.text ?? "",
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
