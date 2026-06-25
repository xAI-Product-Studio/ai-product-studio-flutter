import '../../domain/entities/ad_copy_entity.dart';
import '../../domain/entities/generated_image_entity.dart';
import '../../domain/entities/generation_request_entity.dart';
import '../../domain/entities/generation_result_entity.dart';
import '../../domain/entities/platform_config_entity.dart';

class GeneratedImageModel extends GeneratedImageEntity {
  const GeneratedImageModel({
    required super.id, required super.imageUrl, required super.thumbnailUrl,
    required super.dimensions, required super.platform, required super.style,
    required super.promptUsed, required super.createdAt, super.isFavorited,
  });

  factory GeneratedImageModel.fromJson(Map<String, dynamic> json) {
    return GeneratedImageModel(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String? ?? json['image_url'] as String,
      dimensions: ImageDimensions(
        width: json['width'] as int? ?? 1024,
        height: json['height'] as int? ?? 1024,
        label: json['dimensions_label'] as String? ?? '1:1',
      ),
      platform: SupportedPlatform.values.firstWhere((e) => e.name == json['platform'], orElse: () => SupportedPlatform.shopify),
      style: ImageStyle.values.firstWhere((e) => e.name == json['style'], orElse: () => ImageStyle.studioWhite),
      promptUsed: json['prompt_used'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }
}

class AdCopyModel extends AdCopyEntity {
  const AdCopyModel({
    required super.id, required super.title, required super.description,
    required super.bulletPoints, required super.hashtags, super.callToAction,
    required super.platform, required super.tone, required super.language,
    required super.createdAt, super.isFavorited,
  });

  factory AdCopyModel.fromJson(Map<String, dynamic> json) {
    return AdCopyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      bulletPoints: (json['bullet_points'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      hashtags: (json['hashtags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      callToAction: json['call_to_action'] as String?,
      platform: SupportedPlatform.values.firstWhere((e) => e.name == json['platform'], orElse: () => SupportedPlatform.shopify),
      tone: AdCopyTone.values.firstWhere((e) => e.name == json['tone'], orElse: () => AdCopyTone.professional),
      language: json['language'] as String? ?? 'tr',
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }
}

class GenerationResultModel extends GenerationResultEntity {
  const GenerationResultModel({
    required super.id, required super.request, super.image, super.imageUrls, super.adCopy,
    required super.status, super.errorMessage, required super.createdAt, required super.creditsUsed,
  });

  factory GenerationResultModel.fromJson(Map<String, dynamic> json) {
    // Backend response'unu handle et
    final platform = SupportedPlatform.values.firstWhere(
      (e) => e.name == (json['platform'] as String? ?? 'shopify'),
      orElse: () => SupportedPlatform.shopify,
    );

    // Request objesi backend'den gelmiyorsa top-level field'lardan oluştur
    GenerationRequestEntity request;
    if (json['request'] != null && json['request'] is Map<String, dynamic>) {
      request = _parseRequest(json['request'] as Map<String, dynamic>);
    } else {
      request = GenerationRequestEntity(
        productName: json['product_name'] as String? ?? '',
        productDescription: json['product_description'] as String? ?? '',
        keyFeatures: const [],
        platform: platform,
        imageStyle: ImageStyle.studioWhite,
        adCopyTone: AdCopyTone.professional,
        language: 'tr',
      );
    }

    // Image objesi: backend image_url string döndürüyor, image objesi değil
    GeneratedImageModel? image;
    if (json['image'] != null && json['image'] is Map<String, dynamic>) {
      image = GeneratedImageModel.fromJson(json['image'] as Map<String, dynamic>);
    } else if (json['image_url'] != null && (json['image_url'] as String).isNotEmpty) {
      final imageUrl = json['image_url'] as String;
      image = GeneratedImageModel(
        id: json['id'] as String? ?? 'img-${DateTime.now().millisecondsSinceEpoch}',
        imageUrl: imageUrl,
        thumbnailUrl: imageUrl,
        dimensions: const ImageDimensions(width: 1024, height: 1024, label: '1:1'),
        platform: platform,
        style: ImageStyle.studioWhite,
        promptUsed: '',
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      );
    }

    // Ad copy objesi: backend flat JSON döndürüyor
    AdCopyModel? adCopy;
    if (json['ad_copy'] != null && json['ad_copy'] is Map<String, dynamic>) {
      final adJson = json['ad_copy'] as Map<String, dynamic>;
      adCopy = AdCopyModel(
        id: adJson['id'] as String? ?? 'copy-${DateTime.now().millisecondsSinceEpoch}',
        title: adJson['title'] as String? ?? '',
        description: adJson['description'] as String? ?? '',
        bulletPoints: (adJson['bullet_points'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        hashtags: (adJson['hashtags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        callToAction: adJson['call_to_action'] as String?,
        platform: platform,
        tone: AdCopyTone.professional,
        language: 'tr',
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      );
    }

    // Image URLs listesi
    final List<String>? imageUrlsList = json['image_urls'] != null
        ? (json['image_urls'] as List<dynamic>).map((e) => e.toString()).toList()
        : null;

    return GenerationResultModel(
      id: json['id'] as String,
      request: request,
      image: image,
      imageUrls: imageUrlsList,
      adCopy: adCopy,
      status: GenerationStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => GenerationStatus.pending,
      ),
      errorMessage: json['error_message'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      creditsUsed: json['credits_used'] as int? ?? 1,
    );
  }

  static GenerationRequestEntity _parseRequest(Map<String, dynamic> json) {
    return GenerationRequestEntity(
      productName: json['product_name'] as String? ?? '',
      productDescription: json['product_description'] as String? ?? '',
      productCategory: json['product_category'] as String?,
      keyFeatures: (json['key_features'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      targetAudience: json['target_audience'] as String?,
      platform: SupportedPlatform.values.firstWhere((e) => e.name == (json['platform'] as String? ?? 'shopify'), orElse: () => SupportedPlatform.shopify),
      imageStyle: ImageStyle.values.firstWhere((e) => e.name == (json['image_style'] as String? ?? 'studioWhite'), orElse: () => ImageStyle.studioWhite),
      adCopyTone: AdCopyTone.values.firstWhere((e) => e.name == (json['ad_copy_tone'] as String? ?? 'professional'), orElse: () => AdCopyTone.professional),
      language: json['language'] as String? ?? 'tr',
    );
  }
}
