import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../domain/entities/ad_copy_entity.dart';
import '../../domain/entities/generation_result_entity.dart';
import '../../domain/entities/platform_config_entity.dart';

class ResultPage extends StatelessWidget {
  final String generationId;

  const ResultPage({super.key, required this.generationId});

  @override
  Widget build(BuildContext context) {
    final extra =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    final result = extra?['result'] as GenerationResultEntity?;

    if (result == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                Gap(16.h),
                const Text('Sonuç verisi bulunamadı.'),
                Gap(24.h),
                AppButton(
                  label: 'Geri Dön',
                  onPressed: () => context.go(AppRoutes.generate),
                  width: 200.w,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              children: [
                _buildHeader(context, colorScheme),
                Gap(24.h),
                _buildPlatformBadge(context, result.request.platform),
                Gap(16.h),
                if (result.image != null) ...[
                  _buildSectionTitle('🖼️ Üretilen Görsel', context),
                  Gap(12.h),
                  _buildGeneratedImage(context, result),
                  Gap(24.h),
                ],
                if (result.adCopy != null) ...[
                  _buildSectionTitle('✍️ Reklam Metni', context),
                  Gap(12.h),
                  _buildAdCopyCard(context, result.adCopy!),
                  Gap(24.h),
                ],
                _buildMetaInfo(context, result),
                Gap(16.h),
                if (result.creditsUsed > 0)
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.dashboard),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.2)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.bolt_rounded, size: 18, color: Color(0xFF7C3AED)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kredilerin azalıyor mu? Pro plana geç, sınırsız üret!',
                              style: TextStyle(fontSize: 13, color: Color(0xFF7C3AED), fontWeight: FontWeight.w500),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF7C3AED)),
                        ],
                      ),
                    ),
                  ),
                Gap(32.h),
                AppButton(
                  label: 'Yeni İçerik Üret',
                  onPressed: () => context.go(AppRoutes.generate),
                  leadingIcon: Icons.auto_awesome_rounded,
                ),
                Gap(12.h),
                AppButton(
                  label: 'Geçmişe Göz At',
                  onPressed: () => context.go(AppRoutes.dashboard),
                  isOutlined: true,
                ),
                Gap(32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go(AppRoutes.generate),
          child: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16.sp,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Üretim Sonucu',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Görsel ve reklam metni hazır',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.share_outlined,
            size: 20.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          onPressed: () => ErrorSnackbar.showInfo(
            context,
            message: 'Paylaşım özelliği yakında!',
          ),
        ),
      ],
    );
  }

  // ── Section Title ─────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
    );
  }

  // ── Platform Badge ────────────────────────────────────────────────────────

  Widget _buildPlatformBadge(
    BuildContext context,
    SupportedPlatform platform,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = switch (platform) {
      SupportedPlatform.trendyol => 'Trendyol',
      SupportedPlatform.hepsiburada => 'Hepsiburada',
      SupportedPlatform.n11 => 'N11',
      SupportedPlatform.sahibinden => 'Sahibinden',
      SupportedPlatform.amazonTR => 'Amazon TR',
      SupportedPlatform.ciceksepeti => 'Çiçeksepeti',
      SupportedPlatform.shopify => 'Shopify',
      SupportedPlatform.amazon => 'Amazon',
      SupportedPlatform.instagramFeed => 'Instagram Feed',
      SupportedPlatform.instagramStory => 'Instagram Story',
      SupportedPlatform.tiktok => 'TikTok',
      SupportedPlatform.googleShopping => 'Google Shopping',
      SupportedPlatform.custom => 'Özel',
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 16.sp,
            color: colorScheme.primary,
          ),
          Gap(6.w),
          Text(
            '$label için optimize edildi',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Generated Image ───────────────────────────────────────────────────────

  Widget _buildGeneratedImage(
    BuildContext context,
    GenerationResultEntity result,
  ) {
    final image = result.image!;
    final urls = result.imageUrls ?? [image.imageUrl];
    final labels = ['Stüdyo', 'Lifestyle', 'Varyant 3'];

    return _VariantViewer(urls: urls, labels: labels);
  }

  // ── Ad Copy Card ──────────────────────────────────────────────────────────

  Widget _buildAdCopyCard(BuildContext context, AdCopyEntity adCopy) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color:
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  adCopy.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () =>
                    _copyToClipboard(context, adCopy.title),
                icon: Icon(Icons.copy_rounded, size: 18.sp),
                tooltip: 'Başlığı kopyala',
              ),
            ],
          ),
          Divider(height: 20.h, color: colorScheme.outlineVariant),
          Text(
            adCopy.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (adCopy.bulletPoints.isNotEmpty) ...[
            Gap(12.h),
            ...adCopy.bulletPoints.map(
              (point) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      size: 16.sp,
                      color: colorScheme.primary,
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Text(
                        point,
                        style:
                            Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (adCopy.hashtags.isNotEmpty) ...[
            Gap(12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: adCopy.hashtags
                  .map(
                    (tag) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        tag.startsWith('#') ? tag : '#$tag',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (adCopy.callToAction != null) ...[
            Gap(16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.sp,
                    color: colorScheme.primary,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      adCopy.callToAction!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Gap(12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _copyAllCopy(context, adCopy),
              icon: Icon(Icons.copy_all_rounded, size: 16.sp),
              label: const Text('Tüm Metni Kopyala'),
            ),
          ),
        ],
      ),
    );
  }

  // ── Meta Info ─────────────────────────────────────────────────────────────

  Widget _buildMetaInfo(
    BuildContext context,
    GenerationResultEntity result,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetaItem(
            context,
            icon: Icons.bolt_rounded,
            label: 'Kredi',
            value: '${result.creditsUsed}',
          ),
          _buildMetaItem(
            context,
            icon: Icons.access_time_rounded,
            label: 'Tarih',
            value:
                '${result.createdAt.day}.${result.createdAt.month.toString().padLeft(2, '0')}.${result.createdAt.year}',
          ),
          _buildMetaItem(
            context,
            icon: Icons.check_circle_outline_rounded,
            label: 'Durum',
            value: 'Tamamlandı',
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: Theme.of(context).colorScheme.primary,
        ),
        Gap(4.h),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
        ),
      ],
    );
  }

  // ── Clipboard ─────────────────────────────────────────────────────────────

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ErrorSnackbar.showSuccess(context, message: 'Panoya kopyalandı!');
  }

  void _copyAllCopy(BuildContext context, AdCopyEntity adCopy) {
    final buffer = StringBuffer()
      ..writeln(adCopy.title)
      ..writeln()
      ..writeln(adCopy.description);
    if (adCopy.bulletPoints.isNotEmpty) {
      buffer.writeln();
      for (final point in adCopy.bulletPoints) {
        buffer.writeln('• $point');
      }
    }
    if (adCopy.hashtags.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(
        adCopy.hashtags
            .map((t) => t.startsWith('#') ? t : '#$t')
            .join(' '),
      );
    }
    if (adCopy.callToAction != null) {
      buffer.writeln(adCopy.callToAction);
    }
    _copyToClipboard(context, buffer.toString());
  }
}

