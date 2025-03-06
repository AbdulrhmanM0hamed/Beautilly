import 'package:beautilly/core/utils/common/custom_dialog_button.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../data/models/fabric_types.dart';
import '../../../data/models/fabric_colors.dart';
import '../../../data/models/order_request_model.dart';

class AddFabricDialog extends StatefulWidget {
  final Function(FabricModel) onAdd;

  const AddFabricDialog({super.key, required this.onAdd});

  @override
  State<AddFabricDialog> createState() => _AddFabricDialogState();
}

class _AddFabricDialogState extends State<AddFabricDialog> {
  String? selectedType;
  String? selectedColorName;

  Widget _buildColorGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: FabricColors.colors.length,
      itemBuilder: (context, index) {
        final colorName = FabricColors.colors.keys.elementAt(index);
        final color = FabricColors.colors.values.elementAt(index);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                selectedColorName = colorName;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: selectedColorName == colorName
                      ? Colors.blue
                      : Colors.grey,
                  width: selectedColorName == colorName ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: selectedColorName == colorName
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافة قماش',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildColorGrid(),
            ),
            if (selectedColorName != null) ...[
              const SizedBox(height: 8),
              Text(
                'اللون المختار: $selectedColorName',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomDialogButton(
                  onPressed: () => Navigator.pop(context),
                  text: 'إلغاء',
                  backgroundColor: Colors.grey[500],
                  textColor: Colors.white,
                ),
                const SizedBox(width: 10),
                CustomDialogButton(
                  onPressed: () {
                    if (selectedType != null && selectedColorName != null) {
                      final color = FabricColors.colors[selectedColorName!]!;
                      final colorHex = FabricColors.colorToHex(color);

                      widget.onAdd(FabricModel(
                        type: selectedType!,
                        color: colorHex,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  text: 'إضافة',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
