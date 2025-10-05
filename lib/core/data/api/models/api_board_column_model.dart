import 'package:kanban_board/core/data/api/models/api_item.dart';

import 'api_task_model.dart';

class ApiBoardColumnModel extends ApiItem {
  final List<ApiTaskModel> tasks;

  ApiBoardColumnModel({
    this.tasks = const [],
    required super.id,
    required super.name,
    required super.parentId,
  });
}
