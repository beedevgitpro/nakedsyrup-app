import 'package:flutter/material.dart';

class DialogShow extends StatelessWidget {
  DialogShow({
    super.key,
    required this.content,
    required this.title,
    this.actionChildern,
    this.textBack,
    this.text,
    this.onPress,
    this.onPressBack,
  });
  Widget content;
  Widget title;
  var actionChildern;
  var onPress;
  var onPressBack;
  var text;
  var textBack;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        ElevatedButton(onPressed: onPress, child: Text(text)),
        ElevatedButton(onPressed: onPressBack, child: Text(textBack)),
      ],
    );
  }
}
