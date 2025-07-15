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
    title: Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w700,
        fontSize: getFontSize(context, 1),
        color: Colors.black,
      ),
    ),
    actions: actions,
    centerTitle: true,
  );
}
