import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_salon_profile.dart';
import 'salon_profile_state.dart';

class SalonProfileCubit extends Cubit<SalonProfileState> {
  final GetSalonProfileUseCase getSalonProfileUseCase;

  SalonProfileCubit({required this.getSalonProfileUseCase}) 
      : super(SalonProfileInitial());

  Future<void> getSalonProfile(int salonId) async {
    emit(SalonProfileLoading());
    
    final result = await getSalonProfileUseCase(salonId);
    
    result.fold(
      (failure) => emit(SalonProfileError(failure.message)),
      (profile) => emit(SalonProfileLoaded(profile)),
    );
  }
} 