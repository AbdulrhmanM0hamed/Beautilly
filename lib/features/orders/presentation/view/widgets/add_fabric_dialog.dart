import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../data/models/fabric_types.dart';
import '../../../data/models/order_request_model.dart';

class AddFabricDialog extends StatefulWidget {
  final Function(FabricModel) onAdd;

  const AddFabricDialog({super.key, required this.onAdd});

  @override
  State<AddFabricDialog> createState() => _AddFabricDialogState();
}

class _AddFabricDialogState extends State<AddFabricDialog> {
  String? selectedType;
  Color pickerColor = Colors.red;

  // تحويل آمن للون إلى سلسلة Hex
  String _safeColorToHex(Color color) {
    try {
      int red = color.red;
      int green = color.green;
      int blue = color.blue;
      
      // تنسيق كل قيمة لون بشكل منفصل
      String redHex = red.toRadixString(16).padLeft(2, '0');
      String greenHex = green.toRadixString(16).padLeft(2, '0');
      String blueHex = blue.toRadixString(16).padLeft(2, '0');
      
      // تجميع القيم مع إضافة # في البداية
      String hexColor = '#$redHex$greenHex$blueHex';
      
      // تحويل إلى أحرف كبيرة للتناسق
      hexColor = hexColor.toUpperCase();
      
      debugPrint('Color components - R: $red, G: $green, B: $blue');
      debugPrint('Generated hex color: $hexColor');
      
      return hexColor;
    } catch (e) {
      debugPrint('Error converting color to hex: $e');
      // قيمة افتراضية آمنة في حالة حدوث خطأ
      return '#FF0000';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة قماش'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'نوع القماش',
                border: OutlineInputBorder(),
              ),
              items: FabricType.types.keys
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('اختر اللون'),
            const SizedBox(height: 8),
            ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                setState(() {
                  pickerColor = color;
                });
              },
              // تقليل خيارات اللون لتجنب المشاكل في release
              portraitOnly: true,
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
              // إضافة قيود على نطاق الألوان
              colorPickerWidth: 300,
              pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(10)),
              displayThumbColor: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            if (selectedType != null) {
              final colorHex = _safeColorToHex(pickerColor);
              
              // التحقق من صحة تنسيق اللون قبل الإضافة
              if (colorHex.length == 7 && colorHex.startsWith('#')) {
                widget.onAdd(FabricModel(
                  type: selectedType!,
                  color: colorHex,
                ));
                Navigator.pop(context);
              } else {
                // إظهار رسالة خطأ إذا كان تنسيق اللون غير صحيح
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('حدث خطأ في اختيار اللون، الرجاء المحاولة مرة أخرى'),
                  ),
                );
              }
            }
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}

// إضافة امتداد للتحقق من صحة تنسيق اللون
extension ColorValidation on String {
  bool get isValidHexColor {
    final hexColorRegex = RegExp(r'^#([A-Fa-f0-9]{6})$');
    return hexColorRegex.hasMatch(this);
  }
}