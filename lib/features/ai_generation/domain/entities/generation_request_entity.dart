import 'package:equatable/equatable.dart';

import 'platform_config_entity.dart';

class GenerationRequestEntity extends Equatable {
  final String productName;
  final String productDescription;
  final String? productCategory;
  final List<String> keyFeatures;
  final String? targetAudience;
  final SupportedPlatform platform;
  final ImageStyle imageStyle;
  final AdCopyTone adCopyTone;
  final String? customPromptAddition;
  final String? referenceImageBase64;
  final String language;

  const GenerationRequestEntity({
    required this.productName,
    required this.productDescription,
    this.productCategory,
    required this.keyFeatures,
    this.targetAudience,
    required this.platform,
    required this.imageStyle,
    required this.adCopyTone,
    this.customPromptAddition,
    this.referenceImageBase64,
    this.language = 'tr',
  });

  @override
  List<Object?> get props => [productName, platform, imageStyle, adCopyTone];
}
