import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                              fontSize: getFontSize(context, -1),
                            ),
                          ),
                          TextSpan(
                            text: "was placed on ",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.normal,
                              fontSize: getFontSize(context, -1),
                            ),
                          ),
                          TextSpan(
                            text: "$convertedDate ",
                            style: TextStyle(
                              color: AppColors.nakedSyrup,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.bold,
                              fontSize: getFontSize(context, -1),
                            ),
                          ),
                          TextSpan(
                            text: "and is currently  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.normal,
                              fontSize: getFontSize(context, -1),
                            ),
                          ),
                          TextSpan(
                            text: "${widget.orders.status}. ",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.normal,
                              fontSize: getFontSize(context, -1),
                            ),
                          ),
                        ],
                        text: "Order ",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Euclid Circular B',
                          fontWeight: FontWeight.normal,
                          fontSize: getFontSize(context, -1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Order Details : ",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Euclid Circular B',
                        fontWeight: FontWeight.normal,
                        fontSize: getFontSize(context, 2),
                      ),
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
                                          ? 100
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
                                            width: 50,
                                            height: 50,
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
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                            Text(
                                              "\$${double.parse(widget.orders.items?[x].price.toString() ?? "0.0").toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.nakedSyrup,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(context, -1),
                          ),
                        ),
                        Text(
                          "\$${double.parse(widget.orders.total.toString()).toStringAsFixed(2)} ",
                          style: TextStyle(
                            color: AppColors.nakedSyrup,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.bold,
                            fontSize: getFontSize(context, -1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                    "Billing address : ",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.w600,
                                      fontSize: getFontSize(context, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                      fontSize: getFontSize(context, -1),
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 5,
                                          ),
                                          child: Icon(
                                            Icons.person_pin_outlined,
                                            size: getFontSize(context, 2),
                                            color: AppColors.nakedSyrup,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${widget.orders.billing?.phone}",
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
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.normal,
                                      fontSize: getFontSize(context, -1),
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 5,
                                          ),
                                          child: Icon(
                                            Icons.email_outlined,
                                            size: getFontSize(context, 2),
                                            color: AppColors.nakedSyrup,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${widget.orders.billing?.email}",
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
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                    "Shipping address : ",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Euclid Circular B',
                                      fontWeight: FontWeight.w600,
                                      fontSize: getFontSize(context, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
