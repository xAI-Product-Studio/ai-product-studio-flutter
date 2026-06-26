import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/generation_request_entity.dart';
import '../entities/generation_result_entity.dart';
import '../entities/platform_config_entity.dart';

abstract interface class AiGenerationRepository {
  Future<Either<Failure, GenerationResultEntity>> generateAll({
    required GenerationRequestEntity request,
  });

  Future<Either<Failure, GenerationResultEntity>> generateImage({
    required GenerationRequestEntity request,
  });

  Future<Either<Failure, GenerationResultEntity>> generateAdCopy({
    required GenerationRequestEntity request,
  });

  Future<Either<Failure, ({List<GenerationResultEntity> results, int total})>> getHistory({
    int page = 1,
    int limit = 20,
    SupportedPlatform? platformFilter,
  });

  Future<Either<Failure, GenerationResultEntity>> getGenerationById({
    required String id,
  });

  Future<Either<Failure, void>> toggleFavorite({
    required String id,
    required bool isFavorite,
  });

  Future<Either<Failure, List<PlatformConfigEntity>>> getPlatformConfigs();
}
