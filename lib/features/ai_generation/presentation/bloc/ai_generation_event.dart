import 'package:equatable/equatable.dart';
import '../../domain/entities/platform_config_entity.dart';

sealed class AiGenerationEvent extends Equatable {
  const AiGenerationEvent();
  @override
  List<Object?> get props => [];
}

final class AiGenerationConfigsRequested extends AiGenerationEvent {
  const AiGenerationConfigsRequested();
}

final class AiGenerationPlatformSelected extends AiGenerationEvent {
  final SupportedPlatform platform;
  const AiGenerationPlatformSelected({required this.platform});
  @override
  List<Object> get props => [platform];
}

final class AiGenerationStarted extends AiGenerationEvent {
  final String productName;
  final String productDescription;
  final SupportedPlatform platform;
  final AdCopyTone tone;
  final String? imagePath;

  const AiGenerationStarted({
    required this.productName,
    required this.productDescription,
    required this.platform,
    required this.tone,
    this.imagePath,
  });

  @override
  List<Object?> get props => [productName, productDescription, platform, tone, imagePath];
}

final class AiGenerationHistoryRequested extends AiGenerationEvent {
  final int page;
  final SupportedPlatform? platformFilter;
  const AiGenerationHistoryRequested({this.page = 1, this.platformFilter});
  @override
  List<Object?> get props => [page, platformFilter];
}

final class AiGenerationFavoriteToggled extends AiGenerationEvent {
  final String generationId;
  final bool isFavorite;
  const AiGenerationFavoriteToggled({required this.generationId, required this.isFavorite});
  @override
  List<Object> get props => [generationId, isFavorite];
}

final class AiGenerationReset extends AiGenerationEvent {
  const AiGenerationReset();
}
