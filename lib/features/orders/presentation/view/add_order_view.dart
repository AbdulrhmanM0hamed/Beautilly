import 'dart:io';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/order_request_model.dart';
import '../cubit/add_order_cubit/add_order_cubit.dart';
import '../cubit/add_order_cubit/add_order_state.dart';
import 'widgets/measurements_step.dart';
import 'widgets/fabrics_step.dart';
import 'widgets/image_step.dart';
import 'widgets/add_fabric_dialog.dart';

class AddOrderView extends StatefulWidget {
  static const String routeName = '/add-order';

  const AddOrderView({super.key});

  @override
  State<AddOrderView> createState() => _AddOrderViewState();
}

class _AddOrderViewState extends State<AddOrderView> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  File? _selectedImage;
  final List<FabricModel> _fabrics = [];
  String? selectedType;
  Color pickerColor = Colors.red;

  // Controllers
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedSize = 'M'; // Default size
  final _descriptionController = TextEditingController();
  final _executionTimeController = TextEditingController();

  // Available sizes
  static const List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _descriptionController.dispose();
    _executionTimeController.dispose();
    super.dispose();
  }

  void _pickImage(File image) {
    setState(() {
      _selectedImage = image;
    });
  }

  void _addFabric() {
    showDialog(
      context: context,
      builder: (context) => AddFabricDialog(
        onAdd: (fabric) {
          setState(() {
            _fabrics.add(fabric);
          });
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      context.read<AddOrderCubit>().addOrder(
            height: double.parse(_heightController.text),
            weight: double.parse(_weightController.text),
            size: _selectedSize,
            description: _descriptionController.text,
            executionTime: int.parse(_executionTimeController.text),
            fabrics: _fabrics,
            imagePath: _selectedImage!.path,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddOrderCubit, AddOrderState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: const CustomAppBar(title: 'إضافة طلب تفصيل'),
              body: BlocListener<AddOrderCubit, AddOrderState>(
                listener: (context, state) {
                  if (state is AddOrderSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('تم إضافة الطلب بنجاح')));
                     
                    Navigator.pop(context, true);
                  } else if (state is AddOrderError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: AppColors.primary,
                    ),
                  ),
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep == 0) {
                        // خطوة المقاسات
                        if (_formKey.currentState!.validate()) {
                          setState(() => _currentStep++);
                        }
                      } else if (_currentStep == 1) {
                        // خطوة القماش
                        if (_fabrics.isNotEmpty || selectedType != null) {
                          setState(() => _currentStep++);
                        } else {
                          CustomSnackbar.showError(
                            context: context,
                            message: 'يرجى إضافة القماش أو اختيار نوعه',
                          );
                        }
                      } else if (_currentStep == 2) {
                        // خطوة الصور
                        if (_selectedImage != null) {
                          _submitForm();
                        } else {
                          CustomSnackbar.showError(
                            context: context,
                            message: 'يرجى إضافة صورة التصميم',
                          );
                        }
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep--);
                      }
                    },
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            if (_currentStep > 0)
                              Expanded(
                                child: CustomButton(
                                  onPressed: details.onStepCancel,
                                  text: 'السابق',
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            if (_currentStep > 0) const SizedBox(width: 12),
                            Expanded(
                              child: BlocBuilder<AddOrderCubit, AddOrderState>(
                                builder: (context, state) {
                                  return CustomButton(
                                    onPressed: details.onStepContinue,
                                    text: _currentStep == 2
                                        ? 'إرسال الطلب'
                                        : 'التالي',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    steps: [
                      Step(
                        title: const Text('المقاسات'),
                        content: MeasurementsStep(
                          formKey: _formKey,
                          heightController: _heightController,
                          weightController: _weightController,
                          selectedSize: _selectedSize,
                          descriptionController: _descriptionController,
                          executionTimeController: _executionTimeController,
                          onSizeChanged: (value) {
                            setState(() => _selectedSize = value!);
                          },
                        ),
                        isActive: _currentStep >= 0,
                      ),
                      Step(
                        title: const Text('الأقمشة'),
                        content: FabricsStep(
                          onAddFabric: _addFabric,
                          onDeleteFabric: (fabric) =>
                              setState(() => _fabrics.remove(fabric)),
                          fabrics: _fabrics,
                          selectedType: selectedType,
                          pickerColor: pickerColor,
                          onTypeChanged: (value) {
                            setState(() {
                              selectedType = value;
                              if (selectedType != null) {
                                _fabrics.add(FabricModel(
                                  type: selectedType!,
                                  color:
                                      '#${pickerColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                                ));
                              }
                            });
                          },
                          onColorChanged: (color) {
                            setState(() {
                              pickerColor = color;
                              if (selectedType != null && _fabrics.isNotEmpty) {
                                _fabrics.last = FabricModel(
                                  type: _fabrics.last.type,
                                  color:
                                      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                                );
                              }
                            });
                          },
                          onFabricRemoved: (index) =>
                              setState(() => _fabrics.removeAt(index)),
                        ),
                        isActive: _currentStep >= 1,
                      ),
                      Step(
                        title: const Text('الصورة'),
                        content: ImageStep(
                          selectedImage: _selectedImage,
                          onImagePick: _pickImage,
                          onImageRemove: () =>
                              setState(() => _selectedImage = null),
                        ),
                        isActive: _currentStep >= 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is AddOrderLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CustomProgressIndcator(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
