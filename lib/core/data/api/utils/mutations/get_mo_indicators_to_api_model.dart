import 'package:kanban_board/core/data/api/models/api_board_column_model.dart';
import 'package:kanban_board/core/data/api/models/api_item.dart';
import 'package:kanban_board/core/data/api/models/api_task_model.dart';

List<ApiBoardColumnModel> transformToBoardColumns(List<dynamic> rows) {
  final items =
      rows.map((e) => ApiItem.fromMap(Map<String, dynamic>.from(e))).toList();

  final Map<String, ApiItem> byId = {for (var e in items) e.id: e};

  final Map<String, List<ApiItem>> childrenMap = {};
  for (var item in items) {
    childrenMap.putIfAbsent(item.parentId, () => []).add(item);
  }

  final Set<String> columnIds = childrenMap.keys.toSet();

  final List<ApiBoardColumnModel> columns = [];

  for (final columnId in columnIds) {
    final parent = byId[columnId];

    final columnName = parent?.name ?? columnId;

    final children = childrenMap[columnId] ?? [];

    final tasks =
        children
            .where((child) => !childrenMap.containsKey(child.id))
            .map(
              (child) => ApiTaskModel(
                id: child.id,
                name: child.name,
                parentId: child.parentId,
              ),
            )
            .toList();

    columns.add(
      ApiBoardColumnModel(
        id: parent?.id ?? columnId,
        name: columnName,
        parentId: parent?.parentId ?? "0",
        tasks: tasks,
      ),
    );
  }

  final columnsWithPaths =
      columns.map((col) {
        final fullName = _buildFullName(col, byId);
        return ApiBoardColumnModel(
          id: col.id,
          name: fullName,
          parentId: col.parentId,
          tasks: col.tasks,
        );
      }).toList();

  columnsWithPaths.sort((a, b) {
    final aOrder = byId[a.id]?.order ?? 0;
    final bOrder = byId[b.id]?.order ?? 0;
    return aOrder.compareTo(bOrder);
  });

  return columnsWithPaths;
}

String _buildFullName(ApiBoardColumnModel col, Map<String, ApiItem> byId) {
  final current = byId[col.id];
  if (current == null) return col.name;

  final path = <String>[current.name];
  ApiItem? node = current;

  while (node != null && node.parentId != "0" && node.parentId != node.id) {
    final parent = byId[node.parentId];
    if (parent == null) break;
    path.insert(0, parent.name);
    node = parent;
  }

  return path.join("->");
}
