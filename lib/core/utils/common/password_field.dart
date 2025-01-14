import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved,
    required this.hintText,
    this.validator,
  });
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String hintText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      obscureText: _obscureText, // تمرير قيمة _obscureText
      prefix: const Icon(
        Icons.lock,
      ),
      label: widget.hintText,
      suffix: GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText
              ? Icons.remove_red_eye
              : Icons.visibility_off, // تغيير الأيقونة بناءً على الحالة
        ),
      ),
      // تمرير onSaved

      validator: widget.validator,
    );
  }
}
