part of 'kanban_bloc.dart';

abstract class KanbanState extends Equatable {
  const KanbanState();

  @override
  List<Object?> get props => [];
}

class KanbanInitial extends KanbanState {}

class KanbanLoading extends KanbanState {}

class KanbanLoaded extends KanbanState {
  final List<BoardColumnModel> columns;
  final String? message;

  const KanbanLoaded({required this.columns, this.message});

  KanbanLoaded copyWith({List<BoardColumnModel>? columns, String? message}) {
    return KanbanLoaded(
      columns: columns ?? this.columns,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [columns, message];
}

class KanbanError extends KanbanState {
  final String error;
  const KanbanError(this.error);

  @override
  List<Object?> get props => [error];
}
