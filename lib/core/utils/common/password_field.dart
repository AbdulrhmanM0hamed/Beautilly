import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved,
    required this.hintText,
    this.validator,
    this.controller,
  });
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String hintText;
  final TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      obscureText: _obscureText,
      prefix: const Icon(
        Icons.lock,
      ),
      label: widget.hintText,
      suffix: GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText ? Icons.remove_red_eye : Icons.visibility_off,
        ),
      ),
      validator: widget.validator,
    );
  }
}


// Authentication endpoints
// Route::post('/register', [RegisteredUserController::class, 'register'])
//     ->name('register');

// Route::post('/login', [AuthenticatedSessionController::class, 'store'])
//     ->name('login');

// Route::get('/statistics', [StatisticsController::class, 'stats'])->name('api.statistics');

// Route::get('/home-page-best-shops', [HomePageBestShops::class, '


// Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
//     ->middleware('auth')
//     ->name('logout')


//   "message": "لقد قمت بتسجيل الدخول بالفعل.",

    // "user": {
    //     "id": 1,
    //     "avatar_url": "01JHP7P8PWM1TPM5350FZBRKYR.jpg",
    //     "name": "super admin",
    //     "address": null,
    //     "phone": null,
    //     "email": "super@gmail.com",
    //     "email_verified_at": null,
    //     "created_at": "2025-01-15T21:41:54.000000Z",
    //     "updated_at": "2025-01-16T00:19:56.000000Z",
    //     "is_active": 1,
    //     "state_id": null,
    //     "city_id": null
    // }


    //     "success": true,
    // "data": {
    //     "happyClients": 24,
    //     "services": 63,
    //     "fashionHouses": 10,
    //     "beautySalons": 0

    // }
