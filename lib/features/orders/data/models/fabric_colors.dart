import 'package:flutter/material.dart';

class FabricColors {
  static Map<String, Color> colors = {
    // الألوان الأساسية
    'أحمر': Colors.red,
    'أحمر داكن': const Color(0xFF8B0000),
    'أحمر خمري': const Color(0xFF800000),
    'أحمر وردي': const Color(0xFFFF69B4),

    // تدرجات الوردي
    'وردي': Colors.pink,
    'وردي فاتح': Colors.pinkAccent,
    'وردي باستيل': const Color(0xFFFFB6C1),
    'وردي سلموني': const Color(0xFFFF91A4),
    'وردي فوشيا': const Color(0xFFFF1493),

    // تدرجات البنفسجي
    'بنفسجي': Colors.purple,
    'بنفسجي فاتح': Colors.purpleAccent,
    'بنفسجي داكن': const Color(0xFF4B0082),
    'ليلكي': const Color(0xFFC8A2C8),
    'أرجواني': const Color(0xFF800080),

    // تدرجات الأزرق
    'أزرق': Colors.blue,
    'أزرق سماوي': Colors.lightBlue,
    'أزرق داكن': Colors.indigo,
    'أزرق ملكي': const Color(0xFF4169E1),
    'أزرق نيلي': const Color(0xFF000080),
    'تركواز': Colors.cyan,
    'فيروزي': const Color(0xFF40E0D0),

    // تدرجات الأخضر
    'أخضر': Colors.green,
    'أخضر فاتح': Colors.lightGreen,
    'أخضر زيتوني': const Color(0xFF808000),
    'أخضر زمردي': const Color(0xFF50C878),
    'أخضر عشبي': const Color(0xFF228B22),
    'أخضر نعناعي': const Color(0xFF98FF98),

    // تدرجات الأصفر
    'أصفر': Colors.yellow,
    'أصفر ذهبي': const Color(0xFFFFD700),
    'أصفر ليموني': Colors.lime,
    'خردلي': const Color(0xFFFFDB58),
    'كناري': const Color(0xFFFFEF00),

    // تدرجات البرتقالي
    'برتقالي': Colors.orange,
    'برتقالي داكن': Colors.deepOrange,
    'برتقالي باستيل': const Color(0xFFFFB347),
    'مشمشي': const Color(0xFFFFAB76),
    'كورال': const Color(0xFFFF7F50),

    // تدرجات البني
    'بني': Colors.brown,
    'بني فاتح': const Color(0xFFA0522D),
    'بني داكن': const Color(0xFF5C4033),
    'بيج': const Color(0xFFF5F5DC),
    'كريمي': const Color(0xFFFFE4C4),
    'كاكاو': const Color(0xFFD2691E),

    // تدرجات الرمادي
    'رمادي': Colors.grey,
    'رمادي فاتح': Colors.grey[300]!,
    'رمادي داكن': Colors.grey[700]!,
    'فضي': const Color(0xFFC0C0C0),
    'رصاصي': const Color(0xFF778899),

    // المعادن والألوان الخاصة
    'ذهبي': const Color(0xFFDAA520),
    'نحاسي': const Color(0xFFB87333),
    'برونزي': const Color(0xFFCD7F32),
    'بلاتيني': const Color(0xFFE5E4E2),

    // الألوان الأساسية
    'أسود': Colors.black,
    'أبيض': Colors.white,
    'أبيض عاجي': const Color(0xFFFFFFF0),
    'أوف وايت': const Color(0xFFFAF9F6),

    // ألوان خاصة بالأقمشة
    'كحلي': const Color(0xFF000080),
    'موف': const Color(0xFFE0B0FF),
    'خوخي': const Color(0xFFFFE5B4),
    'باذنجاني': const Color(0xFF4B0082),
    'توتي': const Color(0xFF8B008B),
    'تفاحي': const Color(0xFF4FA83D),
  };

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
