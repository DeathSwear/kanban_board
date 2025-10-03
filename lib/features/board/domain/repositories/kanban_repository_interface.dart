import 'package:kanban_board/features/board/domain/entities/board_column_model.dart';
import 'package:kanban_board/features/board/domain/entities/task.dart';

abstract class IKanbanRepository {
  Future<List<BoardColumnModel>> fetchAllBoards();

  Future<void> moveTask({
    required String taskId,
    required String fromColumnId,
    required String toColumnId,
    required int toIndex,
  });

  Future<Task> addTask(String columnId, Task task);

  Future<BoardColumnModel> addBoard(String title);
}
