import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boardview/boardview.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';
import 'package:kanban_board/features/board/presentation/widgets/kanban_appbar.dart';
import 'package:kanban_board/features/board/presentation/widgets/kanban_board_header.dart';

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
      backgroundColor: Colors.black87,
      appBar: const KanbanBoardAppBar(),
      body: BlocBuilder<KanbanBloc, KanbanState>(
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
                  backgroundColor: Colors.transparent,
                  header: [KanbanBoardHeader(col: col)],
                  items: List.generate(col.tasks.length, (itemIndex) {
                    final task = col.tasks[itemIndex];
                    return BoardItem(
                      item: SizedBox(
                        width: 260,
                        child: Card(
                          color: Colors.grey[200],
                          key: ValueKey(task.id),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(task.title),
                          ),
                        ),
                      ),
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
    );
  }
}
