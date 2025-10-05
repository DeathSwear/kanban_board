import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/data/api/services/main_service.dart';
import 'package:kanban_board/core/data/api/utils/api_util.dart';
import 'package:kanban_board/features/board/data/repositories/kanban_repository.dart';
import 'package:kanban_board/features/board/domain/bloc/kanban_bloc.dart';
import 'package:kanban_board/features/board/presentation/screens/kanban_board_screen.dart';

void main() {
  runApp(const MainApp());
}

final Dio dio = Dio();
final MainService mainService = MainService(dio: dio);
final ApiUtil apiUtil = ApiUtil(mainService: mainService);
final KanbanRepository kanbanRepository = KanbanRepository(apiUtil: apiUtil);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => KanbanBloc(repository: kanbanRepository),
        child: KanbanBoardScreen(),
      ),
    );
  }
}
