import 'package:flutter/material.dart';

class AppResponsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  static const double desktopBreakpoint = 1200;
  static const double tabletBreakpoint = 800;
  static const double mobileBreakpoint = 600;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    
    // defaultSize = orientation == Orientation.landscape 
    //     ? screenHeight * 0.024
    //     : screenWidth * 0.024;
  }

  static double getScreenProportion(double value) {
    return (screenWidth / 375.0) * value; // 375 is standard width
  }

  // Breakpoints
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;
      
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;
      
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;
} 