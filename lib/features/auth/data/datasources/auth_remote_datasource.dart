import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<({UserModel user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  });

  Future<({UserModel user, String accessToken, String refreshToken})> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> forgotPassword({required String email});
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  const AuthRemoteDataSourceImpl(this._dioClient);

  Future<UserModel> _fetchUser(String accessToken) async {
    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      connectTimeout: const Duration(milliseconds: ApiEndpoints.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: ApiEndpoints.receiveTimeoutMs),
    ));
    final response = await dio.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<({UserModel user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokenResponse = await _dioClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final accessToken = tokenResponse.data['access_token'] as String;
      final refreshToken = tokenResponse.data['refresh_token'] as String;
      final user = await _fetchUser(accessToken);
      return (user: user, accessToken: accessToken, refreshToken: refreshToken);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<({UserModel user, String accessToken, String refreshToken})> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final tokenResponse = await _dioClient.post(
        ApiEndpoints.register,
        data: {'full_name': fullName, 'email': email, 'password': password},
      );
      final accessToken = tokenResponse.data['access_token'] as String;
      final refreshToken = tokenResponse.data['refresh_token'] as String;
      final user = await _fetchUser(accessToken);
      return (user: user, accessToken: accessToken, refreshToken: refreshToken);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post(ApiEndpoints.logout);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.me);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
