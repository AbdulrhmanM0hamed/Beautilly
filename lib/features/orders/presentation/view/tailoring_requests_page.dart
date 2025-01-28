import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/all_oreder_widget.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/my_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';

class TailoringRequestsView extends StatefulWidget {
  const TailoringRequestsView({super.key});

  @override
  State<TailoringRequestsView> createState() => _TailoringRequestsPageState();
}

class _TailoringRequestsPageState extends State<TailoringRequestsView>
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
    return BlocProvider(
      create: (context) => sl<OrdersCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('طلبات التفصيل',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size20,
              )),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'طلباتي'),
              Tab(text: 'طلبات المستخدمين'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            MyOrdersWidget(),
            AllOrdersWidget(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // إضافة طلب تفصيل جديد
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
