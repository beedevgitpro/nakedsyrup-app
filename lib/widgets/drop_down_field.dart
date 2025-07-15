import 'package:flutter/material.dart';

Widget AppDropDownField({
  required String lable,
  var value,
  required List<DropdownMenuItem> itemList,
  function,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonFormField(
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, size: 18.0, color: Colors.grey),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: const BorderRadius.all(Radius.circular(9)),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          contentPadding: const EdgeInsets.only(left: 20, top: 12, right: 20),

          // hintText: lable,
        ),
        validator: function,
        value: value,
        items: itemList,
        onChanged: (value) {},
      ),
    ),
  );
}
