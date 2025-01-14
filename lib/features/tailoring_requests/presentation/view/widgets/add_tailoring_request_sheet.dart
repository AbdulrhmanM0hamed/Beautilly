import 'dart:io';

import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/tailoring_requests/data/models/tailoring_request.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/fabric_detail_form.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/design_image_picker.dart';

class AddTailoringRequestSheet extends StatefulWidget {
  const AddTailoringRequestSheet({super.key});

  @override
  State<AddTailoringRequestSheet> createState() =>
      _AddTailoringRequestSheetState();
}

class _AddTailoringRequestSheetState extends State<AddTailoringRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<FabricDetail> _fabrics = [];
  String? _selectedSize;
  File? _designImage;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                // صورة التصميم
                DesignImagePicker(
                  image: _designImage,
                  onImagePicked: (file) {
                    setState(() {
                      _designImage = file;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // القياسات
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'الطول',
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'الوزن',
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // المقاس
                DropdownButtonFormField<String>(
                  value: _selectedSize,
                  decoration: const InputDecoration(
                    labelText: 'المقاس',
                  ),
                  items: ['S', 'M', 'L', 'XL', 'XXL'].map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // الأقمشة
                ..._fabrics.map((fabric) => FabricDetailForm(
                      fabric: fabric,
                      onRemove: () {
                        setState(() {
                          _fabrics.remove(fabric);
                        });
                      },
                    )),

                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _fabrics.add(FabricDetail(type: '', color: ''));
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                    'إضافة قماش',
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        color: AppColors.primary,
                        fontSize: FontSize.size14),
                  ),
                ),

                const SizedBox(height: 16),

                // مدة التنفيذ والوصف
                CustomTextField(
                  label: 'مدة التنفيذ (بالأيام)',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  label: 'وصف الطلب',
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                ),

                const SizedBox(height: 24),

                CustomButton(
                  onPressed: _submitRequest,
                  text: 'تقديم الطلب',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // TODO: تنفيذ إرسال الطلب
      Navigator.pop(context);
    }
  }
}