class _VariantViewer extends StatefulWidget {
  final List<String> urls;
  final List<String> labels;
  const _VariantViewer({required this.urls, required this.labels});

  @override
  State<_VariantViewer> createState() => _VariantViewerState();
}

class _VariantViewerState extends State<_VariantViewer> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final label = _index < widget.labels.length ? widget.labels[_index] : 'Görsel';

    return Column(
      children: [
        // Tab bar
        if (widget.urls.length > 1)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(widget.urls.length, (i) {
                final active = i == _index;
                final lbl = i < widget.labels.length ? widget.labels[i] : 'Varyant ${i + 1}';
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _index = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF7C3AED) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        lbl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          color: active ? Colors.white : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

        // Görsel
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  widget.urls[_index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFF5F3FF),
                      child: const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED), strokeWidth: 2)),
                    );
                  },
                  errorBuilder: (context, error, stack) => Container(
                    color: const Color(0xFFFEF2F2),
                    child: const Center(child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.red)),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // İndir butonu
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () async {
              final url = widget.urls[_index];
              // Cross-origin görsel için fetch + blob yöntemi
              try {
                final response = await html.HttpRequest.request(
                  url,
                  responseType: 'blob',
                );
                final blob = response.response as html.Blob;
                final objectUrl = html.Url.createObjectUrlFromBlob(blob);
                final anchor = html.AnchorElement(href: objectUrl)
                  ..setAttribute('download', 'titlora_${label.toLowerCase()}.png');
                html.document.body!.children.add(anchor);
                anchor.click();
                anchor.remove();
                html.Url.revokeObjectUrl(objectUrl);
              } catch (e) {
                // Fallback: yeni sekmede aç
                html.window.open(url, '_blank');
              }
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: Text('$label İndir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C1D95),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
