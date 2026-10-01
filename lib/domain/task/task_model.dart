class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.isFavorite = false,
    required this.category,
    required this.dueDate,
  });

  final int id;
  final String title;
  final String description;
  final bool isDone;
  final bool isFavorite;
  final String category;
  final DateTime dueDate;

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
    bool? isFavorite,
    String? category,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
