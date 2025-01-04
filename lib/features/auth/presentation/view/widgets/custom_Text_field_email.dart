import 'package:flutter/material.dart';

class CustomTextFieldEmail extends StatelessWidget {
  CustomTextFieldEmail({
    super.key,
    required this.hintText,
    required this.suffixIcon,
    required this.onSaved,
    this.obsacureText = false,
  });
  final String hintText;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final bool obsacureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsacureText,
      onSaved: onSaved,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'يرجى إدخال البريد الإلكتروني';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'يرجى إدخال بريد إلكتروني صحيح';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
