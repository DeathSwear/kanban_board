import 'package:kanban_board/core/data/api/services/main_service.dart';
import 'package:kanban_board/features/board/data/mappers/board_column_mapper.dart';
import 'package:kanban_board/features/board/domain/entities/board_column_model.dart';

class ApiUtil {
  final MainService _mainService;

  ApiUtil({required MainService mainService}) : _mainService = mainService;

  Future<List<BoardColumnModel>> getMoIndicators() async {
    final columns = await _mainService.getMoIndicators();
    return columns.map((c) => c.toDomain()).toList();
  }
}
