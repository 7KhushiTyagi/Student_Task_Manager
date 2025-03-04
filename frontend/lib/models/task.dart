class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueAt; 
  final DateTime date; 
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueAt,
    required this.date,
    required this.isCompleted,
  });

  // Convert Task to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueAt': dueAt.toIso8601String(), 
      if (id.isNotEmpty) '_id': id, 
      'completed': isCompleted,
    };
  }

  // Create Task from JSON response
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? json['id'] ?? '', 
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueAt: json['dueAt'] != null 
          ? DateTime.tryParse(json['dueAt']) ?? DateTime.now()
          : DateTime.now(),
      date: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() 
          : DateTime.now(),
      isCompleted: json['completed'] ?? false,
    );
  }

  // Copy method for updates
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueAt,
    DateTime? date,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, dueAt: $dueAt, isCompleted: $isCompleted}';
  }
}
