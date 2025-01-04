import 'package:flutter/material.dart';

class HavaAnAccount extends StatelessWidget {
  const HavaAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
