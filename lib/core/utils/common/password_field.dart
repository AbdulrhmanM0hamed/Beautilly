import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved,
    required this.hintText,
  });

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
      hint: widget.hintText,
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

      validator: FormValidators.validatePassword,
    );
  }
}
