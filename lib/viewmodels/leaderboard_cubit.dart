import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/models/leaderboard_entry.dart';
import 'package:eco_quest/repositories/leaderboard_repository.dart';

abstract class LeaderboardState {}
class LeaderboardLoading extends LeaderboardState {}
class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardEntry> entries;
  LeaderboardLoaded(this.entries);
}
class LeaderboardError extends LeaderboardState {
  final String message;
  LeaderboardError(this.message);
}

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final LeaderboardRepository repository;
  LeaderboardCubit(this.repository) : super(LeaderboardLoading());

  Future<void> loadLeaderboard({String scope = 'overall'}) async {
    try {
      final entries = await repository.getLeaderboard(scope: scope);
      emit(LeaderboardLoaded(entries));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }
}