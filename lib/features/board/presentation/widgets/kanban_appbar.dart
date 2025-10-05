import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';
import 'package:kanban_board/features/board/presentation/dialogs/add_board_dialog.dart';

class KanbanBoardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KanbanBoardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black54,
      title: const Text('Kanban Board', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed:
              () => context.read<KanbanBloc>().add(KanbanRefreshRequested()),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => showAddBoardDialog(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
