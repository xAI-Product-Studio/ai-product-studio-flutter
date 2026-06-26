import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;
  final Logger _logger;

  const AuthRepositoryImpl(this._remoteDataSource, this._storage, this._logger);

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    try {
      final result = await _remoteDataSource.login(email: email, password: password);
      await Future.wait([
        _storage.saveAccessToken(result.accessToken),
        _storage.saveRefreshToken(result.refreshToken),
        _storage.saveUserId(result.user.id),
        _storage.saveUserEmail(result.user.email),
      ]);
      _logger.i('Kullanıcı giriş yaptı: ${result.user.email}');
      return Right(result.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (login)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Beklenmedik bir hata oluştu.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({required String fullName, required String email, required String password}) async {
    try {
      final result = await _remoteDataSource.register(fullName: fullName, email: email, password: password);
      await Future.wait([
        _storage.saveAccessToken(result.accessToken),
        _storage.saveRefreshToken(result.refreshToken),
        _storage.saveUserId(result.user.id),
        _storage.saveUserEmail(result.user.email),
      ]);
      _logger.i('Yeni kullanıcı kaydoldu: ${result.user.email}');
      return Right(result.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (register)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Beklenmedik bir hata oluştu.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout().catchError((Object e) {
        _logger.w('Sunucu logout isteği başarısız: $e');
      });
      await _storage.clearAll();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (logout)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Çıkış yapılırken bir hata oluştu.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (getCurrentUser)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Kullanıcı bilgileri alınamadı.'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (forgotPassword)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Şifre sıfırlama isteği gönderilemedi.'));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerification() async {
    try {
      await _remoteDataSource.resendVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (resendVerification)', error: e, stackTrace: st);
      return const Left(ServerFailure(message: 'Doğrulama e-postası gönderilemedi.'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final hasToken = await _storage.hasAccessToken();
      return Right(hasToken);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e, st) {
      _logger.e('Beklenmedik hata (isAuthenticated)', error: e, stackTrace: st);
      return const Right(false);
    }
  }
}
