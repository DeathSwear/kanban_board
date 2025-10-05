import 'package:kanban_board/core/data/api/models/api_item.dart';

class ApiTaskModel extends ApiItem {
  ApiTaskModel({
    required super.parentId,
    required super.name,
    required super.id,
  });
}
