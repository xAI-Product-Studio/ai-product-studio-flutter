import '../../domain/entities/platform_config_entity.dart';

class PlatformConfigModel extends PlatformConfigEntity {
  const PlatformConfigModel({
    required super.platform,
    required super.displayName,
    required super.description,
    required super.iconAsset,
    required super.imageDimensions,
    required super.adCopyRules,
    required super.promptSuggestions,
    required super.recommendedStyles,
    required super.brandIdentity,
  });
}

abstract class PlatformConfigFactory {
  static List<PlatformConfigModel> getAll() => [
        // ── TR Platformlar ──────────────────────────────
        _trendyol(),
        _hepsiburada(),
        _n11(),
        _sahibinden(),
        _amazonTR(),
        _ciceksepeti(),
        // ── Global Platformlar ──────────────────────────
        _shopify(),
        _amazon(),
        _instagramFeed(),
        _instagramStory(),
        _tiktok(),
        _googleShopping(),
      ];

  // ── TR Platformlar ──────────────────────────────────────────────────────────

  static PlatformConfigModel _trendyol() => const PlatformConfigModel(
        platform: SupportedPlatform.trendyol,
        displayName: 'Trendyol',
        description: 'Türkiye\'nin 1 numaralı pazaryeri — 300K+ aktif satıcı',
        iconAsset: 'assets/icons/trendyol.svg',
        imageDimensions: ImageDimensions(
          width: 2048,
          height: 2048,
          label: '1:1 (2048×2048)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 100,
          maxDescriptionLength: 3000,
          maxBulletPoints: 5,
          supportsBulletPoints: true,
          supportsEmoji: false,
          supportsHashtags: false,
          forbiddenWords: ['garantili', 'en ucuz', 'bedava'],
          copywritingFramework: 'FAB',
        ),
        promptSuggestions: [
          'Saf beyaz arka plan, ürün %85 alanı kaplasın',
          'Yumuşak stüdyo ışığı, keskin kenarlı profesyonel görsel',
          'Trendyol standartlarına uygun kare format',
        ],
        recommendedStyles: [
          ImageStyle.studioWhite,
          ImageStyle.gradient,
          ImageStyle.flatLay,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#FF6000',
          statLabel: '+%60 tıklanma',
          earningLabel: '+₺4.200/ay',
          sellerCountLabel: '300K+ satıcı',
        ),
      );

  static PlatformConfigModel _hepsiburada() => const PlatformConfigModel(
        platform: SupportedPlatform.hepsiburada,
        displayName: 'Hepsiburada',
        description: 'Türkiye\'nin köklü e-ticaret devi — 80K+ satıcı',
        iconAsset: 'assets/icons/hepsiburada.svg',
        imageDimensions: ImageDimensions(
          width: 2000,
          height: 2000,
          label: '1:1 (2000×2000)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 120,
          maxDescriptionLength: 5000,
          maxBulletPoints: 8,
          supportsBulletPoints: true,
          supportsEmoji: false,
          supportsHashtags: false,
          forbiddenWords: ['en iyi', 'garantili', 'ücretsiz'],
          copywritingFramework: 'ABCS',
        ),
        promptSuggestions: [
          'Beyaz arka plan, ürün tüm detaylarıyla görünür',
          'Çoklu açı, teknik özellikleri ön plana çıkar',
        ],
        recommendedStyles: [
          ImageStyle.studioWhite,
          ImageStyle.flatLay,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#FF6000',
          statLabel: '+%45 sepet',
          earningLabel: '+₺2.800/ay',
          sellerCountLabel: '80K+ satıcı',
        ),
      );

