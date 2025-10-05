import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';

Future<void> showAddTaskDialog(
  BuildContext context, {
  String? initialColumnId,
}) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  await showDialog(
    context: context,
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
                final blocState = context.read<KanbanBloc>().state;
                if (blocState is KanbanLoaded) {
                  final target =
                      initialColumnId ??
                      (blocState.columns.isNotEmpty
                          ? blocState.columns.first.id
                          : null);
                  if (target != null) {
                    context.read<KanbanBloc>().add(
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
