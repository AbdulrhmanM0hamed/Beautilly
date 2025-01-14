import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/features/tailoring_requests/data/models/tailoring_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';

class FabricDetailForm extends StatefulWidget {
  final FabricDetail fabric;
  final VoidCallback onRemove;

  const FabricDetailForm({
    required this.fabric,
    required this.onRemove,
  });

  @override
  State<FabricDetailForm> createState() => _FabricDetailFormState();
}

class _FabricDetailFormState extends State<FabricDetailForm> {
  late TextEditingController _typeController;
  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.fabric.type);
    if (widget.fabric.color.isNotEmpty) {
      _selectedColor = Color(int.parse(widget.fabric.color));
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'اختاري اللون',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
                widget.fabric.color =
                    '0x${color.value.toRadixString(16).toUpperCase()}';
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          CustomButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'تم',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _typeController,
                    label: 'نوع القماش',
                    onChanged: (value) {
                      widget.fabric.type = value;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