  static PlatformConfigModel _n11() => const PlatformConfigModel(
        platform: SupportedPlatform.n11,
        displayName: 'N11',
        description: 'Güçlü SEO altyapısıyla öne çık — 40K+ satıcı',
        iconAsset: 'assets/icons/n11.svg',
        imageDimensions: ImageDimensions(
          width: 1200,
          height: 1200,
          label: '1:1 (1200×1200)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 80,
          maxDescriptionLength: 2000,
          maxBulletPoints: 5,
          supportsBulletPoints: true,
          supportsEmoji: false,
          supportsHashtags: false,
          forbiddenWords: ['garanti', 'bedava'],
          copywritingFramework: 'FAB',
        ),
        promptSuggestions: [
          'Temiz arka plan, SEO odaklı ürün görseli',
          'Ürünün ana özelliğini vurgulayan açı',
        ],
        recommendedStyles: [
          ImageStyle.studioWhite,
          ImageStyle.gradient,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#0055A5',
          statLabel: '+%38 görünüm',
          earningLabel: '+₺1.900/ay',
          sellerCountLabel: '40K+ satıcı',
        ),
      );

  static PlatformConfigModel _sahibinden() => const PlatformConfigModel(
        platform: SupportedPlatform.sahibinden,
        displayName: 'Sahibinden',
        description: 'Türkiye\'nin en büyük ilan platformu — 500K+ ilan',
        iconAsset: 'assets/icons/sahibinden.svg',
        imageDimensions: ImageDimensions(
          width: 1600,
          height: 1200,
          label: '4:3 (1600×1200)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 60,
          maxDescriptionLength: 1500,
          maxBulletPoints: 3,
          supportsBulletPoints: false,
          supportsEmoji: false,
          supportsHashtags: false,
          forbiddenWords: [],
          copywritingFramework: 'PAS',
        ),
        promptSuggestions: [
          'Gerçekçi doğal ışık, ürün dürüst ve net görünsün',
          'Çoklu açı, alıcı güvenini artırsın',
        ],
        recommendedStyles: [
          ImageStyle.natural,
          ImageStyle.lifestyle,
          ImageStyle.flatLay,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#FFD700',
          statLabel: '3x hızlı satış',
          earningLabel: 'Daha hızlı kapan',
          sellerCountLabel: '500K+ ilan',
        ),
      );

  static PlatformConfigModel _amazonTR() => const PlatformConfigModel(
        platform: SupportedPlatform.amazonTR,
        displayName: 'Amazon TR',
        description: 'Global devle Türkiye\'de satış — A+ içerik avantajı',
        iconAsset: 'assets/icons/amazon.svg',
        imageDimensions: ImageDimensions(
          width: 2000,
          height: 2000,
          label: '1:1 (2000×2000)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 200,
          maxDescriptionLength: 2000,
          maxBulletPoints: 5,
          supportsBulletPoints: true,
          supportsEmoji: false,
          supportsHashtags: false,
          forbiddenWords: ['en iyi', 'garanti', 'ücretsiz', 'indirim'],
          copywritingFramework: 'ABCS',
        ),
        promptSuggestions: [
          'Saf beyaz (#FFFFFF) arka plan zorunlu, Amazon politikasına uygun',
          'Ürün %85 alanı kaplasın, gölge veya watermark yok',
        ],
        recommendedStyles: [
          ImageStyle.studioWhite,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#FF9900',
          statLabel: '+%10 dönüşüm',
          earningLabel: 'Global erişim',
          sellerCountLabel: 'Amazon standartları',
        ),
      );

  static PlatformConfigModel _ciceksepeti() => const PlatformConfigModel(
        platform: SupportedPlatform.ciceksepeti,
        displayName: 'Çiçeksepeti',
        description: 'Duygusal bağ kuran içerikle tekrar siparişi artır',
        iconAsset: 'assets/icons/ciceksepeti.svg',
        imageDimensions: ImageDimensions(
          width: 1500,
          height: 1500,
          label: '1:1 (1500×1500)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 80,
          maxDescriptionLength: 2000,
          maxBulletPoints: 4,
          supportsBulletPoints: true,
          supportsEmoji: true,
          supportsHashtags: false,
          forbiddenWords: [],
          copywritingFramework: 'AIDA',
        ),
        promptSuggestions: [
          'Sıcak renkler, duygusal lifestyle, hediye konsepti',
          'Çiçek ve doğal elementlerle estetik kompozisyon',
        ],
        recommendedStyles: [
          ImageStyle.lifestyle,
          ImageStyle.natural,
          ImageStyle.flatLay,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#7B2D8B',
          statLabel: '+%52 sipariş',
          earningLabel: 'Sadık müşteri',
          sellerCountLabel: '20K+ satıcı',
        ),
      );

