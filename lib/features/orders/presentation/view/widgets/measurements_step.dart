import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/validators/form_validators.dart';

class MeasurementsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final String selectedSize;
  final TextEditingController descriptionController;
  final TextEditingController executionTimeController;
  final Function(String?) onSizeChanged;
  static const List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  const MeasurementsStep({
    super.key,
    required this.formKey,
    required this.heightController,
    required this.weightController,
    required this.selectedSize,
    required this.descriptionController,
    required this.executionTimeController,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            prefix: const Icon(Icons.height),
            label: 'الطول (سم)',
            validator: FormValidators.validateHeight,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            label: 'الوزن (كجم)',
            prefix: const Icon(Icons.monitor_weight_outlined),
            validator: FormValidators.validateWeight,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedSize,
            decoration: const InputDecoration(
              labelText: 'المقاس',
              prefixIcon: Icon(Icons.straighten),
              border: OutlineInputBorder(),
            ),
            items: sizes
                .map((size) => DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    ))
                .toList(),
            onChanged: onSizeChanged,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: descriptionController,
            maxLines: 3,
            label: 'الوصف',
            prefix: const Icon(Icons.description),
            validator: FormValidators.validateDescription,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: executionTimeController,
            keyboardType: TextInputType.number,
            label: 'وقت التنفيذ (بالأيام)',
            prefix: const Icon(Icons.timer),
            validator: FormValidators.validateExecutionTime,
          ),
        ],
      ),
    );
  }
}
