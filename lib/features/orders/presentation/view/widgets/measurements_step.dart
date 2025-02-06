import 'package:flutter/material.dart';
import '../../../../../core/utils/common/custom_text_field.dart';

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
          TextFormField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'الطول (سم)',
              prefixIcon: Icon(Icons.height),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'الرجاء إدخال الطول';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'الوزن (كجم)',
              prefixIcon: Icon(Icons.monitor_weight_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'الرجاء إدخال الوزن';
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedSize,
            decoration: const InputDecoration(
              labelText: 'المقاس',
              prefixIcon: Icon(Icons.straighten),
              border: OutlineInputBorder(),
            ),
            items: sizes.map((size) => DropdownMenuItem(
              value: size,
              child: Text(size),
            )).toList(),
            onChanged: onSizeChanged,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'الوصف',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'الرجاء إدخال الوصف';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: executionTimeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'وقت التنفيذ (بالأيام)',
              prefixIcon: Icon(Icons.timer),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'الرجاء إدخال وقت التنفيذ';
              return null;
            },
          ),
        ],
      ),
    );
  }
} 