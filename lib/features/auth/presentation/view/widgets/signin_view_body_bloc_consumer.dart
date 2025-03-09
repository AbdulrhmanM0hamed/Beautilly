import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/auth/presentation/view/forget_password.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/common/password_field.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_state.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/dont_have_account.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class SigninViewBodyBlocConsumer extends StatefulWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  State<SigninViewBodyBlocConsumer> createState() =>
      _SigninViewBodyBlocConsumerState();
}

class _SigninViewBodyBlocConsumerState
    extends State<SigninViewBodyBlocConsumer> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final cacheService = sl<CacheService>();
    _rememberMe = await cacheService.getRememberMe();

    if (_rememberMe) {
      final credentials = await cacheService.getLoginCredentials();
      if (credentials != null) {
        setState(() {
          _emailController.text = credentials['email']!;
          _passwordController.text = credentials['password']!;
        });
      }
    }
  }

  Future<void> _launchProviderSignup() async {
    final Uri url = Uri.parse('https://dallik.com/app/signup?type=provider');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        CustomSnackbar.showError(
          context: context,
          message: 'لا يمكن فتح الرابط',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            try {
              if (_rememberMe) {
                await sl<CacheService>().setRememberMe(true);
                await sl<CacheService>().saveLoginCredentials(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
              } else {
                await sl<CacheService>().clearLoginCredentials();
              }

              // إعادة تهيئة ProfileCubit وتحميل البيانات الجديدة
              sl.unregister<ProfileCubit>();
              sl.registerFactory<ProfileCubit>(
                  () => ProfileCubit(cacheService: sl<CacheService>(), repository: sl()));

              final profileCubit = sl<ProfileCubit>();
              if (!profileCubit.isClosed) {
                await profileCubit.loadProfile();
              }

              if (!context.mounted) return;

              Navigator.pushReplacementNamed(context, HomeView.routeName);

              CustomSnackbar.showSuccess(
                context: context,
                message: state.message,
              );
            } catch (e) {
              if (!context.mounted) return;
              CustomSnackbar.showError(
                context: context,
                message: 'حدث خطأ أثناء تحميل البيانات',
              );
            }
          } else if (state is AuthError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        CustomTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني أو رقم الهاتف',
                          suffix: const Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            }
                            // التحقق من صحة المدخل (إما بريد إلكتروني أو رقم هاتف)
                            bool isEmail = value.contains('@');
                            bool isPhone =
                                RegExp(r'^[0-9]{10,}$').hasMatch(value);

                            if (!isEmail && !isPhone) {
                              return 'يرجى إدخال بريد إلكتروني أو رقم هاتف صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        PasswordField(
                          validator: FormValidators.validatePasswordLogin,
                          controller: _passwordController,
                          hintText: AppStrings.password,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // تذكرني
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  'تذكرني',
                                  style: getMediumStyle(
                                    fontSize: FontSize.size14,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                              ],
                            ),
                            // نسيت كلمة المرور
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ForgotPasswordView.routeName);
                              },
                              child: Text(
                                AppStrings.forgotPassword,
                                style: getMediumStyle(
                                  color: AppColors.primary,
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                },
                          text: state is AuthLoading
                              ? 'جاري التحميل...'
                              : AppStrings.login,
                        ),
                        const SizedBox(height: 24),
                        const DontHaveAccount(),
                        const SizedBox(height: 24),
                        // إضافة زر دخول كزائر
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: state is AuthLoading
                                  ? null
                                  : () {
                                      context.read<AuthCubit>().login(
                                            'guest@gmail.com',
                                            '123456789',
                                          );
                                    },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'دخول كزائر',
                                      style: getMediumStyle(
                                        color: AppColors.primary,
                                        fontSize: FontSize.size14,
                                        fontFamily: FontConstant.cairo,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _launchProviderSignup,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.store_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'انضم كمقدم خدمة',
                                      style: getMediumStyle(
                                        color: AppColors.primary,
                                        fontSize: FontSize.size14,
                                        fontFamily: FontConstant.cairo,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.primary,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AuthLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CustomProgressIndcator(
                      size: 50.0,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
