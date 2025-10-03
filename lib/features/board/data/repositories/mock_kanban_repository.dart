import 'dart:async';

import 'package:kanban_board/features/board/domain/entities/board_column_model.dart';
import 'package:kanban_board/features/board/domain/entities/task.dart';
import 'package:kanban_board/features/board/domain/repositories/kanban_repository_interface.dart';
import 'package:uuid/uuid.dart';

class MockKanbanRepository implements IKanbanRepository {
  final Uuid _uuid = const Uuid();

  final Map<String, List<Task>> _data = {};
  final List<String> _order = [];

  MockKanbanRepository() {
    for (var c = 0; c < 4; c++) {
      final id = 'board_${c + 1}';
      _order.add(id);
      _data[id] = List.generate(8, (i) {
        return Task(
          id: _uuid.v4(),
          title: 'Task ${i + 1} (col ${c + 1})',
          description: null,
        );
      });
    }
  }

  @override
  Future<List<BoardColumnModel>> fetchAllBoards() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _order.map((id) {
      final tasks = List<Task>.from(_data[id]!);
      return BoardColumnModel(
        id: id,
        title: 'Worker ${id.split("_").last}',
        tasks: tasks,
      );
    }).toList();
  }

  @override
  Future<void> moveTask({
    required String taskId,
    required String fromColumnId,
    required String toColumnId,
    required int toIndex,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final from = _data[fromColumnId];
    final to = _data[toColumnId];
    if (from == null || to == null) throw Exception('Column not found');
    final idx = from.indexWhere((t) => t.id == taskId);
    if (idx == -1) throw Exception('Task not found');
    final task = from.removeAt(idx);
    final insertAt = toIndex.clamp(0, to.length);
    to.insert(insertAt, task);
  }

  @override
  Future<Task> addTask(String columnId, Task task) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final id = _uuid.v4();
    final t = task.copyWith(id: id);
    _data[columnId]?.insert(0, t);
    return t;
  }

  @override
  Future<BoardColumnModel> addBoard(String title) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final id = 'board_${_order.length + 1}';
    _order.add(id);
    _data[id] = [];
    return BoardColumnModel(id: id, title: title, tasks: []);
  }
}
