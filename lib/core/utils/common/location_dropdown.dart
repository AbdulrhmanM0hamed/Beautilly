import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/auth/data/models/city_model.dart';
import 'package:beautilly/features/auth/data/models/state_model.dart';
import 'package:beautilly/features/auth/presentation/cubit/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_dropdown.dart';

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({super.key});

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().loadStates();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CustomProgressIndcator(
            color: AppColors.primary,
          ));
        }

        if (state.error != null) {
          return Text(state.error!, style: const TextStyle(color: Colors.red));
        }

        return Row(
          children: [
            // قائمة المناطق
            Expanded(
              child: CustomDropdown<StateModell>(
                label: 'المنطقة',
                value: state.selectedState,
                items: state.states,
                itemToString: (state) => state.name,
                onChanged: (value) {
                  if (value != null) {
                    context.read<LocationCubit>().selectState(value);
                    context.read<LocationCubit>().loadCities(value.id);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار المنطقة';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            // قائمة المدن
            Expanded(
              child: CustomDropdown<CityModell>(
                label: 'المدينة',
                value: null,
                items: state.cities,
                itemToString: (city) => city.name,
                onChanged: state.selectedState == null
                    ? null
                    : (value) {
                        if (value != null) {
                          context.read<LocationCubit>().selectCity(value);
                        }
                      },
                isEnabled: state.selectedState != null,
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار المدينة';
                  }
                  return null;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
