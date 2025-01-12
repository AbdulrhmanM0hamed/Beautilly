import 'package:beautilly/features/nearby/presentation/view/widgets/discover_view_body.dart';
import 'package:flutter/material.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: DiscoverViewBody(),
    );
  }
}
