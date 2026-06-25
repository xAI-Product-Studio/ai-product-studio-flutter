import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure({required this.message});
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});
  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Internet baglantisi bulunamadi. Lutfen baglantiinizi kontrol edin.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Yerel veri okunamadi. Uygulama verilerini temizlemeyi deneyin.'});
}

class AuthFailure extends Failure {
  final int? statusCode;
  const AuthFailure({super.message = 'Oturum sureniz dolmus. Lutfen tekrar giris yapin.', this.statusCode});
  @override
  List<Object?> get props => [message, statusCode];
}

class AiServiceFailure extends Failure {
  final int? retryAfter;
  const AiServiceFailure({required super.message, this.retryAfter});
  @override
  List<Object?> get props => [message, retryAfter];
}

class UploadFailure extends Failure {
  final int? maxSizeMb;
  const UploadFailure({required super.message, this.maxSizeMb});
  @override
  List<Object?> get props => [message, maxSizeMb];
}

class ParseFailure extends Failure {
  const ParseFailure({super.message = 'Sunucu yaniti beklenmedik bir formatta geldi.'});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Gerekli izin reddedildi. Lutfen uygulama ayarlarindan izin verin.'});
}
