import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:flutter/material.dart';
import 'app_responsive.dart';

class ResponsiveCardSizes {
  static CardDimensions getCardDimensions(
      BuildContext context, BoxConstraints constraints) {
    final availableWidth = constraints.maxWidth;
    final spacing = availableWidth * 0.02;
    final cardWidth = (availableWidth - (spacing * 3)) / 4;
    final cardHeight = cardWidth * 0.9;

    return CardDimensions(
      width: cardWidth,
      height: cardHeight,
      spacing: spacing,
    );
  }

  static CardInternalSizes getInternalSizes(BoxConstraints constraints) {
    final cardWidth = constraints.maxWidth;
    final cardHeight = constraints.maxHeight;

    return CardInternalSizes(
      verticalPadding: cardHeight * 0.1,
      horizontalPadding: cardWidth * 0.1,
      iconSize: cardWidth * 0.22,
      progressSize: cardWidth * 0.15,
      titleSize: cardWidth * 0.12,
      valueSize: cardWidth * 0.15,
      progressStrokeWidth: cardWidth * 0.15 * 0.12,
    );
  }

  static BorderRadius defaultBorderRadius = BorderRadius.circular(16);

  static EdgeInsets getPadding(CardInternalSizes sizes) {
    return EdgeInsets.symmetric(
      vertical: sizes.verticalPadding,
      horizontal: sizes.horizontalPadding,
    );
  }

  static OfferCardDimensions getOfferCardDimensions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= AppResponsive.mobileBreakpoint;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

