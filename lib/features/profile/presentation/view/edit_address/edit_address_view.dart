import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/profile/presentation/view/edit_address/widgets/address_form.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/features/profile/data/models/profile_model.dart';
import '../../controllers/edit_address_controller.dart';

class EditAddressView extends StatefulWidget {
  final ProfileModel profile;

  const EditAddressView({
    super.key,
    required this.profile,
  });

  @override
  State<EditAddressView> createState() => _EditAddressViewState();
}

class _EditAddressViewState extends State<EditAddressView> {
  late final EditAddressController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = EditAddressController(widget.profile);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CustomProgressIndcator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'تعديل العنوان',
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'باختيارك للعنوان سيتم عرض المتاجر القريبة منك لتسهيل الوصول إليك',
                                style: getRegularStyle(
                                  fontFamily: FontConstant.cairo,
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AddressForm(
                        controller: _controller,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: _controller.isLoading
                              ? null
                              : () => _controller.updateAddress(context),
                          text: 'حفظ التغييرات',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_controller.isLoading)
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
      ),
    );
  }
}
