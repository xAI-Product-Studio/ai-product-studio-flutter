import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/generation_request_entity.dart';
import '../../domain/entities/generation_result_entity.dart';
import '../../domain/entities/platform_config_entity.dart';
import '../../domain/repositories/ai_generation_repository.dart';
import '../datasources/ai_remote_datasource.dart';
import '../models/platform_config_model.dart';

@LazySingleton(as: AiGenerationRepository)
class AiGenerationRepositoryImpl implements AiGenerationRepository {
  final AiRemoteDataSource _remoteDataSource;
  final Logger _logger;

  const AiGenerationRepositoryImpl(this._remoteDataSource, this._logger);

  @override
  Future<Either<Failure, GenerationResultEntity>> generateAll({required GenerationRequestEntity request}) async {
    try {
      final result = await _remoteDataSource.generateAll(request: request);
      return Right(result);
    } on AiServiceException catch (e) {
      return Left(AiServiceFailure(message: e.message, retryAfter: e.retryAfter));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (generateAll)', error: e, stackTrace: st);
      return const Left(AiServiceFailure(message: 'İçerik üretimi sırasında beklenmedik bir hata oluştu.'));
    }
  }

  @override
  Future<Either<Failure, GenerationResultEntity>> generateImage({required GenerationRequestEntity request}) async {
    try {
      final result = await _remoteDataSource.generateImage(request: request);
      return Right(result);
    } on AiServiceException catch (e) {
      return Left(AiServiceFailure(message: e.message, retryAfter: e.retryAfter));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (generateImage)', error: e, stackTrace: st);
      return const Left(AiServiceFailure(message: 'Görsel üretimi başarısız oldu.'));
    }
  }

  @override
  Future<Either<Failure, GenerationResultEntity>> generateAdCopy({required GenerationRequestEntity request}) async {
    try {
      final result = await _remoteDataSource.generateAdCopy(request: request);
      return Right(result);
    } on AiServiceException catch (e) {
      return Left(AiServiceFailure(message: e.message, retryAfter: e.retryAfter));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (generateAdCopy)', error: e, stackTrace: st);
      return const Left(AiServiceFailure(message: 'Reklam metni üretimi başarısız oldu.'));
    }
  }

  @override
  Future<Either<Failure, List<GenerationResultEntity>>> getHistory({int page = 1, int limit = 20, SupportedPlatform? platformFilter}) async {
    try {
      final results = await _remoteDataSource.getHistory(page: page, limit: limit, platformFilter: platformFilter);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (getHistory)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Geçmiş veriler alınamadı.'));
    }
  }

  @override
  Future<Either<Failure, GenerationResultEntity>> getGenerationById({required String id}) async {
    try {
      final result = await _remoteDataSource.getGenerationById(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (getGenerationById)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Üretim detayları alınamadı.'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite({required String id, required bool isFavorite}) async {
    try {
      await _remoteDataSource.toggleFavorite(id: id, isFavorite: isFavorite);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (toggleFavorite)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Favori durumu güncellenemedi.'));
    }
  }

  @override
  Future<Either<Failure, List<PlatformConfigEntity>>> getPlatformConfigs() async {
    try {
      final configs = PlatformConfigFactory.getAll();
      return Right(configs);
    } catch (e, st) {
      _logger.e('Platform config hatası', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Platform konfigürasyonları yüklenemedi.'));
    }
  }
}
