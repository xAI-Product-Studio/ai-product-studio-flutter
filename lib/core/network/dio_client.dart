import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../error/exceptions.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';

class _AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _tokenDio;
  final Logger _logger;
  bool _isRefreshing = false;

  _AuthInterceptor({
    required SecureStorageService storage,
    required Dio tokenDio,
    required Logger logger,
  })  : _storage = storage,
        _tokenDio = tokenDio,
        _logger = logger;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      _logger.w('Token okunamadi: $e');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _storage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          throw const AuthException(statusCode: 401);
        }
        final response = await _tokenDio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh_token': refreshToken},
        );
        final newAccessToken = response.data['access_token'] as String;
        final newRefreshToken = response.data['refresh_token'] as String?;
        await _storage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
        }
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _tokenDio.fetch(err.requestOptions);
        handler.resolve(retryResponse);
        return;
      } catch (e) {
        _logger.e('Token yenileme basarisiz', error: e);
        await _storage.clearAll();
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: const AuthException(statusCode: 401),
          type: DioExceptionType.badResponse,
          response: err.response,
        ));
        return;
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err);
  }
}

class _ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (kIsWeb) {
      handler.next(options);
      return;
    }
    handler.next(options);
  }
}

@lazySingleton
class DioClient {
  late final Dio _dio;
  final Logger _logger;

  DioClient(SecureStorageService storage, Logger logger) : _logger = logger {
    final tokenDio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiEndpoints.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: ApiEndpoints.receiveTimeoutMs),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiEndpoints.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: ApiEndpoints.receiveTimeoutMs),
      sendTimeout: const Duration(milliseconds: ApiEndpoints.sendTimeoutMs),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    _dio.interceptors.addAll([
      _ConnectivityInterceptor(),
      _AuthInterceptor(storage: storage, tokenDio: tokenDio, logger: logger),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
        ),
    ]);
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      final mergedOptions = options != null
          ? Options(
              headers: {...?options.headers},
              responseType: options.responseType,
              contentType: options.contentType,
              validateStatus: options.validateStatus,
            )
          : null;
      return await _dio.get<T>(path, queryParameters: queryParameters, options: mergedOptions, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> patch<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      return await _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> uploadFile<T>(String path, {required FormData formData, void Function(int sent, int total)? onSendProgress, CancelToken? cancelToken}) async {
    try {
      return await _dio.post<T>(path,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}, sendTimeout: const Duration(milliseconds: ApiEndpoints.sendTimeoutMs)),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    _logger.e('DioException: ${e.type}', error: e.error, stackTrace: e.stackTrace);
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return const NetworkException(message: 'Sunucu yanit vermedi.');
    }
    if (e.type == DioExceptionType.sendTimeout) {
      return const NetworkException(message: 'Dosya yukleme zaman asimina ugradi.');
    }
    if (e.type == DioExceptionType.badCertificate) {
      return const NetworkException(message: 'Guvenlik sertifikasi dogrulanamadi.');
    }

    if (e.error is Exception) return e.error as Exception;

    switch (e.type) {
      case DioExceptionType.badResponse:
        return _handleResponseError(e.response);
      case DioExceptionType.cancel:
        return const ServerException(message: 'Istek iptal edildi.', statusCode: -1);
      default:
        return ServerException(message: 'Beklenmedik bir hata olustu.', statusCode: e.response?.statusCode);
    }
  }

  Exception _handleResponseError(Response<dynamic>? response) {
    if (response == null) return const ServerException(message: 'Sunucudan yanit alinamadi.');
    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    String message = _extractErrorMessage(data, statusCode);
    switch (statusCode) {
      case 400: return ServerException(message: message, statusCode: statusCode);
      case 401: return AuthException(message: message, statusCode: statusCode);
      case 403: return AuthException(message: 'Bu islem icin yetkiniz bulunmuyor.', statusCode: statusCode);
      case 404: return ServerException(message: 'Istenen kaynak bulunamadi.', statusCode: statusCode);
      case 422: return ServerException(message: message, statusCode: statusCode);
      case 429:
        final retryAfter = _extractRetryAfter(response);
        return AiServiceException(message: 'Istek limiti asildi. $retryAfter saniye sonra tekrar deneyin.', statusCode: statusCode, retryAfter: retryAfter);
      default:
        if (statusCode >= 500) return ServerException(message: 'Sunucu hatasi olustu.', statusCode: statusCode);
        return ServerException(message: message, statusCode: statusCode);
    }
  }

  String _extractErrorMessage(dynamic data, int statusCode) {
    if (data == null) return 'Hata kodu: $statusCode';
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String? ?? data['detail'] as String? ?? 'Hata kodu: $statusCode';
    }
    if (data is String && data.isNotEmpty) return data;
    return 'Hata kodu: $statusCode';
  }

  int? _extractRetryAfter(Response<dynamic> response) {
    final header = response.headers.value('retry-after');
    if (header != null) return int.tryParse(header);
    final body = response.data;
    if (body is Map<String, dynamic>) return body['retry_after'] as int?;
    return 60;
  }
}
