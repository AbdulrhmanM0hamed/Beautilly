import 'package:flutter/material.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';

class CustomProfileField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool enabled;
  final double? width;
  final int? maxLength;
  final int? maxLines;
  final TextDirection? textDirection;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  const CustomProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
    this.enabled = true,
    this.width,
    this.maxLength,
    this.maxLines = 1,
    this.textDirection,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<CustomProfileField> createState() => _CustomProfileFieldState();
}

class _CustomProfileFieldState extends State<CustomProfileField> {
  bool _obscureText = true;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark 
        ? _isFocused 
            ? Colors.grey[900] 
            : Colors.grey[850]
        : _isFocused 
            ? Colors.grey[50] 
            : Colors.grey[100];

    return Container(
      width: widget.width,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 4),
              child: Text(
                widget.label,
                style: getMediumStyle(
                  color: _isFocused 
                      ? AppColors.primary
                      : isDark 
                          ? Colors.grey[300]
                          : Colors.grey[700],
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.grey.withValues(alpha:0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword && _obscureText,
              enabled: widget.enabled,
              validator: widget.validator,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              textDirection: widget.textDirection,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: getRegularStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: _isFocused 
                      ? AppColors.primary
                      : isDark 
                          ? Colors.grey[400]
                          : Colors.grey[600],
                  size: 22,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText 
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: _isFocused 
                              ? AppColors.primary
                              : isDark 
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: backgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark 
                        ? Colors.grey[800]! 
                        : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha:0.8),
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red[400]!,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red[400]!,
                    width: 1.5,
                  ),
                ),
                errorStyle: getRegularStyle(
                  color: Colors.red[400]!,
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 