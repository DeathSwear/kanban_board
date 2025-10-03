import 'package:equatable/equatable.dart';
import 'task.dart';

class BoardColumnModel extends Equatable {
  final String id;
  final String title;
  final List<Task> tasks;

  const BoardColumnModel({
    required this.id,
    required this.title,
    required this.tasks,
  });

  BoardColumnModel copyWith({String? id, String? title, List<Task>? tasks}) {
    return BoardColumnModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [id, title, tasks];
}
