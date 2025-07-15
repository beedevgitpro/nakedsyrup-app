import 'package:flutter/material.dart';

Widget AppTextFormField({
  required TextEditingController controller,
  required String lable,
  Widget suffix = const SizedBox(),
  bool obscureText = false,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  TextCapitalization? textCapitalization,
  bool readOnly = false,
  var maxLength,
  int? maxLines = 1,
  void Function()? onTap,
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
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
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
          suffixIcon: suffix,
          // suffix: suffix,
          // hintStyle: TextStyle(
          //   color: Colors.grey,
          //   fontSize: getFontSize(Get.context!, -3),
          //   fontWeight: FontWeight.normal,
          //   fontFamily: "Montserrat",
          // ),
        ),
        textCapitalization:
            textCapitalization != null
                ? textCapitalization
                : TextCapitalization.none,
        keyboardType: keyboardType,
        textInputAction: textInputAction != null ? textInputAction : null,
        onTap: onTap,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: function,
      ),
    ),
  );
}
