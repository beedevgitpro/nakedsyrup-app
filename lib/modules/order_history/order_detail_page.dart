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
        'Order #${widget.orders.orderId}',
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
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to start
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Get.width >= 600
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "#${widget.orders.orderId} ",
                                    style: TextStyle(
                                      color: AppColors.nakedSyrup,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.bold,
                                      fontSize: getFontSize(context, 2),
                                    ),
                                  ),
                                ],
                                text: "Order ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Euclid Circular B',
                                  fontWeight: FontWeight.normal,
                                  fontSize: getFontSize(context, 2),
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: " $convertedDate  ",
                                        style: TextStyle(
                                          color: AppColors.nakedSyrup,
                                          fontFamily: 'Euclid Circular B',
                                          fontWeight: FontWeight.bold,
                                          fontSize: getFontSize(context, 2),
                                        ),
                                      ),
                                    ],
                                    text: "Order Date : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.normal,
                                      fontSize: getFontSize(context, 2),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        widget.orders.status.toString() ==
                                                "cancelled"
                                            ? Colors.red
                                            : widget.orders.status.toString() ==
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
                                            widget.orders.status.toString() ==
                                                    "cancelled"
                                                ? Icons.cancel_outlined
                                                : widget.orders.status
                                                        .toString() ==
                                                    "completed"
                                                ? Icons.check_circle_outline
                                                : Icons
                                                    .incomplete_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            widget.orders.status.toString() ??
                                                "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: getFontSize(
                                                context,
                                                -3,
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
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "#${widget.orders.orderId} ",
                                        style: TextStyle(
                                          color: AppColors.nakedSyrup,
                                          fontFamily: 'Euclid Circular B',
                                          fontWeight: FontWeight.bold,
                                          fontSize: getFontSize(context, 2),
                                        ),
                                      ),
                                    ],
                                    text: "Order ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.normal,
                                      fontSize: getFontSize(context, 2),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        widget.orders.status.toString() ==
                                                "cancelled"
                                            ? Colors.red
                                            : widget.orders.status.toString() ==
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
                                            widget.orders.status.toString() ==
                                                    "cancelled"
                                                ? Icons.cancel_outlined
                                                : widget.orders.status
                                                        .toString() ==
                                                    "completed"
                                                ? Icons.check_circle_outline
                                                : Icons
                                                    .incomplete_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            widget.orders.status.toString() ??
                                                "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: getFontSize(
                                                context,
                                                -3,
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
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: " $convertedDate  ",
                                    style: TextStyle(
                                      color: AppColors.nakedSyrup,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.bold,
                                      fontSize: getFontSize(context, 2),
                                    ),
                                  ),
                                ],
                                text: "Order Date : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Euclid Circular B',
                                  fontWeight: FontWeight.normal,
                                  fontSize: getFontSize(context, 2),
                                ),
                              ),
                            ),
                          ],
                        ),

                    widget.orders.items!.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            // height: 100,
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
                                          ? 150
                                          : 70,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      widget.orders.items?[x].image
                                                  .toString()
                                                  .isNotEmpty ==
                                              true
                                          ? Image.network(
                                            widget.orders.items?[x].image
                                                    .toString() ??
                                                "",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                          : const SizedBox(),
                                      const SizedBox(width: 7),
                                      Expanded(
                                        // Ensures Column takes remaining horizontal space
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start, // Align text to start
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget
                                                      .orders
                                                      .items?[x]
                                                      .productName ??
                                                  "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: getFontSize(
                                                  context,
                                                  1,
                                                ),
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                            Text(
                                              "\$${double.parse(widget.orders.items?[x].price.toString() ?? "0.0").toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.nakedSyrup,
                                                fontSize: getFontSize(
                                                  context,
                                                  1,
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
                          ),
                        )
                        : const SizedBox(),
                    widget.orders.subTotal != null &&
                            widget.orders.subTotal != 0
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Subtotal : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w500,
                                fontSize: getFontSize(context, 1),
                              ),
                            ),
                            Text(
                              "\$${double.parse(widget.orders.subTotal.toString()).toStringAsFixed(2)} ",
                              style: TextStyle(
                                color: AppColors.nakedSyrup,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.bold,
                                fontSize: getFontSize(context, 1),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "GST : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(context, 1),
                          ),
                        ),
                        Text(
                          "\$${double.parse(widget.orders.gst.toString()).toStringAsFixed(2)} ",
                          style: TextStyle(
                            color: AppColors.nakedSyrup,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.bold,
                            fontSize: getFontSize(context, 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    widget.orders.discount != null &&
                            widget.orders.discount != 0
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Discount : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w500,
                                fontSize: getFontSize(context, 1),
                              ),
                            ),
                            Text(
                              "\$${double.parse(widget.orders.discount.toString()).toStringAsFixed(2)} ",
                              style: TextStyle(
                                color: AppColors.nakedSyrup,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.bold,
                                fontSize: getFontSize(context, 1),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),
                    widget.orders.discount != null &&
                            widget.orders.discount != 0
                        ? const SizedBox(height: 10)
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Total : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(context, 1),
                          ),
                        ),
                        Text(
                          "\$${double.parse(widget.orders.total.toString()).toStringAsFixed(2)} ",
                          style: TextStyle(
                            color: AppColors.nakedSyrup,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.bold,
                            fontSize: getFontSize(context, 1),
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
                              width: (Get.width / 2) - 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(color: Colors.black54),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(color: Colors.black54),
                                      color: Colors.black12,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Billing Address ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(context, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.orders.billing?.firstName} ${widget.orders.billing?.lastName}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.billing?.company}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.billing?.address1} ${widget.orders.billing?.address2}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.billing?.city} ${widget.orders.billing?.state} ${widget.orders.billing?.postcode}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -1,
                                              ),
                                            ),
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 5,
                                                      ),
                                                  child: Icon(
                                                    Icons.person_pin_outlined,
                                                    size: getFontSize(
                                                      context,
                                                      2,
                                                    ),
                                                    color: AppColors.nakedSyrup,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${widget.orders.billing?.phone}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily:
                                                      'Euclid Circular B',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: getFontSize(
                                                    context,
                                                    -1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -1,
                                              ),
                                            ),
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
                                                    color: AppColors.nakedSyrup,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${widget.orders.billing?.email}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily:
                                                      'Euclid Circular B',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: getFontSize(
                                                    context,
                                                    -1,
                                                  ),
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
                            ),

                            Container(
                              width: (Get.width / 2) - 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(color: Colors.black54),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(color: Colors.black54),
                                      color: Colors.black12,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Shipping Address ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(context, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.orders.shipping?.firstName} ${widget.orders.shipping?.lastName}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.shipping?.company}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.shipping?.address1} ${widget.orders.shipping?.address2}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.shipping?.city} ${widget.orders.shipping?.state} ${widget.orders.shipping?.postcode}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(color: Colors.black54),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(color: Colors.black54),
                                      color: Colors.black12,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Billing Address ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(context, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.orders.billing?.firstName} ${widget.orders.billing?.lastName}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.billing?.company}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.billing?.address1} ${widget.orders.billing?.address2}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.billing?.city} ${widget.orders.billing?.state} ${widget.orders.billing?.postcode}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -1,
                                              ),
                                            ),
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 5,
                                                      ),
                                                  child: Icon(
                                                    Icons.person_pin_outlined,
                                                    size: getFontSize(
                                                      context,
                                                      2,
                                                    ),
                                                    color: AppColors.nakedSyrup,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${widget.orders.billing?.phone}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily:
                                                      'Euclid Circular B',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: getFontSize(
                                                    context,
                                                    -1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.normal,
                                              fontSize: getFontSize(
                                                context,
                                                -1,
                                              ),
                                            ),
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
                                                    color: AppColors.nakedSyrup,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${widget.orders.billing?.email}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily:
                                                      'Euclid Circular B',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: getFontSize(
                                                    context,
                                                    -1,
                                                  ),
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
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(color: Colors.black54),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(color: Colors.black54),
                                      color: Colors.black12,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Shipping Address ",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(context, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.orders.shipping?.firstName} ${widget.orders.shipping?.lastName}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.shipping?.company}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.shipping?.address1} ${widget.orders.shipping?.address2}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
                                          ),
                                        ),
                                        Text(
                                          "${widget.orders.shipping?.city} ${widget.orders.shipping?.state} ${widget.orders.shipping?.postcode}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.normal,
                                            fontSize: getFontSize(context, -1),
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
