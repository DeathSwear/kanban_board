import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/features/board/data/repositories/mock_kanban_repository.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';
import 'package:kanban_board/features/board/domain/repositories/kanban_repository_interface.dart';
import 'package:kanban_board/features/board/presentation/screens/kanban_board_screen.dart';

void main() {
  runApp(const MainApp());
}

final IKanbanRepository kanbanRepo = MockKanbanRepository();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => KanbanBloc(repository: kanbanRepo),
        child: KanbanBoardScreen(),
      ),
    );
  }
}
