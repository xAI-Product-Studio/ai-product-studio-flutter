import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/platform_config_entity.dart';
import '../repositories/ai_generation_repository.dart';

@injectable
class GetPlatformConfigsUseCase {
  final AiGenerationRepository _repository;
  const GetPlatformConfigsUseCase(this._repository);

  Future<Either<Failure, List<PlatformConfigEntity>>> call() {
    return _repository.getPlatformConfigs();
  }
}
