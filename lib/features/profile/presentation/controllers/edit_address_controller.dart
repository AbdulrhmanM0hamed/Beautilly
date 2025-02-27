import 'package:beautilly/features/auth/data/models/city_model.dart';
import 'package:beautilly/features/auth/data/models/state_model.dart';
import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/auth/domain/repositories/location_repository.dart';

class EditAddressController extends ChangeNotifier {
  final ProfileModel profile;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LocationRepository locationRepository = sl<LocationRepository>();

  StateModell? selectedState;
  CityModell? selectedCity;
  List<StateModell> states = [];
  List<CityModell> cities = [];
  bool isLoading = false;

  EditAddressController(this.profile) {
    _initAddress();
    _loadStates();
  }

  void _initAddress() {
    selectedState = StateModell(
      id: profile.state?.id ?? 0,
      name: profile.state?.name ?? '',
    );

    selectedCity = CityModell(
      id: profile.city?.id ?? 0,
      name: profile.city?.name ?? '',
      stateId: profile.state?.id ?? 0,
    );
  }

  Future<void> _loadStates() async {
    final result = await locationRepository.getStates();
    result.fold(
      (failure) => (failure.message),
      (statesList) {
        states = statesList;
        if (selectedState != null) {
          selectedState = states.firstWhere(
            (state) => state.id == selectedState!.id,
            orElse: () => selectedState!,
          );
          _loadCities(selectedState!.id);
        }
        notifyListeners();
      },
    );
  }

  Future<void> _loadCities(int stateId) async {
    final result = await locationRepository.getCities(stateId);
    result.fold(
      (failure) => debugPrint(failure.message),
      (citiesList) {
        cities = citiesList;
        if (selectedCity != null) {
          selectedCity = cities.firstWhere(
            (city) => city.id == selectedCity!.id,
            orElse: () => selectedCity!,
          );
        }
        notifyListeners();
      },
    );
  }

  void onStateChanged(StateModell? newState) async {
    selectedState = newState;
    selectedCity = null;
    notifyListeners();
    if (newState != null) {
      await _loadCities(newState.id);
    } else {
      cities = [];
      notifyListeners();
    }
  }

  Future<void> updateAddress(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCity == null || selectedState == null) {
      CustomSnackbar.showError(
        context: context,
        message: 'يرجى اختيار المدينة والمنطقة',
      );
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await sl<ProfileCubit>().updateAddress(
        cityId: selectedCity!.id,
        stateId: selectedState!.id,
      );

      isLoading = false;
      notifyListeners();

      if (context.mounted) {
        CustomSnackbar.showSuccess(
          context: context,
          message: 'تم تحديث العنوان بنجاح',
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (context.mounted) {
        CustomSnackbar.showError(
          context: context,
          message: e.toString(),
        );
      }
    }
  }

  void onCityChanged(CityModell? newCity) {
    selectedCity = newCity;
    notifyListeners();
  }
}
