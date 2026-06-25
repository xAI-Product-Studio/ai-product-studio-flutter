import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvConfig {
  EnvConfig._();

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  static String _require(String key) {
    final value = dotenv.env[key];
    assert(value != null && value.isNotEmpty, '[EnvConfig] "$key" anahtarı .env dosyasında tanımlanmamış.');
    if (value == null || value.isEmpty) {
      throw StateError('[EnvConfig] "$key" ortam değişkeni bulunamadı.');
    }
    return value;
  }

  static String? _optional(String key) => dotenv.env[key];

  static bool _flag(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key]?.toLowerCase();
    if (value == null) return defaultValue;
    return value == 'true' || value == '1';
  }

  static String get apiBaseUrl =>
      _optional('API_BASE_URL') ?? 'https://web-production-4afd4.up.railway.app';

  static String get openAiApiKey => _require('OPENAI_API_KEY');

  static String? get openAiOrgId => _optional('OPENAI_ORG_ID');

  static String get stabilityApiKey => _require('STABILITY_API_KEY');

  static String? get removeBgApiKey => _optional('REMOVE_BG_API_KEY');

  static String get appEnv => _optional('APP_ENV') ?? 'development';

  static bool get isDevelopment => appEnv == 'development';
  static bool get isStaging => appEnv == 'staging';
  static bool get isProduction => appEnv == 'production';

  static String? get sentryDsn => _optional('SENTRY_DSN');

  static bool get enableRemoveBg => _flag('ENABLE_REMOVE_BG', defaultValue: false);
  static bool get enableImageEnhance => _flag('ENABLE_IMAGE_ENHANCE', defaultValue: false);
  static bool get enableTikTokPlatform => _flag('ENABLE_TIKTOK_PLATFORM', defaultValue: true);

  static String _maskKey(String? key) {
    if (key == null || key.isEmpty) return '(tanımsız)';
    if (key.length <= 8) return '****';
    return '${key.substring(0, 8)}****';
  }

  static Map<String, String> debugSummary() {
    assert(!isProduction, 'debugSummary() production ortamında çağrılmamalı.');
    return {
      'APP_ENV': appEnv,
      'API_BASE_URL': apiBaseUrl,
      'OPENAI_API_KEY': _maskKey(_optional('OPENAI_API_KEY')),
      'STABILITY_API_KEY': _maskKey(_optional('STABILITY_API_KEY')),
      'SENTRY_DSN': _maskKey(_optional('SENTRY_DSN')),
      'ENABLE_REMOVE_BG': enableRemoveBg.toString(),
      'ENABLE_IMAGE_ENHANCE': enableImageEnhance.toString(),
      'ENABLE_TIKTOK_PLATFORM': enableTikTokPlatform.toString(),
    };
  }
}
