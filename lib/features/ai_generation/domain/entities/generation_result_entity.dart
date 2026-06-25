import 'package:equatable/equatable.dart';
import 'ad_copy_entity.dart';
import 'generated_image_entity.dart';
import 'generation_request_entity.dart';

enum GenerationStatus { pending, processing, completed, failed }

class GenerationResultEntity extends Equatable {
  final String id;
  final GenerationRequestEntity request;
  final GeneratedImageEntity? image;
  final List<String>? imageUrls;
  final AdCopyEntity? adCopy;
  final GenerationStatus status;
  final String? errorMessage;
  final DateTime createdAt;
  final int creditsUsed;

  const GenerationResultEntity({
    required this.id,
    required this.request,
    this.image,
    this.imageUrls,
    this.adCopy,
    required this.status,
    this.errorMessage,
    required this.createdAt,
    required this.creditsUsed,
  });

  bool get isCompleted => status == GenerationStatus.completed;
  bool get hasBothOutputs => image != null && adCopy != null;

  @override
  List<Object?> get props => [id, status, imageUrls];
}
