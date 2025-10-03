import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban_board/features/board/domain/entities/board_column_model.dart';
import 'package:kanban_board/features/board/domain/entities/task.dart';
import 'package:kanban_board/features/board/domain/repositories/kanban_repository_interface.dart';

part 'kanban_bloc_event.dart';
part 'kanban_bloc_state.dart';

class KanbanBloc extends Bloc<KanbanEvent, KanbanState> {
  final IKanbanRepository repository;

  KanbanBloc({required this.repository}) : super(KanbanInitial()) {
    on<KanbanLoadRequested>(_onLoadRequested);
    on<KanbanRefreshRequested>(_onRefreshRequested);
    on<KanbanTaskMoved>(_onTaskMoved);
    on<KanbanAddTask>(_onAddTask);
    on<KanbanAddBoard>(_onAddBoard);
  }

  Future<void> _onLoadRequested(
    KanbanLoadRequested e,
    Emitter<KanbanState> emit,
  ) async {
    emit(KanbanLoading());
    try {
      final boards = await repository.fetchAllBoards();
      emit(KanbanLoaded(columns: boards));
    } catch (err) {
      emit(KanbanError(err.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    KanbanRefreshRequested e,
    Emitter<KanbanState> emit,
  ) async {
    add(KanbanLoadRequested());
  }

  Future<void> _onTaskMoved(
    KanbanTaskMoved e,
    Emitter<KanbanState> emit,
  ) async {
    final s = state;
    if (s is! KanbanLoaded) return;
    final cols = List<BoardColumnModel>.from(s.columns);
    if (e.fromListIndex < 0 || e.fromListIndex >= cols.length) return;
    if (e.toListIndex < 0 || e.toListIndex >= cols.length) return;

    final from = cols[e.fromListIndex];
    final to = cols[e.toListIndex];
    if (e.fromItemIndex < 0 || e.fromItemIndex >= from.tasks.length) return;

    final moving = from.tasks[e.fromItemIndex];

    if (e.fromListIndex == e.toListIndex) {
      final newTasks = List<Task>.from(from.tasks);
      final task = newTasks.removeAt(e.fromItemIndex);
      final insertAt = e.toItemIndex.clamp(0, newTasks.length);
      newTasks.insert(insertAt, task);
      cols[e.fromListIndex] = from.copyWith(tasks: newTasks);
    } else {
      final fromTasks = List<Task>.from(from.tasks)..removeAt(e.fromItemIndex);
      final toTasks = List<Task>.from(to.tasks);
      final insertAt = e.toItemIndex.clamp(0, toTasks.length);
      toTasks.insert(insertAt, moving);
      cols[e.fromListIndex] = from.copyWith(tasks: fromTasks);
      cols[e.toListIndex] = to.copyWith(tasks: toTasks);
    }

    emit(KanbanLoaded(columns: cols));

    // persist
    try {
      await repository.moveTask(
        taskId: moving.id,
        fromColumnId: from.id,
        toColumnId: to.id,
        toIndex: e.toItemIndex,
      );
    } catch (err) {
      add(KanbanRefreshRequested());
    }
  }

  Future<void> _onAddTask(KanbanAddTask e, Emitter<KanbanState> emit) async {
    final s = state;
    if (s is! KanbanLoaded) return;
    final idx = s.columns.indexWhere((c) => c.id == e.columnId);
    if (idx == -1) return;

    final temp = Task(
      id: 'tmp-${DateTime.now().millisecondsSinceEpoch}',
      title: e.title,
      description: e.description,
    );
    final cols = List<BoardColumnModel>.from(s.columns);
    final col = cols[idx];
    cols[idx] = col.copyWith(tasks: [temp, ...col.tasks]);
    emit(KanbanLoaded(columns: cols));

    try {
      final added = await repository.addTask(e.columnId, temp);
      final replaced =
          cols[idx].tasks.map((t) => t.id == temp.id ? added : t).toList();
      cols[idx] = cols[idx].copyWith(tasks: replaced);
      emit(KanbanLoaded(columns: cols, message: 'Task added'));
    } catch (err) {
      add(KanbanRefreshRequested());
    }
  }

  Future<void> _onAddBoard(KanbanAddBoard e, Emitter<KanbanState> emit) async {
    final s = state;
    if (s is! KanbanLoaded) return;
    try {
      final newBoard = await repository.addBoard(e.title);
      final cols = List<BoardColumnModel>.from(s.columns)..add(newBoard);
      emit(KanbanLoaded(columns: cols, message: 'Board added'));
    } catch (err) {
      emit(
        KanbanLoaded(
          columns: s.columns,
          message: 'Failed to add board: ${err.toString()}',
        ),
      );
    }
  }
}
