import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class BookingDialog extends StatefulWidget {
  final int shopId;
  final int serviceId;
  final String serviceName;
  final String servicePrice;
  final String serviceDescription;
  final bool isDiscount;

  const BookingDialog({
    super.key,
    required this.shopId,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDescription,
    this.isDiscount = false,
  });

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  int? selectedDayId;
  int? selectedTimeId;

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().loadAvailableDates(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            Navigator.pop(context);
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
          } else if (state is BookingError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CustomProgressIndcator(
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            if (state is DatesLoaded) {
              final dates = state.dates;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.serviceName,
                                      style: getBoldStyle(
                                        fontSize: FontSize.size18,
                                        fontFamily: FontConstant.cairo,
                                      ),
                                    ),
                                   const Spacer(),
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.serviceDescription,
                                  style: getRegularStyle(
                                    fontSize: FontSize.size13,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                                Text(
                                  '${widget.servicePrice} ر.س',
                                  style: getBoldStyle(
                                    fontSize: FontSize.size16,
                                    fontFamily: FontConstant.cairo,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      // Days Section
                      Text(
                        'اختر اليوم',
                        style: getBoldStyle(
                          fontSize: FontSize.size16,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dates.length,
                          itemBuilder: (context, index) {
                            final date = dates[index];
                            final isSelected = date.dayId == selectedDayId;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedDayId = date.dayId;
                                    selectedTimeId = null;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 100,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[800]
                                            : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        date.dayName,
                                        style: getBoldStyle(
                                          fontSize: FontSize.size14,
                                          fontFamily: FontConstant.cairo,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[500],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        date.formattedDate,
                                        style: getRegularStyle(
                                          fontSize: FontSize.size12,
                                          fontFamily: FontConstant.cairo,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Times Section
                      if (selectedDayId != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'اختر الوقت',
                          style: getBoldStyle(
                            fontSize: FontSize.size16,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final timeSlots = dates
                                .firstWhere(
                                    (date) => date.dayId == selectedDayId)
                                .timeSlots
                                .where((slot) => slot.isAvailable)
                                .toList();

                            // تقسيم القائمة إلى عمودين
                            final itemsPerColumn =
                                (timeSlots.length / 2).ceil();
                            final leftColumnSlots =
                                timeSlots.take(itemsPerColumn).toList();
                            final rightColumnSlots =
                                timeSlots.skip(itemsPerColumn).toList();

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // العمود الأيمن
                                Expanded(
                                  child: Column(
                                    children: leftColumnSlots.map((slot) {
                                      final isSelected =
                                          slot.id == selectedTimeId;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedTimeId = slot.id;
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : Theme.of(context)
                                                      .brightness ==
                                                      Brightness.dark
                                                      ? Colors.grey[800]
                                                      : Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                slot.formattedTime,
                                                style: getMediumStyle(
                                                  fontSize: FontSize.size14,
                                                  fontFamily:
                                                      FontConstant.cairo,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.grey[500],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // العمود الأيسر
                                Expanded(
                                  child: Column(
                                    children: rightColumnSlots.map((slot) {
                                      final isSelected =
                                          slot.id == selectedTimeId;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedTimeId = slot.id;
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : Theme.of(context)
                                                      .brightness ==
                                                      Brightness.dark
                                                      ? Colors.grey[800]
                                                      : Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                slot.formattedTime,
                                                style: getMediumStyle(
                                                  fontSize: FontSize.size14,
                                                  fontFamily:
                                                      FontConstant.cairo,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.grey[500],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              selectedDayId != null && selectedTimeId != null
                                  ? () {
                                      if (widget.isDiscount) {
                                        context.read<BookingCubit>().bookDiscount(
                                              shopId: widget.shopId,
                                              discountId: widget.serviceId,
                                              dayId: selectedDayId!,
                                              timeId: selectedTimeId!,
                                            );
                                      } else {
                                        context.read<BookingCubit>().bookService(
                                              shopId: widget.shopId,
                                              serviceId: widget.serviceId,
                                              dayId: selectedDayId!,
                                              timeId: selectedTimeId!,
                                            );
                                      }
                                    }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: state is BookingLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'تأكيد الحجز',
                                  style: getBoldStyle(
                                    fontSize: FontSize.size16,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is BookingError) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
