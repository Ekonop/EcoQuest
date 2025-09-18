class LeaderboardEntry {
  final String userId;
  final String userName;
  final int points;
  final int rank;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.points,
    required this.rank,
  });

  factory LeaderboardEntry.mock(int rank) {
    return LeaderboardEntry(
      userId: 'u$rank',
      userName: 'User $rank',
      points: 10000 - rank * 500,
      rank: rank,
    );
  }
}
