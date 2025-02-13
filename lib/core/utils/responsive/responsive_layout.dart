import 'package:flutter/material.dart';
import 'app_responsive.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppResponsive.tabletBreakpoint) {
          return desktop ?? mobile;
        }
        
        if (constraints.maxWidth >= AppResponsive.mobileBreakpoint) {
          return tablet ?? mobile;
        }
        
        return mobile;
      },
    );
  }
} 