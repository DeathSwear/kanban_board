import 'package:flutter/material.dart';
import 'package:kanban_board/features/board/presentation/dialogs/add_task_dialog.dart';
import 'package:kanban_board/features/board/presentation/utils/kanban_board_utils.dart';
import '../../domain/entities/board_column_model.dart';

class KanbanBoardHeader extends StatelessWidget {
  final BoardColumnModel col;
  const KanbanBoardHeader({super.key, required this.col});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: getColorForId(col.id),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
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
                () => showAddTaskDialog(context, initialColumnId: col.id),
          ),
        ],
      ),
    );
  }
}
