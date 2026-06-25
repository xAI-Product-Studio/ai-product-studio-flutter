import 'package:equatable/equatable.dart';

// ── Enums ────────────────────────────────────────────────────────────────────

enum SupportedPlatform {
  // TR Platformlar
  trendyol,
  hepsiburada,
  n11,
  sahibinden,
  amazonTR,
  ciceksepeti,
  // Global
  shopify,
  amazon,
  instagramFeed,
  instagramStory,
  tiktok,
  googleShopping,
  // Özel
  custom,
}

enum AdCopyTone {
  professional,
  friendly,
  urgent,
  luxurious,
  playful,
  minimalist,
}

enum ImageStyle {
  studioWhite,
  lifestyle,
  flatLay,
  gradient,
  natural,
  dramatic,
}

// ── Value Objects ─────────────────────────────────────────────────────────────

class ImageDimensions extends Equatable {
  final int width;
  final int height;
  final String label;
  final double aspectRatio;

  const ImageDimensions({
    required this.width,
    required this.height,
    required this.label,
  }) : aspectRatio = width / height;

  @override
  List<Object> get props => [width, height];
}

class AdCopyRules extends Equatable {
  final int maxTitleLength;
  final int maxDescriptionLength;
  final int maxBulletPoints;
  final bool supportsBulletPoints;
  final bool supportsEmoji;
  final bool supportsHashtags;
  final int? maxHashtags;
  final List<String> forbiddenWords;
  final String copywritingFramework;

  const AdCopyRules({
    required this.maxTitleLength,
    required this.maxDescriptionLength,
    required this.maxBulletPoints,
    required this.supportsBulletPoints,
    required this.supportsEmoji,
    required this.supportsHashtags,
    this.maxHashtags,
    this.forbiddenWords = const [],
    required this.copywritingFramework,
  });

  @override
  List<Object?> get props => [
        maxTitleLength,
        maxDescriptionLength,
        copywritingFramework,
      ];
}

/// Platform'un UI katmanında kullanılan görsel kimliği.
/// Widget, bu değerleri doğrudan okur — renk hesaplamaz.
class PlatformBrandIdentity extends Equatable {
  /// Hex renk kodu — örn. '#FF6000'
  final String brandColorHex;

  /// Platform chip'inde gösterilen kısa istatistik
  /// Örn. '+%60 tıklanma'
  final String statLabel;

  /// Kazanç motivasyon etiketi
  /// Örn. '+₺4.200/ay'
  final String earningLabel;

  /// Satıcı sayısı etiketi
  /// Örn. '300K+ satıcı'
  final String sellerCountLabel;

  const PlatformBrandIdentity({
    required this.brandColorHex,
    required this.statLabel,
    required this.earningLabel,
    required this.sellerCountLabel,
  });

  @override
  List<Object> get props => [brandColorHex, statLabel];
}

// ── Main Entity ───────────────────────────────────────────────────────────────

class PlatformConfigEntity extends Equatable {
  final SupportedPlatform platform;
  final String displayName;
  final String description;
  final String iconAsset;
  final ImageDimensions imageDimensions;
  final AdCopyRules adCopyRules;
  final List<String> promptSuggestions;
  final List<ImageStyle> recommendedStyles;

  /// Yeni: UI kimliği — renk, stat, kazanç etiketi
  final PlatformBrandIdentity brandIdentity;

  const PlatformConfigEntity({
    required this.platform,
    required this.displayName,
    required this.description,
    required this.iconAsset,
    required this.imageDimensions,
    required this.adCopyRules,
    required this.promptSuggestions,
    required this.recommendedStyles,
    required this.brandIdentity,
  });

  @override
  List<Object> get props => [platform];
}
