
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime date;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.date,
    required this.completed,
  });


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueAt': dueDate.toIso8601String(),
      if (id.isNotEmpty) '_id': id, 
      'completed': completed,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueAt'] != null 
          ? DateTime.tryParse(json['dueAt']) ?? DateTime.now() 
          : DateTime.now(),
      date: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() 
          : DateTime.now(),
      completed: json['completed'] ?? false, 
    );
  }

 
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? date,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, dueDate: $dueDate, completed: $completed}';
  }
}
