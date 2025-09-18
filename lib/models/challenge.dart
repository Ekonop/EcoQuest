class Challenge {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int progress; // e.g., trees planted

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.progress,
  });

  factory Challenge.mock() {
    return Challenge(
      id: 'c1',
      title: 'Forest Restoration Initiative',
      description: 'Plant 100 trees in local park',
      dueDate: DateTime.now().add(Duration(days: 7)),
      progress: 35,
    );
  }
}
