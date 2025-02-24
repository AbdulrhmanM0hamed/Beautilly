import 'package:flutter/material.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
          ),
          SizedBox(height: 8),
          Text(
            'ستظهر هنا جميع إشعاراتك',
          ),
        ],
      ),
    );
  }
}
