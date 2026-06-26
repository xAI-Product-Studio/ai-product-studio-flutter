import 'generation_result_entity.dart';

class HistoryResponseEntity {
  final List<GenerationResultEntity> results;
  final int total;
  const HistoryResponseEntity({required this.results, required this.total});
}
