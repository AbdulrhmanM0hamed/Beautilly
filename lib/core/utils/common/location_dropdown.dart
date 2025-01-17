import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({super.key});

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  String? selectedRegion;
  String? selectedCity;

  final Map<String, List<String>> saudiCities = {
    'الرياض': ['الدرعية', 'وادي الدواسر', 'حي السفارات', 'الملز', 'الخرج'],
    'مكة': ['جدة', 'الطائف', 'رابغ', 'الكعكية', 'الشرائع'],
    'المدينة المنورة': ['العقيق', 'قباء', 'حي العزيزية', 'الحرم', 'بدر'],
    'المنطقة الشرقية': ['الدمام', 'الخبر', 'الظهران', 'الجبيل', 'القطيف'],
    'عسير': ['أبها', 'خميس مشيط', 'النماص', 'محايل عسير', 'ظهران الجنوب'],
    'القصيم': ['بريدة', 'عنيزة', 'الرس', 'البدائع', 'المذنب'],
    'حائل': ['حائل', 'بقعاء', 'الغزالة', 'الشويمس', 'الشملي'],
    'تبوك': ['تبوك', 'الوجه', 'ضباء', 'حقل', 'أملج'],
    'جازان': ['جيزان', 'صامطة', 'أبو عريش', 'صبيا', 'الدرب'],
    'الباحة': ['الباحة', 'المندق', 'بلجرشي', 'العقيق', 'قلوة'],
    'نجران': ['نجران', 'شرورة', 'حبونا', 'ثار', 'يدمة'],
    'الجوف': ['سكاكا', 'القريات', 'دومة الجندل', 'طبرجل'],
    'الحدود الشمالية': ['عرعر', 'رفحاء', 'طريف', 'العويقيلة'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // المنطقة
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon:
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
              isExpanded: true,
              value: selectedRegion,
              itemHeight: 60,
              hint: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'اختر المنطقة',
                    style: getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              items: saudiCities.keys.map((String region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.grey),
                      const SizedBox(width: 8),
                      Text(
                        region,
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRegion = newValue;
                  selectedCity = null; // إعادة تعيين المدينة المختارة
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // المدينة
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon:
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
              isExpanded: true,
              value: selectedCity,
              itemHeight: 60,
              hint: Row(
                children: [
                  const Icon(Icons.location_city_outlined,
                      color: AppColors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'اختر المدينة',
                    style: getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              items: selectedRegion == null
                  ? []
                  : saudiCities[selectedRegion]!.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Row(
                          children: [
                            const Icon(Icons.location_city_outlined,
                                color: AppColors.grey),
                            const SizedBox(width: 8),
                            Text(
                              city,
                              style: getMediumStyle(
                                fontSize: FontSize.size14,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
