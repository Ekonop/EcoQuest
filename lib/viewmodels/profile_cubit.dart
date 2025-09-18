import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/models/user.dart';
import 'package:eco_quest/repositories/user_repository.dart';

abstract class ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded(this.user);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository repository;
  ProfileCubit(this.repository) : super(ProfileLoading());

  Future<void> loadProfile() async {
    try {
      final user = await repository.getCurrentUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}