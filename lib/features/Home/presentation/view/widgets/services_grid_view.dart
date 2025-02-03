import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/domain/entities/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../cubit/service_cubit/services_cubit.dart';
import '../../cubit/service_cubit/services_state.dart';

class ServicesGridView extends StatefulWidget {
  const ServicesGridView({super.key});

  @override
  State<ServicesGridView> createState() => _ServicesGridViewState();
}

class _ServicesGridViewState extends State<ServicesGridView> {
  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return const Center(
            child: CustomProgressIndcator(
              color: AppColors.primary,
            ),
          );
        }

        if (state is ServicesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ServicesCubit>().loadServices();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is ServicesLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: state.services.length,
            itemBuilder: (context, index) {
              final service = state.services[index];
              return ServiceCard(service: service);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceEntity service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            _getIconPath(service.name),
            height: 35,
            width: 35,
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: getMediumStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getIconPath(String name) {
    switch (name) {
      case 'تصفيف  الشعر':
        return AppAssets.hairCutIcon;
      case 'اظافر':
        return AppAssets.nailsIcon;
      case 'عناية بالبشرة':
        return AppAssets.facialIcon;
      case 'صبغات':
        return AppAssets.coloringIcon;
      case 'ازالة الشعر':
        return AppAssets.waxingIcon;
      case 'تصميم ازياء':
        return AppAssets.dressVector;
      case 'مكياج':
        return AppAssets.makeupIcon;
      case 'سبا':
        return AppAssets.spaIcon;
      default:
        return AppAssets.spaIcon;
    }
  }
}
