import 'package:equatable/equatable.dart';
import 'platform_config_entity.dart';

class GeneratedImageEntity extends Equatable {
  final String id;
  final String imageUrl;
  final String thumbnailUrl;
  final ImageDimensions dimensions;
  final SupportedPlatform platform;
  final ImageStyle style;
  final String promptUsed;
  final DateTime createdAt;
  final bool isFavorited;

  const GeneratedImageEntity({
    required this.id,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.dimensions,
    required this.platform,
    required this.style,
    required this.promptUsed,
    required this.createdAt,
    this.isFavorited = false,
  });

  GeneratedImageEntity copyWith({bool? isFavorited}) {
    return GeneratedImageEntity(
      id: id, imageUrl: imageUrl, thumbnailUrl: thumbnailUrl,
      dimensions: dimensions, platform: platform, style: style,
      promptUsed: promptUsed, createdAt: createdAt,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  @override
  List<Object> get props => [id, imageUrl];
}
