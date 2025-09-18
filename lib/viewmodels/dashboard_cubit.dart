import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/models/user.dart';
import 'package:eco_quest/models/challenge.dart';
import 'package:eco_quest/repositories/user_repository.dart';
import 'package:eco_quest/repositories/challenge_repository.dart';

// States for Dashboard
abstract class DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final User user;
  final List<Challenge> ongoingChallenges;
  DashboardLoaded({required this.user, required this.ongoingChallenges});
}
class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

// Cubit for Dashboard
class DashboardCubit extends Cubit<DashboardState> {
  final UserRepository userRepository;
  final ChallengeRepository challengeRepository;

  DashboardCubit({required this.userRepository, required this.challengeRepository})
      : super(DashboardLoading());

  Future<void> loadDashboard() async {
    try {
      final user = await userRepository.getCurrentUser();
      final challenges = await challengeRepository.getOngoingChallenges();
      emit(DashboardLoaded(user: user, ongoingChallenges: challenges));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}