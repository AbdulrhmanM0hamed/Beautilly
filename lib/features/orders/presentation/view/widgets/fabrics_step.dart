import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/helpers/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/models/order_request_model.dart';

class FabricsStep extends StatelessWidget {
  final List<FabricModel> fabrics;
  final String? selectedType;
  final Color pickerColor;
  final Function(int) onFabricRemoved;
  final Function(String?) onTypeChanged;
  final Function(Color) onColorChanged;
  final Function() onAddFabric;
  final Function(FabricModel) onDeleteFabric;

  const FabricsStep({
    super.key,
    required this.fabrics,
    required this.selectedType,
    required this.pickerColor,
    required this.onFabricRemoved,
    required this.onTypeChanged,
    required this.onColorChanged,
    required this.onAddFabric,
    required this.onDeleteFabric,
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
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.white,
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'إضافة قماش جديد',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (fabrics.length >= 2)
                    Text(
                      'الحد الأقصى قماشين',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (fabrics.length < 2)
                CustomButton(
                  onPressed: onAddFabric,
                  text: 'إضافة قماش',
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
