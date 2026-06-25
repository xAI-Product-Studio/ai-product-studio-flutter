import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/generation_result_entity.dart';
import '../entities/platform_config_entity.dart';
import '../repositories/ai_generation_repository.dart';

@injectable
class GetGenerationHistoryUseCase {
  final AiGenerationRepository _repository;
  const GetGenerationHistoryUseCase(this._repository);

  Future<Either<Failure, List<GenerationResultEntity>>> call(GetHistoryParams params) {
    return _repository.getHistory(
      page: params.page,
      limit: params.limit,
      platformFilter: params.platformFilter,
    );
  }
}

class GetHistoryParams extends Equatable {
  final int page;
  final int limit;
  final SupportedPlatform? platformFilter;

  const GetHistoryParams({this.page = 1, this.limit = 20, this.platformFilter});

  @override
  List<Object?> get props => [page, limit, platformFilter];
}
