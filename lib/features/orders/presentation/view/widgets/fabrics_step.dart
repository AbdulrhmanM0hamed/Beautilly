import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/helpers/color_helper.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/models/fabric_types.dart';
import '../../../data/models/order_request_model.dart';

class FabricsStep extends StatelessWidget {
  final List<FabricModel> fabrics;
  final String? selectedType;
  final Color pickerColor;
  final Function(int) onFabricRemoved;
  final Function(String?) onTypeChanged;
  final Function(Color) onColorChanged;

  const FabricsStep({
    super.key,
    required this.fabrics,
    required this.selectedType,
    required this.pickerColor,
    required this.onFabricRemoved,
    required this.onTypeChanged,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fabrics.isNotEmpty) ...[
          const Text(
            'الأقمشة المختارة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fabrics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final fabric = fabrics[index];
              return Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: ColorHelper.getColorFromHex(fabric.color),
                  ),
                  title: Text(
                    fabric.type,
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.black
                            : AppColors.white),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      onFabricRemoved(index);
                    },
                    child: SvgPicture.asset(
                      "assets/icons/trash.svg",
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(height: 32, thickness: 1),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إضافة قماش جديد',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'نوع القماش',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: FabricType.types.keys
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: onTypeChanged,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 210,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[700]!
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 40,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: pickerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(
                          height: 260,
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: onColorChanged,
                            pickerAreaBorderRadius: BorderRadius.circular(8),
                            portraitOnly: true,
                            labelTypes: const [],
                            enableAlpha: false,
                            displayThumbColor: true,
                            hexInputBar: true,
                            pickerAreaHeightPercent: 0.6,
                            colorPickerWidth: 180,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
