import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import '../widgets/service_card.dart';

class AllSalonServicesView extends StatelessWidget {
  final List<Service> services;
  final int shopId;

  const AllSalonServicesView({
    super.key,
    required this.services,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'كل الخدمات',
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ServiceCard(
              service: services[index],
              shopId: shopId,
            ),
          );
        },
      ),
    );
  }
}
