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
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
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
              final colorHex = '#${pickerColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
              widget.onAdd(FabricModel(
                type: selectedType!,
                color: colorHex,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
} 