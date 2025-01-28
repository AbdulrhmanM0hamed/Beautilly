import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/features/profile/domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    
    final result = await repository.getProfile();
    
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
} 