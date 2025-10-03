import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boardview/boardview.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';
import 'package:kanban_board/features/board/domain/entities/board_column_model.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<KanbanBloc>().add(KanbanLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                () => context.read<KanbanBloc>().add(KanbanRefreshRequested()),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBoardDialog(context),
          ),
        ],
      ),
      body: BlocListener<KanbanBloc, KanbanState>(
        listener: (context, state) {
          if (state is KanbanLoaded &&
              state.message != null &&
              state.message!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          } else if (state is KanbanError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<KanbanBloc, KanbanState>(
          builder: (context, state) {
            if (state is KanbanLoading || state is KanbanInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KanbanError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is KanbanLoaded) {
              final columns = state.columns;
              return BoardView(
                lists: List.generate(columns.length, (listIndex) {
                  final col = columns[listIndex];
                  return BoardList(
                    header: [_buildHeader(col)],
                    items: List.generate(col.tasks.length, (itemIndex) {
                      final task = col.tasks[itemIndex];
                      return BoardItem(
                        item: SizedBox(
                          width: 260,
                          child: Card(
                            key: ValueKey(task.id),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(task.title),
                            ),
                          ),
                        ),
                        onTapItem: (li, ii, st) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(task.title)));
                        },
                        onStartDragItem: (li, ii, st) {},
                        onDropItem: (
                          int? newListIndex,
                          int? newItemIndex,
                          int? oldListIndex,
                          int? oldItemIndex,
                          BoardItemState? s,
                        ) {
                          if (newListIndex == null ||
                              newItemIndex == null ||
                              oldListIndex == null ||
                              oldItemIndex == null) {
                            return;
                          }
                          context.read<KanbanBloc>().add(
                            KanbanTaskMoved(
                              fromListIndex: oldListIndex,
                              fromItemIndex: oldItemIndex,
                              toListIndex: newListIndex,
                              toItemIndex: newItemIndex,
                            ),
                          );
                        },
                      );
                    }),
                  );
                }),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BoardColumnModel col) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.blueGrey,
      child: Row(
        children: [
          Expanded(
            child: Text(col.title, style: const TextStyle(color: Colors.white)),
          ),
          Text(
            '${col.tasks.length}',
            style: const TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed:
                () => _showAddTaskDialog(context, initialColumnId: col.id),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTaskDialog(
    BuildContext ctx, {
    String? initialColumnId,
  }) async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    await showDialog(
      context: ctx,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isEmpty) return;
                  final blocState = ctx.read<KanbanBloc>().state;
                  if (blocState is KanbanLoaded) {
                    final target =
                        initialColumnId ??
                        (blocState.columns.isNotEmpty
                            ? blocState.columns.first.id
                            : null);
                    if (target != null) {
                      ctx.read<KanbanBloc>().add(
                        KanbanAddTask(
                          columnId: target,
                          title: title,
                          description: descController.text.trim(),
                        ),
                      );
                    }
                  }
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  Future<void> _showAddBoardDialog(BuildContext ctx) async {
    final titleController = TextEditingController();
    await showDialog(
      context: ctx,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Board'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    ctx.read<KanbanBloc>().add(KanbanAddBoard(title));
                  }
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }
}