  // ── Global Platformlar ──────────────────────────────────────────────────────

  static PlatformConfigModel _shopify() => const PlatformConfigModel(
        platform: SupportedPlatform.shopify,
        displayName: 'Shopify',
        description: 'E-ticaret mağazanız için ürün görseli ve açıklaması',
        iconAsset: 'assets/icons/shopify.svg',
        imageDimensions: ImageDimensions(
          width: 2048,
          height: 2048,
          label: '1:1 (2048×2048)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 70,
          maxDescriptionLength: 5000,
          maxBulletPoints: 5,
          supportsBulletPoints: true,
          supportsEmoji: false,
          supportsHashtags: false,
          copywritingFramework: 'FAB',
        ),
        promptSuggestions: [
          'Beyaz arka plan üzerinde stüdyo kalitesinde',
          'Yumuşak gölgeler ile profesyonel ürün fotoğrafı',
        ],
        recommendedStyles: [
          ImageStyle.studioWhite,
          ImageStyle.gradient,
          ImageStyle.flatLay,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#96BF48',
          statLabel: 'Global satış',
          earningLabel: 'Kendi mağazan',
          sellerCountLabel: '2M+ mağaza',
        ),
      );

  static PlatformConfigModel _amazon() => const PlatformConfigModel(
        platform: SupportedPlatform.amazon,
        displayName: 'Amazon',
        description: 'Amazon listeleme standartlarına uygun içerik',
        iconAsset: 'assets/icons/amazon.svg',
        imageDimensions: ImageDimensions(
          width: 2000,
          height: 2000,
          label: '1:1 (2000×2000)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 200,
          maxDescriptionLength: 2000,
          maxBulletPoints: 5,
          supportsBulletPoints: true,
          supportsEmoji: false,
          supportsHashtags: false,
          forbiddenWords: ['en iyi', 'garanti', 'ücretsiz'],
          copywritingFramework: 'ABCS',
        ),
        promptSuggestions: [
          'Saf beyaz (#FFFFFF) arka plan, Amazon politikasına uygun',
        ],
        recommendedStyles: [ImageStyle.studioWhite],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#FF9900',
          statLabel: 'Global erişim',
          earningLabel: 'Prime müşteri',
          sellerCountLabel: 'Global #1',
        ),
      );

  static PlatformConfigModel _instagramFeed() => const PlatformConfigModel(
        platform: SupportedPlatform.instagramFeed,
        displayName: 'Instagram Feed',
        description: 'Feed için estetik kare görsel ve caption',
        iconAsset: 'assets/icons/instagram.svg',
        imageDimensions: ImageDimensions(
          width: 1080,
          height: 1080,
          label: '1:1 (1080×1080)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 125,
          maxDescriptionLength: 2200,
          maxBulletPoints: 3,
          supportsBulletPoints: false,
          supportsEmoji: true,
          supportsHashtags: true,
          maxHashtags: 30,
          copywritingFramework: 'AIDA',
        ),
        promptSuggestions: [
          'Lifestyle fotoğraf, doğal ışık, estetik kompozisyon',
        ],
        recommendedStyles: [
          ImageStyle.lifestyle,
          ImageStyle.flatLay,
          ImageStyle.natural,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#E1306C',
          statLabel: '+%40 etkileşim',
          earningLabel: 'Marka bilinirliği',
          sellerCountLabel: '2B+ kullanıcı',
        ),
      );

  static PlatformConfigModel _instagramStory() => const PlatformConfigModel(
        platform: SupportedPlatform.instagramStory,
        displayName: 'Instagram Story',
        description: 'Story formatı için dikey görsel ve swipe-up metni',
        iconAsset: 'assets/icons/instagram.svg',
        imageDimensions: ImageDimensions(
          width: 1080,
          height: 1920,
          label: '9:16 (1080×1920)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 80,
          maxDescriptionLength: 500,
          maxBulletPoints: 3,
          supportsBulletPoints: false,
          supportsEmoji: true,
          supportsHashtags: true,
          maxHashtags: 10,
          copywritingFramework: 'PAS',
        ),
        promptSuggestions: [
          'Dikey kompozisyon, üst ve alt boşluk metin alanı için',
        ],
        recommendedStyles: [
          ImageStyle.gradient,
          ImageStyle.dramatic,
          ImageStyle.lifestyle,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#E1306C',
          statLabel: 'Swipe-up',
          earningLabel: 'Anlık satış',
          sellerCountLabel: 'Story formatı',
        ),
      );

  static PlatformConfigModel _tiktok() => const PlatformConfigModel(
        platform: SupportedPlatform.tiktok,
        displayName: 'TikTok',
        description: 'TikTok Shop ve reklam için dikkat çekici içerik',
        iconAsset: 'assets/icons/tiktok.svg',
        imageDimensions: ImageDimensions(
          width: 1080,
          height: 1920,
          label: '9:16 (1080×1920)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 100,
          maxDescriptionLength: 800,
          maxBulletPoints: 3,
          supportsBulletPoints: false,
          supportsEmoji: true,
          supportsHashtags: true,
          maxHashtags: 5,
          copywritingFramework: 'HOOK',
        ),
        promptSuggestions: [
          'Enerjik, genç, trend-forward estetik',
        ],
        recommendedStyles: [
          ImageStyle.lifestyle,
          ImageStyle.dramatic,
          ImageStyle.natural,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#010101',
          statLabel: 'Viral potansiyel',
          earningLabel: 'Gen-Z erişimi',
          sellerCountLabel: '1B+ kullanıcı',
        ),
      );

  static PlatformConfigModel _googleShopping() => const PlatformConfigModel(
        platform: SupportedPlatform.googleShopping,
        displayName: 'Google Shopping',
        description: 'Google Alışveriş reklamları için optimize içerik',
        iconAsset: 'assets/icons/google_shopping.svg',
        imageDimensions: ImageDimensions(
          width: 800,
          height: 800,
          label: '1:1 (800×800)',
        ),
        adCopyRules: AdCopyRules(
          maxTitleLength: 150,
          maxDescriptionLength: 5000,
          maxBulletPoints: 0,
          supportsBulletPoints: false,
          supportsEmoji: false,
          supportsHashtags: false,
          copywritingFramework: 'FAB',
        ),
        promptSuggestions: [
          'Beyaz veya açık gri arka plan, yüksek netlik',
        ],
        recommendedStyles: [
          ImageStyle.studioWhite,
          ImageStyle.gradient,
        ],
        brandIdentity: PlatformBrandIdentity(
          brandColorHex: '#4285F4',
          statLabel: 'Arama üstü',
          earningLabel: 'Yüksek niyet',
          sellerCountLabel: 'Google trafiği',
        ),
      );

  /// TR platformlarını döner — generation sayfasında önce gösterilir
  static List<PlatformConfigModel> getTRPlatforms() => [
        _trendyol(),
        _hepsiburada(),
        _n11(),
        _sahibinden(),
        _amazonTR(),
        _ciceksepeti(),
      ];

  /// Global platformları döner
  static List<PlatformConfigModel> getGlobalPlatforms() => [
        _shopify(),
        _amazon(),
        _instagramFeed(),
        _instagramStory(),
        _tiktok(),
        _googleShopping(),
      ];
}
