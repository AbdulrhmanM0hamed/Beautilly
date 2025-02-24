import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/features/Home/domain/entities/service_entity.dart';
import 'package:flutter/material.dart';

class ServiceDescription extends StatelessWidget {
  final ServiceEntity service;

  const ServiceDescription({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    if (service.description == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.description ?? '',
            style: getRegularStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[700],
            ),
          ),
          Text('المتاجر',
              style: getBoldStyle(
                  fontSize: FontSize.size18, fontFamily: FontConstant.cairo)),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
