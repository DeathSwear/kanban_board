import 'package:kanban_board/core/data/api/models/api_task_model.dart';
import 'package:kanban_board/features/board/domain/entities/task.dart';

extension TaskMapper on ApiTaskModel {
  Task toDomain() {
    return Task(id: id, title: name);
  }
}
