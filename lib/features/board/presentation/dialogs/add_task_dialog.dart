import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';

Future<void> showAddTaskDialog(
  BuildContext parentContext, {
  String? initialColumnId,
}) async {
  final titleController = TextEditingController();

  await showDialog(
    context: parentContext,
    builder:
        (dialogContext) => AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) return;

                final blocState = parentContext.read<KanbanBloc>().state;
                if (blocState is KanbanLoaded) {
                  final target = initialColumnId ?? blocState.columns.first.id;
                  parentContext.read<KanbanBloc>().add(
                    KanbanAddTask(columnId: target, title: title),
                  );
                }

                Navigator.pop(dialogContext);
              },
              child: const Text('Add'),
            ),
          ],
        ),
  );
}
