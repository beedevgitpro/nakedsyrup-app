import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlParser;
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../model/product_model.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/view_photo.dart';

class ProductPage extends StatefulWidget {
  ProductPage({super.key, required this.products, required this.index});
  Products products = Products();
  int index = -1;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  DashboardController dashboardController = Get.put(DashboardController());
  List<String> allImages = [];
  List<String> svgImage = [];
  String price = "";

  String convertHtmlListToText(String htmlString) {
    final document = htmlParser.parse(htmlString);
    final buffer = StringBuffer();

    void extractNodeText(dom.Node node) {
      if (node is dom.Element) {
        if (node.localName == 'p') {
          buffer.writeln(node.text.trim());
          buffer.writeln();
        } else if (node.localName == 'ol') {
          int index = 1;
          for (var li in node.getElementsByTagName('li')) {
            buffer.writeln('$index. ${li.text.trim()}');
            index++;
          }
          buffer.writeln();
        } else if (node.localName == 'ul') {
          for (var li in node.getElementsByTagName('li')) {
            buffer.writeln('• ${li.text.trim()}');
          }
          buffer.writeln();
        } else {
          for (var child in node.nodes) {
            extractNodeText(child);
          }
        }
      }
    }

    for (var node in document.body?.nodes ?? []) {
      extractNodeText(node);
    }

    return buffer.toString().trim();
  }

  @override
  void initState() {
    // TODO: implement initState
    dashboardController.selectedVariance.value = "";
    dashboardController.selectedVariations.value = Variations();
    // dashboardController.findCart();
    dashboardController.currentIndex = 0;
    allImages.add(widget.products.image ?? "");
    if (widget.products.gallery?.isNotEmpty == true) {
      widget.products.gallery?.forEach((imageS) {
        if (imageS.toLowerCase().endsWith('.svg')) {
          svgImage.add(imageS);
        } else {
          allImages.add(imageS);
        }
      });
    }
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
    super.initState();
  }

