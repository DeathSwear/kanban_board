part of 'kanban_bloc.dart';

abstract class KanbanEvent extends Equatable {
  const KanbanEvent();

  @override
  List<Object?> get props => [];
}

class KanbanLoadRequested extends KanbanEvent {}

class KanbanRefreshRequested extends KanbanEvent {}

class KanbanTaskMoved extends KanbanEvent {
  final int fromListIndex;
  final int fromItemIndex;
  final int toListIndex;
  final int toItemIndex;

  const KanbanTaskMoved({
    required this.fromListIndex,
    required this.fromItemIndex,
    required this.toListIndex,
    required this.toItemIndex,
  });

  @override
  List<Object?> get props => [
    fromListIndex,
    fromItemIndex,
    toListIndex,
    toItemIndex,
  ];
}

class KanbanAddTask extends KanbanEvent {
  final String columnId;
  final String title;
  final String? description;

  const KanbanAddTask({
    required this.columnId,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [columnId, title, description];
}

class KanbanAddBoard extends KanbanEvent {
  final String title;
  const KanbanAddBoard(this.title);

  @override
  List<Object?> get props => [title];
}
