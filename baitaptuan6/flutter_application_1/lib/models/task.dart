class Subtask {
  final int id;
  final String title;
  final bool done;

  const Subtask({required this.id, required this.title, this.done = false});

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      done: (json['done'] ?? false) as bool,
    );
  }

  Subtask copyWith({int? id, String? title, bool? done}) => Subtask(
        id: id ?? this.id,
        title: title ?? this.title,
        done: done ?? this.done,
      );
}

class Task {
  final int id;
  final String title;
  final String description;
  final String status;
  final String time;
  final bool completed;
  final List<Subtask> subtasks;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.time,
    this.completed = false,
    this.subtasks = const <Subtask>[],
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final rawSubs = json['subtasks'];
    final subs = rawSubs is List
        ? rawSubs
            .whereType<Map<String, dynamic>>()
            .map(Subtask.fromJson)
            .toList()
        : <Subtask>[];

    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      time: json['time'] ?? '',
      completed: (json['completed'] ?? json['isCompleted'] ?? false) as bool,
      subtasks: subs,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? time,
    bool? completed,
    List<Subtask>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      time: time ?? this.time,
      completed: completed ?? this.completed,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}