  int selectedImageIndex = 0;
  int quantity = 2;
  bool isPerUnit = true;
  bool showDescription = true;
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
            if (dashboardController.addToBasket.value) {
            } else {
              dashboardController.selectedd.value = -1;
            }
          },
        ),
        context,
        actions: [dashboardController.cartUI()],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(getFontSize(context, 2)),
        children: [
          Get.width >= 600
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height:
                        MediaQuery.of(context).size.height -
                        kToolbarHeight - // AppBar height
                        MediaQuery.of(context).padding.top,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(
                              PhotoViewInApp(
                                galleryItems: allImages,
                                currentIndex: selectedImageIndex,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: EdgeInsets.all(getFontSize(context, 2)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.yellowColor.withOpacity(0.5),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                imageUrl: allImages[selectedImageIndex],
                                placeholder:
                                    (context, url) => CircularProgressIndicator(
                                      color: Colors.transparent,
                                    ),
                                errorWidget:
                                    (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: allImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImageIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          selectedImageIndex == index
                                              ? AppColors.nakedSyrup
                                              : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: CachedNetworkImage(
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    imageUrl: allImages[index],
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.yellowColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColors.nakedSyrup.withOpacity(0.5),
                          ),
                        ),
                        padding: EdgeInsets.all(getFontSize(context, -2)),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.products.name ?? "",
                                style: TextStyle(
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: getFontSize(context, 2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  price,
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontFamily: 'Euclid Circular B',
                                    fontSize: getFontSize(context, 0),
                                    fontWeight: FontWeight.bold,
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
                                            widget
                                                .products
                                                .variations
                                                ?.length ??
                                            0,
                                        separatorBuilder: (context, ii) {
                                          return const SizedBox(width: 10);
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
                                                      ?.attributeSize
                                                      ?.isNotEmpty ==
                                                  true) {
                                            teext =
                                                widget
                                                    .products
                                                    .variations?[item]
                                                    .attributes
                                                    ?.attributeSize ??
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
                                            () => ElevatedButton(
                                              onPressed: () {
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
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    dashboardController
                                                                .selectedVariance
                                                                .value ==
                                                            teext
                                                        ? AppColors.nakedSyrup
                                                        : Colors.white,
                                                side: BorderSide(
                                                  color:
                                                      dashboardController
                                                                  .selectedVariance
                                                                  .value !=
                                                              teext
                                                          ? AppColors.nakedSyrup
                                                          : Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                foregroundColor:
                                                    dashboardController
                                                                .selectedVariance
                                                                .value ==
                                                            teext
                                                        ? Colors.white
                                                        : Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                teext,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Euclid Circular B',
                                                  fontSize: getFontSize(
                                                    context,
                                                    0,
                                                  ),
                                                  fontWeight: FontWeight.bold,
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
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  : const SizedBox(),

                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (widget.products.qty!.value >
                                                  1) {
                                                widget.products.qty?.value =
                                                    widget.products.qty!.value -
                                                    1;
                                              }
                                            },
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.nakedSyrup
                                                      .withOpacity(0.8),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Obx(
                                            () => Text(
                                              widget.products.qty?.value
                                                      .toString() ??
                                                  "",
                                              style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontSize: getFontSize(
                                                  context,
                                                  0,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              widget.products.qty?.value =
                                                  widget.products.qty!.value +
                                                  1;
                                            },
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.nakedSyrup
                                                      .withOpacity(0.8),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
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
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  getFontSize(
                                                                    context,
                                                                    -3,
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
                                                          color:
                                                              AppColors
                                                                  .nakedSyrup,
                                                          fontFamily:
                                                              'Euclid Circular B',
                                                          fontSize: getFontSize(
                                                            context,
                                                            1,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
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
                              const SizedBox(height: 10),
                              Obx(
                                () =>
                                    dashboardController.addToBasket.value &&
                                            dashboardController
                                                    .selectedd
                                                    .value ==
                                                widget.index
                                        ? Center(
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              color: AppColors.greenColor,
                                            ),
                                          ),
                                        )
                                        : SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if ((widget
                                                              .products
                                                              .variations
                                                              ?.isNotEmpty ==
                                                          true &&
                                                      dashboardController
                                                              .selectedVariations
                                                              .value
                                                              .variationId !=
                                                          null) ||
                                                  widget
                                                          .products
                                                          .variations
                                                          ?.isNotEmpty ==
                                                      false) {
                                                dashboardController
                                                    .selectedd
                                                    .value = widget.index;
                                                dashboardController.addToCart(
                                                  widget.products.id,
                                                  widget.products.qty,
                                                  dashboardController
                                                          .selectedVariations
                                                          .value
                                                          .variationId ??
                                                      0,
                                                  widget.index,
                                                );
                                              } else {
                                                Get.snackbar(
                                                  'Please select one variance',
                                                  "",
                                                  backgroundColor: Colors.white,
                                                  colorText: Colors.red,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),

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
                                                  : 'ADD TO CART',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: getFontSize(
                                                  context,
                                                  -2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                              ),
                              dashboardController
                                          .selectedVariations
                                          .value
                                          .stockStatus !=
                                      null
                                  ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${dashboardController.selectedVariations.value.stockStatus}',
                                        style: TextStyle(
                                          color: AppColors.nakedSyrup,
                                          fontWeight: FontWeight.normal,
                                          fontSize: getFontSize(context, -2),
                                        ),
                                      ),
                                    ),
                                  )
                                  : const SizedBox(),
                              const SizedBox(height: 16),

                              if (widget.products.shortDescription != null &&
                                  widget
                                          .products
                                          .shortDescription
                                          ?.isNotEmpty ==
                                      true)
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Text(
                                    htmlParser
                                            .parse(
                                              widget.products.shortDescription,
                                            )
                                            .body
                                            ?.text ??
                                        "",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: AppColors.fontLightColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: getFontSize(context, -2),
                                    ),
                                  ),
                                ),

                              if (svgImage.isNotEmpty)
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, s) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: SvgPicture.network(
                                          svgImage[s],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          placeholderBuilder:
                                              (context) => const Center(
                                                child: SizedBox(),
                                              ),

                                          alignment: Alignment.center,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, ii) {
                                      return const SizedBox(width: 8);
                                    },
                                    itemCount: svgImage.length,
                                  ),
                                ),
                              if (widget.products.description != null &&
                                  widget.products.description?.isNotEmpty ==
                                      true)
                                ExpansionTile(
                                  title: Text(
                                    'Description',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: getFontSize(context, 1),
                                    ),
                                  ),
                                  childrenPadding: EdgeInsets.zero,
                                  onExpansionChanged: (value) {},

                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        convertHtmlListToText(
                                          widget.products.description ?? "",
                                        ),
                                        // parse(
                                        //       widget.products.description,
                                        //     ).body?.text ??
                                        //     "",
                                        style: TextStyle(
                                          color: AppColors.fontLightColor,
                                          fontWeight: FontWeight.normal,
                                          fontSize: getFontSize(context, -2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.products.recipes != null &&
                                  widget.products.recipes?.isNotEmpty == true)
                                ExpansionTile(
                                  title: Text(
                                    'Recipes',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: getFontSize(context, 1),
                                    ),
                                  ),
                                  childrenPadding: EdgeInsets.zero,
                                  onExpansionChanged: (value) {},

                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        convertHtmlListToText(
                                          widget.products.recipes ?? "",
                                        ),
                                        style: TextStyle(
                                          color: AppColors.fontLightColor,
                                          fontWeight: FontWeight.normal,
                                          fontSize: getFontSize(context, -2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Column(
                children: [
                  Column(
                    children: [
                      CarouselSlider(
                        carouselController:
                            dashboardController.carouselController,
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
                                  return InkWell(
                                    onTap: () {
                                      Get.to(
                                        PhotoViewInApp(
                                          galleryItems: allImages,
                                          currentIndex:
                                              dashboardController.currentIndex,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                          imageUrl: imgUrl,
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
                                  );
                                },
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            allImages.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () {
                                  dashboardController.carouselController
                                      .animateToPage(entry.key);
                                },
                                child:
                                    entry.value.toLowerCase().endsWith(".svg")
                                        ? const SizedBox()
                                        : Container(
                                          width: 24,
                                          height: 2,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                dashboardController
                                                            .currentIndex ==
                                                        entry.key
                                                    ? AppColors.nakedSyrup
                                                    : AppColors.nakedSyrup
                                                        .withOpacity(0.4),
                                          ),
                                        ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellowColor.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.nakedSyrup.withOpacity(0.5),
                        ),
                      ),
                      padding: EdgeInsets.all(getFontSize(context, -6)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.products.name ?? "",
                              style: TextStyle(
                                fontFamily: 'Euclid Circular B',
                                fontSize: getFontSize(context, -2),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                price,
                                style: TextStyle(
                                  color: AppColors.nakedSyrup,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: getFontSize(context, -4),
                                  fontWeight: FontWeight.bold,
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
                                    height: 38,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          widget.products.variations?.length ??
                                          0,
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
                                                    ?.attributeSize
                                                    ?.isNotEmpty ==
                                                true) {
                                          teext =
                                              widget
                                                  .products
                                                  .variations?[item]
                                                  .attributes
                                                  ?.attributeSize ??
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
                                          () => ElevatedButton(
                                            onPressed: () {
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
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  dashboardController
                                                              .selectedVariance
                                                              .value ==
                                                          teext
                                                      ? AppColors.nakedSyrup
                                                      : Colors.white,
                                              side: BorderSide(
                                                color:
                                                    dashboardController
                                                                .selectedVariance
                                                                .value !=
                                                            teext
                                                        ? AppColors.nakedSyrup
                                                        : Colors.transparent,
                                                width: 1.0,
                                              ),
                                              foregroundColor:
                                                  dashboardController
                                                              .selectedVariance
                                                              .value ==
                                                          teext
                                                      ? Colors.white
                                                      : Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              teext,
                                              style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontSize: getFontSize(
                                                  context,
                                                  -4,
                                                ),
                                                fontWeight: FontWeight.bold,
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
                                        );
                                      },
                                    ),
                                  ),
                                )
                                : const SizedBox(),

                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (widget.products.qty!.value >
                                                1) {
                                              widget.products.qty?.value =
                                                  widget.products.qty!.value -
                                                  1;
                                            }
                                          },
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.nakedSyrup
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
                                        const SizedBox(width: 3),
                                        Obx(
                                          () => Text(
                                            widget.products.qty?.value
                                                    .toString() ??
                                                "",
                                            style: TextStyle(
                                              fontFamily: 'Euclid Circular B',
                                              fontSize: getFontSize(
                                                context,
                                                -4,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        IconButton(
                                          onPressed: () {
                                            widget.products.qty?.value =
                                                widget.products.qty!.value + 1;
                                          },
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.nakedSyrup
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
                                const Spacer(),
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
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                getFontSize(
                                                                  context,
                                                                  -3,
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
                                                        color:
                                                            AppColors
                                                                .nakedSyrup,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontSize: getFontSize(
                                                          context,
                                                          -3,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
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
                            Obx(
                              () =>
                                  dashboardController.addToBasket.value &&
                                          dashboardController.selectedd.value ==
                                              widget.index
                                      ? Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            color: AppColors.greenColor,
                                          ),
                                        ),
                                      )
                                      : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if ((widget
                                                            .products
                                                            .variations
                                                            ?.isNotEmpty ==
                                                        true &&
                                                    dashboardController
                                                            .selectedVariations
                                                            .value
                                                            .variationId !=
                                                        null) ||
                                                widget
                                                        .products
                                                        .variations
                                                        ?.isNotEmpty ==
                                                    false) {
                                              dashboardController
                                                  .selectedd
                                                  .value = widget.index;
                                              dashboardController.addToCart(
                                                widget.products.id,
                                                widget.products.qty,
                                                dashboardController
                                                        .selectedVariations
                                                        .value
                                                        .variationId ??
                                                    0,
                                                widget.index,
                                              );
                                            } else {
                                              Get.snackbar(
                                                'Please select one variance',
                                                "",
                                                backgroundColor: Colors.white,
                                                colorText: Colors.red,
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
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
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),

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
                                                : 'ADD TO CART',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: getFontSize(
                                                context,
                                                -6,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                            ),
                            dashboardController
                                        .selectedVariations
                                        .value
                                        .stockStatus !=
                                    null
                                ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${dashboardController.selectedVariations.value.stockStatus}',
                                      style: TextStyle(
                                        color: AppColors.nakedSyrup,
                                        fontWeight: FontWeight.normal,
                                        fontSize: getFontSize(context, -4),
                                      ),
                                    ),
                                  ),
                                )
                                : const SizedBox(),
                            const SizedBox(height: 16),

                            if (widget.products.shortDescription != null &&
                                widget.products.shortDescription?.isNotEmpty ==
                                    true)
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Text(
                                  htmlParser
                                          .parse(
                                            widget.products.shortDescription,
                                          )
                                          .body
                                          ?.text ??
                                      "",
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: AppColors.fontLightColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: getFontSize(context, -6),
                                  ),
                                ),
                              ),

                            if (svgImage.isNotEmpty)
                              SizedBox(
                                height: 60,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, s) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: SvgPicture.network(
                                        svgImage[s],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        placeholderBuilder:
                                            (context) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),

                                        alignment: Alignment.center,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, ii) {
                                    return const SizedBox(width: 8);
                                  },
                                  itemCount: svgImage.length,
                                ),
                              ),
                            if (widget.products.description != null &&
                                widget.products.description?.isNotEmpty == true)
                              ExpansionTile(
                                title: Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(context, -3),
                                  ),
                                ),
                                childrenPadding: EdgeInsets.zero,
                                onExpansionChanged: (value) {},

                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      convertHtmlListToText(
                                        widget.products.description ?? "",
                                      ),

                                      style: TextStyle(
                                        color: AppColors.fontLightColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: getFontSize(context, -4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (widget.products.recipes != null &&
                                widget.products.recipes?.isNotEmpty == true)
                              ExpansionTile(
                                title: Text(
                                  'Recipes',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(context, -3),
                                  ),
                                ),
                                childrenPadding: EdgeInsets.zero,
                                onExpansionChanged: (value) {},

                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      convertHtmlListToText(
                                        widget.products.recipes ?? "",
                                      ),

                                      style: TextStyle(
                                        color: AppColors.fontLightColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: getFontSize(context, -4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
