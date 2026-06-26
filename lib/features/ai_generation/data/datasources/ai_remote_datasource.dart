import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/generation_request_entity.dart';
import '../../domain/entities/generation_result_entity.dart';
import '../../domain/entities/platform_config_entity.dart';
import '../models/generation_result_model.dart';
import '../models/platform_config_model.dart';

abstract interface class AiRemoteDataSource {
  Future<GenerationResultModel> generateAll({required GenerationRequestEntity request});
  Future<GenerationResultModel> generateImage({required GenerationRequestEntity request});
  Future<GenerationResultModel> generateAdCopy({required GenerationRequestEntity request});
  Future<({List<GenerationResultModel> results, int total})> getHistory({int page = 1, int limit = 20, SupportedPlatform? platformFilter});
  Future<GenerationResultModel> getGenerationById({required String id});
  Future<void> toggleFavorite({required String id, required bool isFavorite});
}

@LazySingleton(as: AiRemoteDataSource)
class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final DioClient _dioClient;
  const AiRemoteDataSourceImpl(this._dioClient);

  @override
  Future<GenerationResultModel> generateAll({required GenerationRequestEntity request}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.generate,
        data: _buildRequestPayload(request),
      );

      final data = response.data!;
      final status = data['status']?.toString().toLowerCase() ?? '';
      final generationId = data['id']?.toString() ?? '';

      // Backend 200 + completed dönerse direkt parse et
      if (status == 'completed' && generationId.isNotEmpty) {
        return GenerationResultModel.fromJson(data);
      }

      // 202 + processing → polling yap
      if (generationId.isEmpty) {
        throw const AiServiceException(message: 'Sunucu generation ID döndürmedi.');
      }

      // Polling: 3 saniyede bir, max 90 saniye
      for (int i = 0; i < 30; i++) {
        await Future.delayed(const Duration(seconds: 3));

        final pollResponse = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.generationStatus(generationId),
        );

        final pollData = pollResponse.data!;
        final pollStatus = pollData['status']?.toString().toLowerCase() ?? '';

        if (pollStatus == 'completed' || pollStatus == 'done') {
          return GenerationResultModel.fromJson(pollData);
        }

        if (pollStatus == 'failed' || pollStatus == 'error') {
          throw AiServiceException(
            message: pollData['error_message']?.toString() ?? 'Üretim başarısız oldu.',
          );
        }
      }

      throw const AiServiceException(message: 'Üretim zaman aşımına uğradı. Tekrar deneyin.');
    } on AiServiceException { rethrow; }
    on ServerException { rethrow; }
    on NetworkException { return _buildMockGeneration(request); }
    catch (e) {
      throw AiServiceException(message: 'Beklenmedik hata: $e');
    }
  }

  @override
  Future<GenerationResultModel> generateImage({required GenerationRequestEntity request}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.generate, data: _buildRequestPayload(request, imageOnly: true));
      return GenerationResultModel.fromJson(response.data!);
    } on NetworkException {
      return _buildMockGeneration(request);
    } on AiServiceException { rethrow; } on ServerException { rethrow; }
    catch (e) {
      if (e is NetworkException) {
        return _buildMockGeneration(request);
      }
      throw const AiServiceException(message: 'Görsel üretimi sırasında bir hata oluştu.');
    }
  }

  @override
  Future<GenerationResultModel> generateAdCopy({required GenerationRequestEntity request}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.generate, data: _buildRequestPayload(request, adCopyOnly: true));
      return GenerationResultModel.fromJson(response.data!);
    } on NetworkException {
      return _buildMockGeneration(request);
    } on AiServiceException { rethrow; } on ServerException { rethrow; }
    catch (e) {
      if (e is NetworkException) {
        return _buildMockGeneration(request);
      }
      throw const AiServiceException(message: 'Reklam metni üretimi sırasında bir hata oluştu.');
    }
  }

  @override
  Future<({List<GenerationResultModel> results, int total})> getHistory({int page = 1, int limit = 20, SupportedPlatform? platformFilter}) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(ApiEndpoints.generationHistory,
        queryParameters: {'page': page, 'limit': limit, if (platformFilter != null) 'platform': platformFilter.name});
      final items = response.data!['results'] as List<dynamic>;
      final parsed = <GenerationResultModel>[];
      for (final e in items) {
        try {
          parsed.add(GenerationResultModel.fromJson(e as Map<String, dynamic>));
        } catch (parseError) {
          print('PARSE ERROR: $parseError');
          print('ITEM: $e');
        }
      }
      return (results: parsed, total: response.data!['total'] as int? ?? parsed.length);
    } on NetworkException {
      final mock = _buildMockHistory(); return (results: mock, total: mock.length);
    } on ServerException { rethrow; }
    catch (e) {
      if (e is NetworkException) {
        final mock = _buildMockHistory(); return (results: mock, total: mock.length);
      }
      throw const ServerException(message: 'Geçmiş veriler alınırken bir hata oluştu.');
    }
  }

  @override
  Future<GenerationResultModel> getGenerationById({required String id}) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(ApiEndpoints.generationById(id));
      return GenerationResultModel.fromJson(response.data!);
    } on NetworkException {
      return _buildMockHistory().firstWhere(
        (e) => e.id == id,
        orElse: () => _buildMockGeneration(const GenerationRequestEntity(
          productName: 'Mock Ürün',
          productDescription: 'Mock Açıklama',
          platform: SupportedPlatform.shopify,
          imageStyle: ImageStyle.studioWhite,
          adCopyTone: AdCopyTone.professional,
          language: 'tr',
          keyFeatures: [],
        )),
      );
    } on ServerException { rethrow; }
    catch (e) {
      if (e is NetworkException) {
        return _buildMockHistory().firstWhere(
          (e) => e.id == id,
          orElse: () => _buildMockGeneration(const GenerationRequestEntity(
            productName: 'Mock Ürün',
            productDescription: 'Mock Açıklama',
            platform: SupportedPlatform.shopify,
            imageStyle: ImageStyle.studioWhite,
            adCopyTone: AdCopyTone.professional,
            language: 'tr',
            keyFeatures: [],
          )),
        );
      }
      throw const ServerException(message: 'Üretim detayları alınamadı.');
    }
  }

  @override
  Future<void> toggleFavorite({required String id, required bool isFavorite}) async {
    try {
      await _dioClient.patch<void>(ApiEndpoints.generationById(id), data: {'is_favorited': isFavorite});
    } on NetworkException {
      return;
    } on ServerException { rethrow; }
    catch (e) {
      if (e is NetworkException) return;
      throw const ServerException(message: 'Favori durumu güncellenemedi.');
    }
  }

  List<GenerationResultModel> _buildMockHistory() {
    final now = DateTime.now();
    return [
      GenerationResultModel(
        id: 'mock-1',
        status: GenerationStatus.completed,
        createdAt: now.subtract(const Duration(hours: 1)),
        creditsUsed: 1,
        request: const GenerationRequestEntity(
          productName: 'Deri Bileklik',
          productDescription: 'Hakiki deri el yapımı şık bileklik.',
          keyFeatures: ['El yapımı', 'Hakiki deri', 'Ayarlanabilir klips'],
          platform: SupportedPlatform.shopify,
          imageStyle: ImageStyle.studioWhite,
          adCopyTone: AdCopyTone.professional,
          language: 'tr',
        ),
        image: GeneratedImageModel(
          id: 'mock-img-1',
          imageUrl: 'https://picsum.photos/seed/leather/500',
          thumbnailUrl: 'https://picsum.photos/seed/leather/200',
          dimensions: const ImageDimensions(width: 1024, height: 1024, label: '1:1'),
          platform: SupportedPlatform.shopify,
          style: ImageStyle.studioWhite,
          promptUsed: 'Hakiki deri el yapımı bileklik, beyaz stüdyo arka planı.',
          createdAt: now.subtract(const Duration(hours: 1)),
          isFavorited: false,
        ),
        adCopy: AdCopyModel(
          id: 'mock-copy-1',
          title: 'Şıklığı ve Doğallığı Hissedin',
          description: 'Her anınıza eşlik edecek hakiki deri el yapımı bilekliğimiz şimdi Shopify mağazamızda!',
          bulletPoints: const ['%100 Hakiki Deri', 'El emeği tasarım', 'Zarif ve dayanıklı'],
          hashtags: const ['deribileklik', 'elyapimi', 'tarz'],
          callToAction: 'Hemen Keşfet',
          platform: SupportedPlatform.shopify,
          tone: AdCopyTone.professional,
          language: 'tr',
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
      ),
      GenerationResultModel(
        id: 'mock-2',
        status: GenerationStatus.completed,
        createdAt: now.subtract(const Duration(hours: 2)),
        creditsUsed: 1,
        request: const GenerationRequestEntity(
          productName: 'Organik Sabun',
          productDescription: 'Doğal zeytinyağlı organik sabun.',
          keyFeatures: ['Doğal içerik', 'Zeytinyağlı', 'Kimyasal içermez'],
          platform: SupportedPlatform.instagramFeed,
          imageStyle: ImageStyle.lifestyle,
          adCopyTone: AdCopyTone.friendly,
          language: 'tr',
        ),
        image: GeneratedImageModel(
          id: 'mock-img-2',
          imageUrl: 'https://picsum.photos/seed/soap/500',
          thumbnailUrl: 'https://picsum.photos/seed/soap/200',
          dimensions: const ImageDimensions(width: 1024, height: 1024, label: '1:1'),
          platform: SupportedPlatform.instagramFeed,
          style: ImageStyle.lifestyle,
          promptUsed: 'Doğal organik sabun, banyo ortamında lifestyle fotoğraf.',
          createdAt: now.subtract(const Duration(hours: 2)),
          isFavorited: true,
        ),
        adCopy: AdCopyModel(
          id: 'mock-copy-2',
          title: 'Cildiniz İçin En Doğalı',
          description: 'Zeytinyağı özlü el yapımı sabunumuzla cildinize hak ettiği değeri verin. Doğallığın ferahlığını hissedin.',
          bulletPoints: const ['Kimyasal içermez', 'Derinlemesine nemlendirir', 'Hassas ciltler için uygun'],
          hashtags: const ['organiksabun', 'dogalguzellik', 'bakim'],
          callToAction: 'Profildeki Linke Tıkla',
          platform: SupportedPlatform.instagramFeed,
          tone: AdCopyTone.friendly,
          language: 'tr',
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
      ),
      GenerationResultModel(
        id: 'mock-3',
        status: GenerationStatus.completed,
        createdAt: now.subtract(const Duration(hours: 3)),
        creditsUsed: 1,
        request: const GenerationRequestEntity(
          productName: 'Ahşap Saat',
          productDescription: 'Minimalist ceviz ağacı ahşap duvar saati.',
          keyFeatures: ['Ceviz ağacı', 'Minimalist tasarım', 'Sessiz mekanizma'],
          platform: SupportedPlatform.amazon,
          imageStyle: ImageStyle.flatLay,
          adCopyTone: AdCopyTone.luxurious,
          language: 'tr',
        ),
        image: GeneratedImageModel(
          id: 'mock-img-3',
          imageUrl: 'https://picsum.photos/seed/clock/500',
          thumbnailUrl: 'https://picsum.photos/seed/clock/200',
          dimensions: const ImageDimensions(width: 1024, height: 1024, label: '1:1'),
          platform: SupportedPlatform.amazon,
          style: ImageStyle.flatLay,
          promptUsed: 'Ahşap duvar saati, üstten görünüm flat lay kompozisyon.',
          createdAt: now.subtract(const Duration(hours: 3)),
          isFavorited: false,
        ),
        adCopy: AdCopyModel(
          id: 'mock-copy-3',
          title: 'Zamanın Doğal Dokunuşu',
          description: 'Ceviz ağacından üretilen sessiz mekanizmalı ahşap duvar saati ile evinizde sıcak ve modern bir hava yaratın.',
          bulletPoints: const ['Sessiz akar mekanizma', 'Gerçek ceviz ağacı', 'El işçiliği'],
          hashtags: const ['ahşapsaat', 'evdekorasyonu', 'minimalist'],
          callToAction: 'Sepete Ekle',
          platform: SupportedPlatform.amazon,
          tone: AdCopyTone.luxurious,
          language: 'tr',
          createdAt: now.subtract(const Duration(hours: 3)),
        ),
      ),
    ];
  }

  GenerationResultModel _buildMockGeneration(GenerationRequestEntity request) {
    final now = DateTime.now();
    return GenerationResultModel(
      id: 'mock-gen-${now.millisecondsSinceEpoch}',
      status: GenerationStatus.completed,
      createdAt: now,
      creditsUsed: 1,
      request: request,
      image: GeneratedImageModel(
        id: 'mock-img-${now.millisecondsSinceEpoch}',
        imageUrl: 'https://picsum.photos/seed/${request.productName}/500',
        thumbnailUrl: 'https://picsum.photos/seed/${request.productName}/200',
        dimensions: const ImageDimensions(width: 1024, height: 1024, label: '1:1'),
        platform: request.platform,
        style: request.imageStyle,
        promptUsed: 'Mock prompt for ${request.productName}',
        createdAt: now,
      ),
      adCopy: AdCopyModel(
        id: 'mock-copy-${now.millisecondsSinceEpoch}',
        title: 'Mock Title for ${request.productName}',
        description: 'Mock Description for ${request.productName}: ${request.productDescription}',
        bulletPoints: request.keyFeatures.isNotEmpty ? request.keyFeatures : const ['Mock Feature 1', 'Mock Feature 2'],
        hashtags: const ['mock', 'product'],
        callToAction: 'Shop Now',
        platform: request.platform,
        tone: request.adCopyTone,
        language: request.language,
        createdAt: now,
      ),
    );
  }

  Map<String, dynamic> _buildRequestPayload(GenerationRequestEntity request, {bool imageOnly = false, bool adCopyOnly = false}) {
    return {
      'product_name': request.productName,
      'product_description': request.productDescription,
      if (request.productCategory != null) 'product_category': request.productCategory,
      'key_features': request.keyFeatures,
      if (request.targetAudience != null) 'target_audience': request.targetAudience,
      'platform': _toSnakeCase(request.platform.name),
      'image_style': _toSnakeCase(request.imageStyle.name),
      'ad_copy_tone': _toSnakeCase(request.adCopyTone.name),
      'language': request.language,
      'image_prompt': _buildImagePrompt(request),
      'ad_copy_system_prompt': _buildCopyPrompt(request),
      if (request.customPromptAddition != null) 'custom_prompt_addition': request.customPromptAddition,
      if (request.referenceImageBase64 != null) 'reference_image': request.referenceImageBase64,
      'generate_image': !adCopyOnly,
      'generate_ad_copy': !imageOnly,
    };
  }

  String _buildImagePrompt(GenerationRequestEntity request) {
    final styleDirective = switch (request.imageStyle) {
      ImageStyle.studioWhite => 'Pure white background, soft studio lighting, subtle shadow.',
      ImageStyle.lifestyle => 'Lifestyle setting, natural environment, warm ambient lighting.',
      ImageStyle.flatLay => 'Flat lay composition, top-down perspective, clean surface.',
      ImageStyle.gradient => 'Smooth gradient background, modern aesthetic, product centered.',
      ImageStyle.natural => 'Natural daylight, organic textures, authentic feel.',
      ImageStyle.dramatic => 'Dramatic studio lighting, strong contrast, dark moody background.',
    };
    final platformDirective = switch (request.platform) {
      SupportedPlatform.trendyol => 'Square 1:1 ratio (2048×2048), pure white background, product fills 85% of frame, sharp studio lighting.',
      SupportedPlatform.hepsiburada => 'Square 1:1 ratio (2000×2000), white background, product fully visible with all details.',
      SupportedPlatform.n11 => 'Square 1:1 ratio (1200×1200), clean background, SEO-optimized product image.',
      SupportedPlatform.sahibinden => '4:3 ratio (1600×1200), natural realistic lighting, honest and clear product presentation.',
      SupportedPlatform.amazonTR => 'Square 1:1 ratio (2000×2000), pure white (#FFFFFF) background mandatory, product fills 85%, no shadow or watermark.',
      SupportedPlatform.ciceksepeti => 'Square 1:1 ratio (1500×1500), warm colors, emotional lifestyle, gift concept aesthetic.',
      SupportedPlatform.shopify => 'Square format 1:1 ratio, product fills 80% of frame.',
      SupportedPlatform.amazon => 'Pure white background mandatory, product fills 85% of frame, no props.',
      SupportedPlatform.instagramFeed => 'Square 1:1 composition, visually appealing, feed-aesthetic colors.',
      SupportedPlatform.instagramStory => 'Vertical 9:16 format, product centered, space at top and bottom.',
      SupportedPlatform.tiktok => 'Vertical 9:16 format, eye-catching, energetic composition.',
      SupportedPlatform.googleShopping => 'Clean white background, product alone, high clarity.',
      SupportedPlatform.custom => 'Professional product photography, clean background.',
    };
    return 'Professional product photography of "${request.productName}". ${request.productDescription}. $styleDirective $platformDirective High resolution, sharp focus, commercial quality. No text, no watermarks, no people.';
  }

  String _buildCopyPrompt(GenerationRequestEntity request) {
    final configs = PlatformConfigFactory.getAll();
    final config = configs.firstWhere((c) => c.platform == request.platform);
    final toneDirective = switch (request.adCopyTone) {
      AdCopyTone.professional => 'Professional, authoritative, trust-building language.',
      AdCopyTone.friendly => 'Warm, conversational, approachable tone.',
      AdCopyTone.urgent => 'Urgency-driven, scarcity hints, action-oriented language.',
      AdCopyTone.luxurious => 'Premium, sophisticated, exclusive language.',
      AdCopyTone.playful => 'Fun, energetic, creative language.',
      AdCopyTone.minimalist => 'Clean, direct, no fluff. Short sentences.',
    };
    return 'You are an expert copywriter for ${config.displayName}. Language: ${request.language == "tr" ? "Turkish" : "English"}. Product: ${request.productName}. TONE: $toneDirective. Title max ${config.adCopyRules.maxTitleLength} chars. Return JSON only: {"title":"...","description":"...","bullet_points":[...],"hashtags":[...],"call_to_action":"..."}';
  }

  String _toSnakeCase(String input) {
    return input.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}
