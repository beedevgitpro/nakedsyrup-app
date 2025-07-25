import 'package:flutter/material.dart';

import '../utility/responsive_text.dart';

PreferredSizeWidget AppBarWidget(
  String text,
  Widget leading,
  BuildContext context, {
  List<Widget> actions = const [],
}) {
  return AppBar(
    leading: leading,
    actionsPadding: EdgeInsets.only(right: getFontSize(context, -3)),
    backgroundColor: Color(0XFFF3E9D3),
    leadingWidth: (getFontSize(context, 0) * 4),
    title: Text(
      text,
      style: TextStyle(
        fontFamily: "Euclid Circular B",
        fontWeight: FontWeight.bold,
        fontSize: getFontSize(context, 1),
        color: Colors.black,
      ),
    ),
    actions: actions,
    centerTitle: true,
  );
}
