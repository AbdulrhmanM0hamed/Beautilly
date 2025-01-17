import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/tailoring_requests_view_body.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/add_tailoring_request_sheet.dart';

class TailoringRequestsView extends StatefulWidget {
  const TailoringRequestsView({super.key});

  @override
  State<TailoringRequestsView> createState() => _TailoringRequestsViewState();
}

class _TailoringRequestsViewState extends State<TailoringRequestsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "طلبات التفصيل",
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: getBoldStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
          unselectedLabelStyle: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey,
          tabs: const [
            Tab(text: "طلباتي"),
            Tab(text: "طلبات المستخدمين"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // طلباتي
          TailoringRequestsViewBody(isMyRequests: true),
          // طلبات المستخدمين
          TailoringRequestsViewBody(isMyRequests: false),
        ],
      ),
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
