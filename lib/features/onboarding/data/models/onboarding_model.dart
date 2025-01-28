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
    image: AppAssets.onboarding5,
    title: 'اكتشفي أفضل صالونات التجميل ومصممي الأزياء',
    description:
        'تصفحي واختاري من بين نخبة صالونات التجميل وأشهر مصممي الأزياء في المملكة.',
  ),
  OnboardingModel(
    image: AppAssets.onboarding6,
    title: 'صممي أزياءك بسهولة',
    description:
        'تواصلي مع أمهر المصممين لتفصيل أزياء تناسب ذوقك الخاص بضغطة زر.',
  ),
  OnboardingModel(
    image: AppAssets.onboarding7,
    title: 'احجزي موعدك بسهولة',
    description:
        'احجزي مواعيد التجميل أو استشارات تصميم الأزياء في أي وقت وأي مكان بسهولة تامة.',
  ),
  OnboardingModel(
    image: AppAssets.onboarding8,
    title: 'استمتعي بتجربة مميزة',
    description:
        'احصلي على خدمات تجميل احترافية وتصاميم أزياء فريدة من نخبة الخبراء.',
  ),
];
