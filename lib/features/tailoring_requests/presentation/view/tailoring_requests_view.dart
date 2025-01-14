import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/tailoring_requests_view_body.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/add_tailoring_request_sheet.dart';

class TailoringRequestsView extends StatelessWidget {
  const TailoringRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "طلبات التفصيل",
      ),
      body: const TailoringRequestsViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTailoringRequestSheet(),
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
