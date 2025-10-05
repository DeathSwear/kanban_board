import 'package:kanban_board/core/data/api/models/api_board_column_model.dart';
import 'package:kanban_board/features/board/domain/entities/board_column_model.dart';

import 'task_mapper.dart';

extension BoardColumnMapper on ApiBoardColumnModel {
  BoardColumnModel toDomain() {
    return BoardColumnModel(
      id: id,
      title: name,
      tasks: tasks.map((t) => t.toDomain()).toList(),
    );
  }
}
