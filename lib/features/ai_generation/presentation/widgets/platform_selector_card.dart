import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/platform_config_entity.dart';

class PlatformSelectorCard extends StatelessWidget {
  final PlatformConfigEntity config;
  final bool isSelected;
  final VoidCallback onTap;

  const PlatformSelectorCard({
    super.key,
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = _hexToColor(config.brandIdentity.brandColorHex);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? brandColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? brandColor : const Color(0xFFE5E3F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: brandColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : const Color(0xFFF8F7FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: _buildPlatformIcon(brandColor)),
            ),
            const SizedBox(height: 8),
            // Platform adı
            Text(
              _shortName(config.platform),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1E1B4B),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(Color brandColor) {
    final logoInfo = switch (config.platform) {
      SupportedPlatform.trendyol => ('assets/logos/platforms/trendyol.svg', true),
      SupportedPlatform.hepsiburada => ('assets/logos/platforms/hepsiburada.svg', true),
      SupportedPlatform.n11 => ('assets/logos/platforms/n11.svg', true),
      SupportedPlatform.sahibinden => ('assets/logos/platforms/sahibinden.svg', true),
      SupportedPlatform.amazonTR => ('assets/logos/platforms/amazon_tr.svg', true),
      SupportedPlatform.ciceksepeti => ('assets/logos/platforms/ciceksepeti.png', false),
      SupportedPlatform.shopify => ('assets/logos/platforms/shopify.svg', true),
      SupportedPlatform.amazon => ('assets/logos/platforms/amazon.svg', true),
      SupportedPlatform.instagramFeed => ('assets/logos/platforms/instagram_feed.svg', true),
      SupportedPlatform.instagramStory => ('assets/logos/platforms/instagram_story.svg', true),
      SupportedPlatform.tiktok => ('assets/logos/platforms/tiktok.svg', true),
      SupportedPlatform.googleShopping => ('assets/logos/platforms/google_shopping.svg', true),
      SupportedPlatform.custom => ('assets/logos/platforms/shopify.svg', true),
    };

    final path = logoInfo.$1;
    final isSvg = logoInfo.$2;

    if (isSvg) {
      return SvgPicture.asset(path, width: 30, height: 30);
    } else {
      return Image.asset(path, width: 34, height: 34, fit: BoxFit.contain);
    }
  }

  String _shortName(SupportedPlatform platform) {
    return switch (platform) {
      SupportedPlatform.trendyol => 'Trendyol',
      SupportedPlatform.hepsiburada => 'Hepsiburada',
      SupportedPlatform.n11 => 'N11',
      SupportedPlatform.sahibinden => 'Sahibinden',
      SupportedPlatform.amazonTR => 'Amazon (TR)',
      SupportedPlatform.ciceksepeti => 'Çiçeksepeti',
      SupportedPlatform.shopify => 'Shopify',
      SupportedPlatform.amazon => 'Amazon',
      SupportedPlatform.instagramFeed => 'IG Feed',
      SupportedPlatform.instagramStory => 'IG Story',
      SupportedPlatform.tiktok => 'TikTok',
      SupportedPlatform.googleShopping => 'Google Ads',
      SupportedPlatform.custom => 'Özel',
    };
  }
}
