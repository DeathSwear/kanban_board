import 'package:kanban_board/core/data/api/utils/api_util.dart';
import 'package:kanban_board/features/board/domain/entities/board_column_model.dart';
import 'package:kanban_board/features/board/domain/entities/task.dart';
import 'package:kanban_board/features/board/domain/repositories/kanban_repository_interface.dart';
import 'package:uuid/uuid.dart';

class KanbanRepository implements IKanbanRepository {
  final ApiUtil _apiUtil;
  final Uuid _uuid = const Uuid();

  final Map<String, List<Task>> _data = {};
  final List<String> _order = [];

  KanbanRepository({required ApiUtil apiUtil}) : _apiUtil = apiUtil;

  @override
  Future<List<BoardColumnModel>> fetchAllBoards() async {
    final apiColumns = await _apiUtil.getMoIndicators();

    _data.clear();
    _order.clear();

    for (final col in apiColumns) {
      _order.add(col.id);
      _data[col.id] = List<Task>.from(col.tasks);
    }

    return List<BoardColumnModel>.from(apiColumns);
  }

  @override
  Future<Task> addTask(String columnId, Task task) async {
    final id = _uuid.v4();
    final newTask = task.copyWith(id: id);

    final columnTasks = _data[columnId];
    if (columnTasks == null) {
      throw Exception('Column $columnId not found');
    }

    columnTasks.insert(0, newTask);
    return Future.value(newTask);
  }

  @override
  Future<BoardColumnModel> addBoard(String title) async {
    final id = 'board_${_order.length + 1}';
    _order.add(id);
    _data[id] = [];

    final newBoard = BoardColumnModel(id: id, title: title, tasks: const []);

    return Future.value(newBoard);
  }

  @override
  Future<void> moveTask({
    required String taskId,
    required String fromColumnId,
    required String toColumnId,
    required int toIndex,
  }) async {
    final from = _data[fromColumnId];
    final to = _data[toColumnId];
    if (from == null || to == null) {
      throw Exception('Column not found');
    }

    final idx = from.indexWhere((t) => t.id == taskId);
    if (idx == -1) throw Exception('Task not found');

    final task = from.removeAt(idx);
    final insertAt = toIndex.clamp(0, to.length);
    to.insert(insertAt, task);

    return;
  }
}
