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
  int? maxLength,
  int? maxLines = 1,
  void Function()? onTap,
  onChanged,
  function,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 20,
        ), // 👈 Add vertical padding explicitly
        suffixIcon: suffix,
      ),
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: function,
    ),
  );
}
