import 'package:eco_quest/models/leaderboard_entry.dart';

class LeaderboardRepository {
  Future<List<LeaderboardEntry>> getLeaderboard({String scope = 'overall'}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(10, (i) => LeaderboardEntry.mock(i + 1));
  }
}