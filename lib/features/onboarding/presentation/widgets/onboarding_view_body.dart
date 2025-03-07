import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/onboarding/data/models/onboarding_model.dart';
import 'page_view_item.dart';
import 'custom_smooth_page_indicator.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _finishOnboarding() async {
    // حفظ أن المستخدم قد رأى الـ onboarding
    await sl<CacheService>().setIsFirstTime(false);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, SigninView.routeName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PageView for background images
        Directionality(
          textDirection: TextDirection.ltr,
          child: PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return PageViewItem(
                model: onboardingData[index],
              );
            },
          ),
        ),
        // Bottom controls
        Positioned(
          left: 24,
          right: 24,
          bottom: 32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSmoothPageIndicator(
                controller: _pageController,
                count: onboardingData.length,
                currentPage: _currentPage,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _currentPage == onboardingData.length - 1
                    ? 'ابدأ الآن'
                    : 'التالي',
                onPressed: () {
                  if (_currentPage < onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    _finishOnboarding();
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'هل لديك حساب؟',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // حفظ أن المستخدم قد رأى الـ onboarding عند الضغط على "سجل الآن"
                      await sl<CacheService>().setIsFirstTime(false);

                      if (!mounted) return;
                      Navigator.pushReplacementNamed(
                        context,
                        SigninView.routeName,
                      );
                    },
                    child: Text(
                      'سجل الآن',
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
