import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/nearby/presentation/cubit/search_shops_cubit.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/discover_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NearbyPage extends StatelessWidget {
  const NearbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchShopsCubit>()..filterShops(),
      child: const NearbyView(),
    );
  }
}

class NearbyView extends StatefulWidget {
  const NearbyView({super.key});

  @override
  State<NearbyView> createState() => _NearbyViewState();
}

class _NearbyViewState extends State<NearbyView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اكتشف الأماكن'),
      ),
      body: DiscoverBottomSheet(
        scrollController: _scrollController,
      ),
    );
  }
} 