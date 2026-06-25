import 'package:equatable/equatable.dart';
import 'platform_config_entity.dart';

class AdCopyEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> bulletPoints;
  final List<String> hashtags;
  final String? callToAction;
  final SupportedPlatform platform;
  final AdCopyTone tone;
  final String language;
  final DateTime createdAt;
  final bool isFavorited;

  const AdCopyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.bulletPoints,
    required this.hashtags,
    this.callToAction,
    required this.platform,
    required this.tone,
    required this.language,
    required this.createdAt,
    this.isFavorited = false,
  });

  AdCopyEntity copyWith({bool? isFavorited}) {
    return AdCopyEntity(
      id: id, title: title, description: description,
      bulletPoints: bulletPoints, hashtags: hashtags,
      callToAction: callToAction, platform: platform,
      tone: tone, language: language, createdAt: createdAt,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  @override
  List<Object> get props => [id, title];
}
