import 'package:ai_product_studio/core/utils/env_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => EnvConfig.apiBaseUrl;

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Users
  static const String me = '/users/me';

  // AI Generation
  static const String generate = '/ai/generate';
  static String generationStatus(String id) => '/ai/generate/$id';
  static const String generationHistory = '/ai/history';
  static String generationById(String id) => '/ai/history/$id';

  // Timeouts
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 60000;
  static const int sendTimeoutMs = 30000;
}
