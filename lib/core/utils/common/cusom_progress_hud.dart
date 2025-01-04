import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustomProgressHud extends StatelessWidget {
  const CustomProgressHud({super.key, required this.inLoading, required this.child});
   
   final bool inLoading;
   final Widget child;
   
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(inAsyncCall: inLoading, child: child);
  }
}