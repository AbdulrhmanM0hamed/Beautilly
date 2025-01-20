import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/state_model.dart';
import '../../data/models/city_model.dart';
import '../../domain/repositories/location_repository.dart';

class LocationState {
  final bool isLoading;
  final List<StateModel> states;
  final List<CityModel> cities;
  final StateModel? selectedState;
  final CityModel? selectedCity;
  final String? error;

  LocationState({
    this.isLoading = false,
    this.states = const [],
    this.cities = const [],
    this.selectedState,
    this.selectedCity,
    this.error,
  });

  LocationState copyWith({
    bool? isLoading,
    List<StateModel>? states,
    List<CityModel>? cities,
    StateModel? selectedState,
    CityModel? selectedCity,
    String? error,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      states: states ?? this.states,
      cities: cities ?? this.cities,
      selectedState: selectedState ?? this.selectedState,
      selectedCity: selectedCity ?? this.selectedCity,
      error: error ?? this.error,
    );
  }
}

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _repository;

  LocationCubit(this._repository) : super(LocationState());

  Future<void> loadStates() async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _repository.getStates();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (states) => emit(state.copyWith(
        isLoading: false,
        states: states,
      )),
    );
  }

  Future<void> loadCities(int stateId) async {
    emit(state.copyWith(
      selectedCity: null,
      cities: [],
    ));
    
    emit(state.copyWith(isLoading: true));
    
    final result = await _repository.getCities(stateId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (cities) => emit(state.copyWith(
        isLoading: false,
        cities: cities,
      )),
    );
  }

  void selectState(StateModel state) {
    emit(this.state.copyWith(
      selectedState: state,
      selectedCity: null,
      cities: [],
    ));
  }

  void selectCity(CityModel city) {
    emit(state.copyWith(selectedCity: city));
  }
} 