import 'package:beautilly/core/utils/constant/app_assets.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: AppAssets.onboarding1,
    title: 'اكتشفي أفضل صالونات التجميل',
    description: 'تصفحي واختاري من بين أفضل صالونات التجميل في المملكة',
  ),
  OnboardingModel(
    image: AppAssets.onboarding2,
    title: 'احجزي موعدك بسهولة',
    description: 'احجزي موعدك في أي وقت وأي مكان بضغطة زر واحدة',
  ),
  OnboardingModel(
    image: AppAssets.onboarding4,
    title: 'استمتعي بتجربة مميزة',
    description: 'احصلي على خدمات تجميل احترافية من أمهر المتخصصات',
  ),
];
