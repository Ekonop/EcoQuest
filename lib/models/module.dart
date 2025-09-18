class Module {
  final String id;
  final String title;
  final String description;
  final int pointsEarned;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsEarned,
  });

  factory Module.mock(String id, String title) {
    return Module(
      id: id,
      title: title,
      description: 'Learn about $title',
      pointsEarned: 20,
    );
  }
}