    if (isDesktop) {
      // نسب خاصة للشاشات الكبيرة
      return OfferCardDimensions(
        width: size.width * 0.45, // عرض أصغر
        height: size.height * 0.3, // ارتفاع أصغر
        cutoutSize: size.width * 0.03, // دوائر جانبية أصغر
        horizontalPadding: size.width * 0.02,
        verticalPadding: size.height * 0.01,
        titleSize: size.width * 0.025, // خط أصغر للعنوان
        descriptionSize: size.width * 0.019, // خط أصغر للوصف
        borderRadius: BorderRadius.circular(20),
        discountCircleSize: size.width * 0.08, // دائرة خصم أصغر
        buttonHeight: size.height * 0.03,
        buttonTextSize: size.width * 0.015,
      );
    } else if (isTablet) {
      // نسب التابلت الحالية
      return OfferCardDimensions(
        width: size.width * 0.65,
        height: size.height * 0.2,
        cutoutSize: size.width * 0.05,
        horizontalPadding: size.width * 0.04,
        verticalPadding: size.height * 0.015,
        titleSize: size.width * 0.03,
        descriptionSize: size.width * 0.028,
        borderRadius: BorderRadius.circular(16),
        discountCircleSize: size.width * 0.12,
        buttonHeight: size.height * 0.035,
        buttonTextSize: size.width * 0.02,
      );
    } else {
      // نسب الموبايل الحالية
      return OfferCardDimensions(
        width: size.width * 0.85,
        height: size.height * 0.15,
        cutoutSize: size.width * 0.075,
        horizontalPadding: size.width * 0.06,
        verticalPadding: size.height * 0.019,
        titleSize: size.width * 0.045,
        descriptionSize: size.width * 0.035,
        borderRadius: BorderRadius.circular(12),
        discountCircleSize: size.width * 0.2,
        buttonHeight: size.height * 0.04,
        buttonTextSize: size.width * 0.035,
      );
    }
  }

  static ServiceGridDimensions getServiceGridDimensions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= AppResponsive.mobileBreakpoint;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

    if (isDesktop) {
      return ServiceGridDimensions(
        crossAxisCount: 4,
        childAspectRatio: 1.25,
        padding: size.width * 0.02,
        spacing: size.width * 0.015,
        iconSize: size.width * 0.025,
        titleSize: size.width * 0.015,
        borderRadius: 16,
      );
    } else if (isTablet) {
      return ServiceGridDimensions(
        crossAxisCount: 3,
        childAspectRatio: 1.25,
        padding: size.width * 0.03,
        spacing: size.width * 0.02,
        iconSize: size.width * 0.05,
        titleSize: size.width * 0.020,
        borderRadius: 14,
      );
    } else {
      return ServiceGridDimensions(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        padding: size.width * 0.04,
        spacing: size.width * 0.03,
        iconSize: size.width * 0.06,
        titleSize: size.width * 0.035,
        borderRadius: 12,
      );
    }
  }

  static BeautyServiceCardDimensions getBeautyServiceCardDimensions(
      BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Large Tablet (1280x1880)
    if (size.width >= 1280) {
      return const BeautyServiceCardDimensions(
        width: 350, // تقليل العرض قليلاً
        height: 320, // تقليل الارتفاع
        imageHeight: 180, // تقليل ارتفاع الصورة
        padding: 16,
        titleSize: 24, // تصغير حجم العنوان
        ratingSize: 22,
        locationSize: 20,
        tagSize: 16,
        iconSize: 23,
      );
    }
    // Medium Tablet (1024x1350)
    else if (size.width >= 1024) {
      return const BeautyServiceCardDimensions(
        width: 300,
        height: 300,
        imageHeight: 180,
        padding: 14,
        titleSize: 20,
        ratingSize: 18,
        locationSize: 17,
        tagSize: 15,
        iconSize: 22,
      );
    }
    // Small Tablet (800x1280)
    else if (size.width >= 800) {
      return const BeautyServiceCardDimensions(
        width: 280,
        height: 300,
        imageHeight: 160,
        padding: 15,
        titleSize: 18,
        ratingSize: 16,
        locationSize: 16,
        tagSize: 15,
        iconSize: 22,
      );
    }
    // Mobile
    else {
      return const BeautyServiceCardDimensions(
        width: 220,
        height: 240,
        imageHeight: 140,
        padding: 12,
        titleSize: FontSize.size14,
        ratingSize: FontSize.size12,
        locationSize: FontSize.size12,
        tagSize: FontSize.size10,
        iconSize: 16,
      );
    }
  }

  // Reservation Card Sizes
  // static const double reservationDesktopCardWidth = 320.0;
  // static const double reservationDesktopCardHeight = 380.0;
  // static const double reservationDesktopImageHeight = 200.0;

  // static const double reservationTabletCardWidth = 280.0;
  // static const double reservationTabletCardHeight = 340.0;
  // static const double reservationTabletImageHeight = 180.0;

  // static const double reservationLargeMobileCardWidth = 240.0;
  // static const double reservationLargeMobileCardHeight = 320.0;
  // static const double reservationLargeMobileImageHeight = 160.0;

  // static const double reservationMobileCardWidth = 200.0;
  // static const double reservationMobileCardHeight = 300.0;
  // static const double reservationMobileImageHeight = 140.0;

  static ReservationCardDimensions getReservationCardDimensions(
      BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Large Tablet (1280x1880)
    if (size.width >= 1280) {
      return const ReservationCardDimensions(
        width: 300,
        height: 320, // تقليل من 340
        imageHeight: 180,
        padding: 16,
        spacing: 16,
        titleSize: FontSize.size20,
        subtitleSize: FontSize.size18,
        iconSize: 24,
        borderRadius: 16,
        statusBadgeHeight: 32,
      );
    }
    // Medium Tablet (1024x1350)
    else if (size.width >= 1024) {
      return const ReservationCardDimensions(
        width: 280,
        height: 260, // تقليل من 280
        imageHeight: 220,
        padding: 14,
        spacing: 14,
        titleSize: FontSize.size18,
        subtitleSize: FontSize.size16,
        iconSize: 22,
        borderRadius: 14,
        statusBadgeHeight: 28,
      );
    }
    // Small Tablet (800x1280)
    else if (size.width >= 800) {
      return const ReservationCardDimensions(
        width: 260,
        height: 220, // تقليل من 260
        imageHeight: 220,
        padding: 12,
        spacing: 12,
        titleSize: FontSize.size14,
        subtitleSize: FontSize.size12,
        iconSize: 20,
        borderRadius: 12,
        statusBadgeHeight: 24,
      );
    }
    // Mobile
    else {
      return ReservationCardDimensions(
        width: size.width * 0.45,
        height: 300, // زيادة الارتفاع
        imageHeight: 120, // زيادة ارتفاع الصورة
        padding: 6,
        spacing: 2,
        titleSize: FontSize.size10,
        subtitleSize: FontSize.size9,
        iconSize: 14,
        borderRadius: 8,
        statusBadgeHeight: 20,
      );
    }
  }

  static OrderCardDimensions getOrderCardDimensions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= AppResponsive.mobileBreakpoint;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

    if (isDesktop) {
      return OrderCardDimensions(
        width: size.width * 0.28,
        height: size.height * 0.50, // زيادة الارتفاع
        imageHeight: size.height * 0.22,
        padding: 12,
        spacing: 8,
        titleSize: 14,
        subtitleSize: 12,
        iconSize: 16,
        borderRadius: 12,
        chipHeight: 26, // تصغير ارتفاع الـ chips
        avatarSize: 32,
      );
    } else if (isTablet) {
      return OrderCardDimensions(
        width: size.width * 0.4,
        height: size.height * 0.45, // زيادة الارتفاع
        imageHeight: size.height * 0.20,
        padding: 10,
        spacing: 8,
        titleSize: 13,
        subtitleSize: 11,
        iconSize: 14,
        borderRadius: 12,
        chipHeight: 24, // تصغير ارتفاع الـ chips
        avatarSize: 28,
      );
    } else {
      return OrderCardDimensions(
        width: size.width * 0.45, // تقليل العرض
        height: size.height * 0.40, // زيادة الارتفاع
        imageHeight: size.height * 0.18,
        padding: 8,
        spacing: 6,
        titleSize: 12,
        subtitleSize: 10,
        iconSize: 12,
        borderRadius: 10,
        chipHeight: 22, // تصغير ارتفاع الـ chips
        avatarSize: 24,
      );
    }
  }
}

