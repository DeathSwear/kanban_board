import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';

Future<void> showAddBoardDialog(BuildContext parentContext) async {
  final titleController = TextEditingController();
  await showDialog(
    context: parentContext,
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
                  parentContext.read<KanbanBloc>().add(KanbanAddBoard(title));
                }
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
  );
}
