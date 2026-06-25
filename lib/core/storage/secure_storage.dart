import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../error/exceptions.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;
  final Logger _logger;

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyOnboardingDone = 'onboarding_done';

  SecureStorageService(this._logger)
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _keyAccessToken, value: token);
    } catch (e, st) {
      _logger.e('Access token kaydedilemedi', error: e, stackTrace: st);
      throw const CacheException(
        message: 'Oturum bilgisi kaydedilemedi. Lütfen tekrar giriş yapın.',
      );
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _keyAccessToken);
    } catch (e, st) {
      _logger.e('Access token okunamadı', error: e, stackTrace: st);
      return null;
    }
  }

  Future<bool> hasAccessToken() async {
    try {
      final token = await _storage.read(key: _keyAccessToken);
      return token != null && token.isNotEmpty;
    } catch (e, st) {
      _logger.e('Access token kontrolü başarısız', error: e, stackTrace: st);
      return false;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: token);
    } catch (e, st) {
      _logger.e('Refresh token kaydedilemedi', error: e, stackTrace: st);
      throw const CacheException(
        message: 'Oturum bilgisi kaydedilemedi. Lütfen tekrar giriş yapın.',
      );
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e, st) {
      _logger.e('Refresh token okunamadı', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _keyUserId, value: userId);
    } catch (e, st) {
      _logger.e('User ID kaydedilemedi', error: e, stackTrace: st);
      throw const CacheException(message: 'Kullanıcı bilgisi kaydedilemedi.');
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _keyUserId);
    } catch (e, st) {
      _logger.e('User ID okunamadı', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> saveUserEmail(String email) async {
    try {
      await _storage.write(key: _keyUserEmail, value: email);
    } catch (e, st) {
      _logger.e('User email kaydedilemedi', error: e, stackTrace: st);
      throw const CacheException(message: 'Kullanıcı bilgisi kaydedilemedi.');
    }
  }

  Future<String?> getUserEmail() async {
    try {
      return await _storage.read(key: _keyUserEmail);
    } catch (e, st) {
      _logger.e('User email okunamadı', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> setOnboardingDone() async {
    try {
      await _storage.write(key: _keyOnboardingDone, value: 'true');
    } catch (e, st) {
      _logger.e('Onboarding durumu kaydedilemedi', error: e, stackTrace: st);
    }
  }

  Future<bool> isOnboardingDone() async {
    try {
      final value = await _storage.read(key: _keyOnboardingDone);
      return value == 'true';
    } catch (e, st) {
      _logger.e('Onboarding durumu okunamadı', error: e, stackTrace: st);
      return false;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      _logger.i('SecureStorage tamamen temizlendi.');
    } catch (e, st) {
      _logger.e('SecureStorage temizlenemedi', error: e, stackTrace: st);
      throw const CacheException(message: 'Oturum kapatılırken bir hata oluştu.');
    }
  }

  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: _keyAccessToken),
        _storage.delete(key: _keyRefreshToken),
      ]);
      _logger.i('Tokenlar temizlendi.');
    } catch (e, st) {
      _logger.e('Tokenlar temizlenemedi', error: e, stackTrace: st);
      throw const CacheException(message: 'Oturum kapatılırken bir hata oluştu.');
    }
  }
}
