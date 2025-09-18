class User {
  final String id;
  final String name;
  final String role;
  final int points;
  final int challengesCompleted;
  final List<String> badges;
  final double carbonReduction; // percentage
  final double wasteRecycled; // percentage

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.points,
    required this.challengesCompleted,
    required this.badges,
    required this.carbonReduction,
    required this.wasteRecycled,
  });

  factory User.mock() {
    return User(
      id: 'u1',
      name: 'Jane Doe',
      role: 'EcoWarrior',
      points: 7500,
      challengesCompleted: 12,
      badges: ['Forest Guardian', 'Recycling Champ'],
      carbonReduction: 23.5,
      wasteRecycled: 45.0,
    );
  }
}