class CardDimensions {
  final double width;
  final double height;
  final double spacing;

  const CardDimensions({
    required this.width,
    required this.height,
    required this.spacing,
  });
}

class CardInternalSizes {
  final double verticalPadding;
  final double horizontalPadding;
  final double iconSize;
  final double progressSize;
  final double titleSize;
  final double valueSize;
  final double progressStrokeWidth;

  const CardInternalSizes({
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.iconSize,
    required this.progressSize,
    required this.titleSize,
    required this.valueSize,
    required this.progressStrokeWidth,
  });
}

class OfferCardDimensions {
  final double width;
  final double height;
  final double cutoutSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double titleSize;
  final double descriptionSize;
  final BorderRadius borderRadius;
  final double discountCircleSize;
  final double buttonHeight;
  final double buttonTextSize;

  const OfferCardDimensions({
    required this.width,
    required this.height,
    required this.cutoutSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.titleSize,
    required this.descriptionSize,
    required this.borderRadius,
    required this.discountCircleSize,
    required this.buttonHeight,
    required this.buttonTextSize,
  });
}

class ServiceGridDimensions {
  final int crossAxisCount;
  final double childAspectRatio;
  final double padding;
  final double spacing;
  final double iconSize;
  final double titleSize;
  final double borderRadius;

  const ServiceGridDimensions({
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.padding,
    required this.spacing,
    required this.iconSize,
    required this.titleSize,
    required this.borderRadius,
  });
}

class BeautyServiceCardDimensions {
  final double width;
  final double height;
  final double imageHeight;
  final double padding;
  final double titleSize;
  final double ratingSize;
  final double locationSize;
  final double tagSize;
  final double iconSize;

  const BeautyServiceCardDimensions({
    required this.width,
    required this.height,
    required this.imageHeight,
    required this.padding,
    required this.titleSize,
    required this.ratingSize,
    required this.locationSize,
    required this.tagSize,
    required this.iconSize,
  });
}

class ReservationCardDimensions {
  final double width;
  final double height;
  final double imageHeight;
  final double padding;
  final double spacing;
  final double titleSize;
  final double subtitleSize;
  final double iconSize;
  final double borderRadius;
  final double statusBadgeHeight;

  const ReservationCardDimensions({
    required this.width,
    required this.height,
    required this.imageHeight,
    required this.padding,
    required this.spacing,
    required this.titleSize,
    required this.subtitleSize,
    required this.iconSize,
    required this.borderRadius,
    required this.statusBadgeHeight,
  });
}

class OrderCardDimensions {
  final double width;
  final double height;
  final double imageHeight;
  final double padding;
  final double spacing;
  final double titleSize;
  final double subtitleSize;
  final double iconSize;
  final double borderRadius;
  final double chipHeight;
  final double avatarSize;

  const OrderCardDimensions({
    required this.width,
    required this.height,
    required this.imageHeight,
    required this.padding,
    required this.spacing,
    required this.titleSize,
    required this.subtitleSize,
    required this.iconSize,
    required this.borderRadius,
    required this.chipHeight,
    required this.avatarSize,
  });
}
