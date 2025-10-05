import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kanban_board/core/data/api/models/api_board_column_model.dart';
import 'package:kanban_board/core/data/api/utils/mutations/get_mo_indicators_to_api_model.dart';
import 'package:kanban_board/secrets.dart';

class MainService {
  final Dio _dio;

  MainService({required Dio dio}) : _dio = dio;

  Future<List<ApiBoardColumnModel>> getMoIndicators() async {
    try {
      final formData = FormData.fromMap(Secrets.basicFormDataExample);
      final response = await _dio.post(
        Secrets.getMoIndicatorsUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Secrets.bearer}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return transformToBoardColumns(response.data['DATA']['rows']);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          throw Exception('No internet');
        }
      }
      rethrow;
    }
  }
}
