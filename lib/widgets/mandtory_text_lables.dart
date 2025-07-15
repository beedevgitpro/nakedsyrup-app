import 'package:flutter/material.dart';

import '../../utility/responsive_text.dart';

Widget textLabel(String text, BuildContext context, bool isMandatory) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Row(
      children: <Widget>[
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: getFontSize(context, -2),
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if (isMandatory)
          Container(
            margin: const EdgeInsets.only(left: 3),
            padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
            child: const Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
      ],
    ),
  );
}
