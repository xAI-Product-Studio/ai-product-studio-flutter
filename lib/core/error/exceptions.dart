class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});
  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Internet baglantisi bulunamadi. Lutfen baglantiinizi kontrol edin.'});
  @override
  String toString() => 'NetworkException(message: $message)';
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Yerel veri okunamadi. Uygulama verilerini temizlemeyi deneyin.'});
  @override
  String toString() => 'CacheException(message: $message)';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;
  const AuthException({this.message = 'Oturum sureniz dolmus. Lutfen tekrar giris yapin.', this.statusCode});
  @override
  String toString() => 'AuthException(statusCode: $statusCode, message: $message)';
}

class AiServiceException implements Exception {
  final String message;
  final int? statusCode;
  final int? retryAfter;
  const AiServiceException({required this.message, this.statusCode, this.retryAfter});
  @override
  String toString() => 'AiServiceException(statusCode: $statusCode, retryAfter: $retryAfter, message: $message)';
}

class UploadException implements Exception {
  final String message;
  final int? maxSizeMb;
  const UploadException({required this.message, this.maxSizeMb});
  @override
  String toString() => 'UploadException(maxSizeMb: $maxSizeMb, message: $message)';
}

class ParseException implements Exception {
  final String message;
  const ParseException({this.message = 'Sunucu yaniti beklenmedik bir formatta geldi.'});
  @override
  String toString() => 'ParseException(message: $message)';
}
