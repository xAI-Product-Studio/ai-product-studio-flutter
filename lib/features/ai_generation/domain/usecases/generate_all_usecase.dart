import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/generation_request_entity.dart';
import '../entities/generation_result_entity.dart';
import '../repositories/ai_generation_repository.dart';

@injectable
class GenerateAllUseCase {
  final AiGenerationRepository _repository;
  const GenerateAllUseCase(this._repository);

  Future<Either<Failure, GenerationResultEntity>> call(GenerateAllParams params) {
    return _repository.generateAll(request: params.request);
  }
}

class GenerateAllParams extends Equatable {
  final GenerationRequestEntity request;
  const GenerateAllParams({required this.request});

  @override
  List<Object> get props => [request];
}
