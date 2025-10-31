import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naked_syrups/modules/dashboard_flow/dashboard_controller.dart';

import '../../Resources/AppColors.dart';
import '../../model/order_history_model.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/appbar_widget.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({super.key, required this.orders});

  Orders orders = Orders();
  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    dashboardController.findCart();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String date = widget.orders.orderDate.toString() ?? "";
    String convertedDate = DateFormat(
      "dd/MM/yyyy",
    ).format(DateTime.parse(date));
    return Scaffold(
      appBar: AppBarWidget(
        'Order #${widget.orders.orderNumber}',
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        context,
        actions: [dashboardController.cartUI()],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.all(getFontSize(context, 2)),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.yellowColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.nakedSyrup.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(getFontSize(context, -2)),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to start
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Get.width >= 600
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "#${widget.orders.orderNumber} ",
                                        style: TextStyle(
                                          color: AppColors.nakedSyrup,
                                          fontFamily: 'Euclid Circular B',
                                          fontWeight: FontWeight.w500,
                                          fontSize: getFontSize(context, 2),
                                        ),
                                      ),
                                    ],
                                    text: "Order ID : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.w600,
                                      fontSize: getFontSize(context, 2),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: " $convertedDate  ",
                                        style: TextStyle(
                                          color: AppColors.nakedSyrup,
                                          fontFamily: 'Euclid Circular B',
                                          fontWeight: FontWeight.w500,
                                          fontSize: getFontSize(context, 2),
                                        ),
                                      ),
                                    ],
                                    text: "Order Date : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.w600,
                                      fontSize: getFontSize(context, 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    widget.orders.status.toString() ==
                                            "cancelled"
                                        ? AppColors.redColor.withOpacity(0.15)
                                        : widget.orders.status.toString() ==
                                            "completed"
                                        ? Color(0XFF3FD75A).withOpacity(0.2)
                                        : Color(0XFFFFAE00).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
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
                                    (widget.orders.status
                                                .toString()
                                                .toString() ??
                                            "")
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          widget.orders.status.toString() ==
                                                  "cancelled"
                                              ? AppColors.redColor
                                              : widget.orders.status
                                                      .toString()
                                                      .toString() ==
                                                  "completed"
                                              ? Color(0XFF3FD75A)
                                              : Color(0XFFFFAE00),
                                      fontSize: getFontSize(context, 0),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Euclid Circular B",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "#${widget.orders.orderNumber} ",
                                        style: TextStyle(
                                          color: AppColors.nakedSyrup,
                                          fontFamily: 'Euclid Circular B',
                                          fontWeight: FontWeight.w500,
                                          fontSize: getFontSize(context, -2),
                                        ),
                                      ),
                                    ],
                                    text: "Order ID : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.w600,
                                      fontSize: getFontSize(context, -2),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: " $convertedDate  ",
                                        style: TextStyle(
                                          color: AppColors.nakedSyrup,
                                          fontFamily: 'Euclid Circular B',
                                          fontWeight: FontWeight.w500,
                                          fontSize: getFontSize(context, -2),
                                        ),
                                      ),
                                    ],
                                    text: "Order Date : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.w600,
                                      fontSize: getFontSize(context, -2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color:
                                    widget.orders.status.toString() ==
                                            "cancelled"
                                        ? AppColors.redColor.withOpacity(0.15)
                                        : widget.orders.status.toString() ==
                                            "completed"
                                        ? Color(0XFF3FD75A).withOpacity(0.2)
                                        : Color(0XFFFFAE00).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
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
                                    (widget.orders.status
                                                .toString()
                                                .toString() ??
                                            "")
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          widget.orders.status.toString() ==
                                                  "cancelled"
                                              ? AppColors.redColor
                                              : widget.orders.status
                                                      .toString()
                                                      .toString() ==
                                                  "completed"
                                              ? Color(0XFF3FD75A)
                                              : Color(0XFFFFAE00),
                                      fontSize: getFontSize(context, -4),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Euclid Circular B",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getFontSize(context, 0),
                      ),
                      child: Divider(
                        color: AppColors.nakedSyrup.withOpacity(0.2),
                        thickness: 1.5,
                      ),
                    ),
                    widget.orders.items!.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: ListView.separated(
                            itemCount: widget.orders.items?.length ?? 0,
                            separatorBuilder: (context, i) {
                              return SizedBox(width: 10);
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, x) {
                              return SizedBox(
                                height:
                                    widget.orders.items?[x].image
                                                .toString()
                                                .isNotEmpty ==
                                            true
                                        ? Get.width >= 600
                                            ? 170
                                            : 100
                                        : 80,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    widget.orders.items?[x].image
                                                .toString()
                                                .isNotEmpty ==
                                            true
                                        ? Container(
                                          width:
                                              Get.width >= 600
                                                  ? (getFontSize(context, -2) *
                                                      10)
                                                  : (getFontSize(context, -2) *
                                                      5),
                                          decoration: BoxDecoration(
                                            // color: AppColors.yellowColor.withOpacity(0.02),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            border: Border.all(
                                              color: AppColors.yellowColor
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  widget.orders.items?[x].image
                                                      .toString() ??
                                                  "",
                                              placeholder:
                                                  (context, url) =>
                                                      CircularProgressIndicator(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                        : const SizedBox(),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start, // Align text to start
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 0),
                                          Text(
                                            widget
                                                    .orders
                                                    .items?[x]
                                                    .productName ??
                                                "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 4)
                                                      : getFontSize(
                                                        context,
                                                        -2,
                                                      ),
                                              color: Colors.black,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "\$${double.parse(widget.orders.items?[x].price.toString() ?? "0.0").toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.nakedSyrup,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 0)
                                                      : getFontSize(
                                                        context,
                                                        -4,
                                                      ),
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                        : const SizedBox(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical:
                            Get.width >= 600
                                ? (getFontSize(context, 4))
                                : getFontSize(context, -4),
                      ),
                      child: Divider(
                        color: AppColors.nakedSyrup.withOpacity(0.2),
                        thickness: 1.5,
                      ),
                    ),
                    widget.orders.subTotal != null &&
                            widget.orders.subTotal != 0
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    Get.width >= 600
                                        ? getFontSize(context, 2)
                                        : getFontSize(context, -2),
                              ),
                            ),
                            Text(
                              "\$${double.parse(widget.orders.subTotal.toString()).toStringAsFixed(2)} ",
                              style: TextStyle(
                                color: AppColors.nakedSyrup,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    Get.width >= 600
                                        ? getFontSize(context, 2)
                                        : getFontSize(context, -2),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),
                    widget.orders.subTotal != null &&
                            widget.orders.subTotal != 0
                        ? const SizedBox(height: 10)
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GST : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.w600,
                            fontSize:
                                Get.width >= 600
                                    ? getFontSize(context, 2)
                                    : getFontSize(context, -2),
                          ),
                        ),
                        Text(
                          "\$${double.parse(widget.orders.gst.toString()).toStringAsFixed(2)} ",
                          style: TextStyle(
                            color: AppColors.nakedSyrup,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Get.width >= 600
                                    ? getFontSize(context, 2)
                                    : getFontSize(context, -2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    widget.orders.discount != null &&
                            widget.orders.discount != 0
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    Get.width >= 600
                                        ? getFontSize(context, 2)
                                        : getFontSize(context, -2),
                              ),
                            ),
                            Text(
                              "\$${double.parse(widget.orders.discount.toString()).toStringAsFixed(2)} ",
                              style: TextStyle(
                                color: AppColors.nakedSyrup,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    Get.width >= 600
                                        ? getFontSize(context, 2)
                                        : getFontSize(context, -2),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),
                    widget.orders.discount != null &&
                            widget.orders.discount != 0
                        ? const SizedBox(height: 10)
                        : const SizedBox(),
                    widget.orders.shippingTotal != null &&
                            widget.orders.shippingTotal != 0
                        ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shipping Charges : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        Get.width >= 600
                                            ? getFontSize(context, 2)
                                            : getFontSize(context, -2),
                                  ),
                                ),
                                Text(
                                  "\$${double.parse(widget.orders.shippingTotal.toString()).toStringAsFixed(2)} ",
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        Get.width >= 600
                                            ? getFontSize(context, 2)
                                            : getFontSize(context, -2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                        : const SizedBox(),
                    widget.orders.feeTotal != null &&
                            widget.orders.feeTotal != 0
                        ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Transaction Charges : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        Get.width >= 600
                                            ? getFontSize(context, 2)
                                            : getFontSize(context, -2),
                                  ),
                                ),
                                Text(
                                  "\$${double.parse(widget.orders.feeTotal.toString()).toStringAsFixed(2)} ",
                                  style: TextStyle(
                                    color: AppColors.nakedSyrup,
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        Get.width >= 600
                                            ? getFontSize(context, 2)
                                            : getFontSize(context, -2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.w600,
                            fontSize:
                                Get.width >= 600
                                    ? getFontSize(context, 2)
                                    : getFontSize(context, 2),
                          ),
                        ),
                        Text(
                          "\$${double.parse(widget.orders.total.toString()).toStringAsFixed(2)} ",
                          style: TextStyle(
                            color: AppColors.nakedSyrup,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Get.width >= 600
                                    ? getFontSize(context, 2)
                                    : getFontSize(context, -2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Get.width >= 600
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: (Get.width / 2) - 55,
                              height: 405,
                              decoration: BoxDecoration(
                                color: AppColors.yellowColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.nakedSyrup.withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  getFontSize(context, 0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Billing Address ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Euclid Circular B',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            Get.width >= 600
                                                ? getFontSize(context, 6)
                                                : getFontSize(context, 2),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: getFontSize(context, 0),
                                      ),
                                      child: Divider(
                                        color: AppColors.nakedSyrup.withOpacity(
                                          0.2,
                                        ),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.orders.billing?.firstName} ${widget.orders.billing?.lastName}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 4)
                                                      : getFontSize(context, 2),
                                            ),
                                          ),
                                          if (widget.orders.billing?.company !=
                                              null)
                                            Text(
                                              "${widget.orders.billing?.company}",
                                              style: TextStyle(
                                                color: AppColors.fontLightColor,
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.normal,
                                                fontSize:
                                                    Get.width >= 600
                                                        ? getFontSize(
                                                          context,
                                                          4,
                                                        )
                                                        : getFontSize(
                                                          context,
                                                          2,
                                                        ),
                                              ),
                                            ),
                                          Text(
                                            "${widget.orders.billing?.address1} ${widget.orders.billing?.address2}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 4)
                                                      : getFontSize(context, 2),
                                            ),
                                          ),
                                          Text(
                                            "${widget.orders.billing?.city} ${widget.orders.billing?.state} ${widget.orders.billing?.postcode}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 4)
                                                      : getFontSize(context, 2),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.yellowColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: 5,
                                                            ),
                                                        child: Icon(
                                                          Icons
                                                              .person_4_outlined,
                                                          size: getFontSize(
                                                            context,
                                                            6,
                                                          ),
                                                          color:
                                                              AppColors
                                                                  .nakedSyrup,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${widget.orders.billing?.phone}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Get.width >= 600
                                                                ? getFontSize(
                                                                  context,
                                                                  2,
                                                                )
                                                                : getFontSize(
                                                                  context,
                                                                  0,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.yellowColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: 5,
                                                            ),
                                                        child: Icon(
                                                          Icons.email_outlined,
                                                          size: getFontSize(
                                                            context,
                                                            6,
                                                          ),
                                                          color:
                                                              AppColors
                                                                  .nakedSyrup,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${widget.orders.billing?.email}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Get.width >= 600
                                                                ? getFontSize(
                                                                  context,
                                                                  2,
                                                                )
                                                                : getFontSize(
                                                                  context,
                                                                  0,
                                                                ),
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
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: getFontSize(context, 2)),
                            Container(
                              width: (Get.width / 2) - 55,
                              height: 405,
                              decoration: BoxDecoration(
                                color: AppColors.yellowColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.nakedSyrup.withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  getFontSize(context, 0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Shipping Address ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Euclid Circular B',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            Get.width >= 600
                                                ? getFontSize(context, 6)
                                                : getFontSize(context, 2),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: getFontSize(context, 0),
                                      ),
                                      child: Divider(
                                        color: AppColors.nakedSyrup.withOpacity(
                                          0.2,
                                        ),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.orders.shipping?.firstName} ${widget.orders.shipping?.lastName}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 4)
                                                      : getFontSize(context, 2),
                                            ),
                                          ),
                                          if (widget.orders.shipping?.company !=
                                              null)
                                            Text(
                                              "${widget.orders.shipping?.company}",
                                              style: TextStyle(
                                                color: AppColors.fontLightColor,
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.normal,
                                                fontSize:
                                                    Get.width >= 600
                                                        ? getFontSize(
                                                          context,
                                                          4,
                                                        )
                                                        : getFontSize(
                                                          context,
                                                          2,
                                                        ),
                                              ),
                                            ),
                                          Text(
                                            "${widget.orders.shipping?.address1} ${widget.orders.shipping?.address2}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 4)
                                                      : getFontSize(context, 2),
                                            ),
                                          ),
                                          Text(
                                            "${widget.orders.shipping?.city} ${widget.orders.shipping?.state} ${widget.orders.shipping?.postcode}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Get.width >= 600
                                                      ? getFontSize(context, 4)
                                                      : getFontSize(context, 2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.yellowColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.nakedSyrup.withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  getFontSize(context, -2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Billing Address ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Euclid Circular B',
                                        fontWeight: FontWeight.bold,
                                        fontSize: getFontSize(context, -2),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: getFontSize(context, -6),
                                      ),
                                      child: Divider(
                                        color: AppColors.nakedSyrup.withOpacity(
                                          0.2,
                                        ),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.orders.billing?.firstName} ${widget.orders.billing?.lastName}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -2,
                                              ),
                                            ),
                                          ),
                                          if (widget.orders.billing?.company !=
                                              null)
                                            Text(
                                              "${widget.orders.billing?.company}",
                                              style: TextStyle(
                                                color: AppColors.fontLightColor,
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.normal,
                                                fontSize: getFontSize(
                                                  context,
                                                  -2,
                                                ),
                                              ),
                                            ),
                                          Text(
                                            "${widget.orders.billing?.address1} ${widget.orders.billing?.address2}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${widget.orders.billing?.city} ${widget.orders.billing?.state} ${widget.orders.billing?.postcode}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.yellowColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: 5,
                                                            ),
                                                        child: Icon(
                                                          Icons
                                                              .person_4_outlined,
                                                          size: getFontSize(
                                                            context,
                                                            2,
                                                          ),
                                                          color:
                                                              AppColors
                                                                  .nakedSyrup,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${widget.orders.billing?.phone}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -4,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.yellowColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: 5,
                                                            ),
                                                        child: Icon(
                                                          Icons.email_outlined,
                                                          size: getFontSize(
                                                            context,
                                                            2,
                                                          ),
                                                          color:
                                                              AppColors
                                                                  .nakedSyrup,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${widget.orders.billing?.email}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: getFontSize(
                                                          context,
                                                          -4,
                                                        ),
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
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: getFontSize(context, -2)),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.yellowColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.nakedSyrup.withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  getFontSize(context, -2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Shipping Address ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Euclid Circular B',
                                        fontWeight: FontWeight.bold,
                                        fontSize: getFontSize(context, -2),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: getFontSize(context, -6),
                                      ),
                                      child: Divider(
                                        color: AppColors.nakedSyrup.withOpacity(
                                          0.2,
                                        ),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.orders.shipping?.firstName} ${widget.orders.shipping?.lastName}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -2,
                                              ),
                                            ),
                                          ),
                                          if (widget.orders.shipping?.company !=
                                              null)
                                            Text(
                                              "${widget.orders.shipping?.company}",
                                              style: TextStyle(
                                                color: AppColors.fontLightColor,
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.normal,
                                                fontSize: getFontSize(
                                                  context,
                                                  -2,
                                                ),
                                              ),
                                            ),
                                          Text(
                                            "${widget.orders.shipping?.address1} ${widget.orders.shipping?.address2}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${widget.orders.shipping?.city} ${widget.orders.shipping?.state} ${widget.orders.shipping?.postcode}",
                                            style: TextStyle(
                                              color: AppColors.fontLightColor,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
    );
  }
}
