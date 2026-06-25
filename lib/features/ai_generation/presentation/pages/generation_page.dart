import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

import '../../domain/entities/platform_config_entity.dart';
import '../bloc/ai_generation_bloc.dart';
import '../bloc/ai_generation_event.dart';
import '../bloc/ai_generation_state.dart';
import '../widgets/platform_selector_card.dart';

class GenerationPage extends StatefulWidget {
  const GenerationPage({super.key});

  @override
  State<GenerationPage> createState() => _GenerationPageState();
}

class _GenerationPageState extends State<GenerationPage> {
  final _productNameController = TextEditingController();
  final _productDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  XFile? _selectedImage;
  SupportedPlatform _selectedPlatform = SupportedPlatform.trendyol;
  AdCopyTone _selectedTone = AdCopyTone.professional;
  int _descCharCount = 0;
  bool _isFormReady = false;

  final List<AdCopyTone> _tones = [
    AdCopyTone.professional,
    AdCopyTone.friendly,
    AdCopyTone.urgent,
    AdCopyTone.luxurious,
    AdCopyTone.playful,
    AdCopyTone.minimalist,
  ];

  final Map<AdCopyTone, String> _toneEmoji = {
    AdCopyTone.professional: '👔',
    AdCopyTone.friendly: '😊',
    AdCopyTone.urgent: '⚡',
    AdCopyTone.luxurious: '💎',
    AdCopyTone.playful: '🎯',
    AdCopyTone.minimalist: '◆',
  };

  final Map<AdCopyTone, String> _toneLabel = {
    AdCopyTone.professional: 'Profesyonel',
    AdCopyTone.friendly: 'Samimi',
    AdCopyTone.urgent: 'Acil',
    AdCopyTone.luxurious: 'Lüks',
    AdCopyTone.playful: 'Doğrudan',
    AdCopyTone.minimalist: 'Minimal',
  };

  @override
  void initState() {
    super.initState();
    context.read<AiGenerationBloc>().add(const AiGenerationConfigsRequested());
    _productNameController.addListener(_checkFormReady);
    _productDescController.addListener(_checkFormReady);
  }

  void _checkFormReady() {
    final nameOk = _productNameController.text.trim().length > 2;
    final descOk = _productDescController.text.trim().length > 10;
    final ready = (nameOk && descOk) || _selectedImage != null;
    if (ready != _isFormReady) setState(() => _isFormReady = ready);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 90,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _isFormReady = true;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _checkFormReady();
    });
  }

  void _startGeneration() {
    if (!_isFormReady) return;
    context.read<AiGenerationBloc>().add(
          AiGenerationStarted(
            productName: _productNameController.text.trim(),
            productDescription: _productDescController.text.trim(),
            platform: _selectedPlatform,
            tone: _selectedTone,
            imagePath: _selectedImage?.path,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiGenerationBloc, AiGenerationState>(
      listener: (context, state) {
        if (state is AiGenerationSuccess) {
          context.pushNamed(
            AppRoutes.resultName,
            extra: {'result': state.result},
          );
        }
        if (state is AiGenerationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF8F7FF),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                  onPressed: () => Navigator.pop(context),
                  color: const Color(0xFF1E1B4B),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'İçerik Üret',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E1B4B),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'AI ile 30 saniyede profesyonel içerik',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0.5),
                  child: Container(height: 0.5, color: const Color(0xFFE5E3F0)),
                ),
              ),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FILE UPLOADER
                          _buildFileUploader(),
                          Gap(20.h),

                          // PLATFORM SEÇİMİ
                          _buildSectionLabel('Platform Seçin'),
                          Gap(10.h),
                          _buildPlatformSelector(state),
                          Gap(20.h),

                          // ÜRÜN ADI
                          _buildSectionLabel('Ürün Adı', required: true),
                          Gap(8.h),
                          _buildProductNameField(),
                          Gap(16.h),

                          // ÜRÜN AÇIKLAMASI
                          _buildSectionLabel('Ürün Açıklaması'),
                          Gap(8.h),
                          _buildDescriptionField(),
                          Gap(16.h),

                          // METIN TONU
                          _buildSectionLabel('Metin Tonu'),
                          Gap(10.h),
                          _buildToneGrid(),
                          Gap(20.h),

                          // TRUST ROW
                          _buildTrustRow(),
                          Gap(24.h),

                          // CTA BUTTON
                          _buildCtaButton(),
                          Gap(16.h),

                          // YASAL
                          _buildLegalText(),
                          Gap(32.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // LOADING OVERLAY
            if (state is AiGenerationLoading) _buildLoadingOverlay(state),
          ],
        );
      },
    );
  }

  Widget _buildFileUploader() {
    return GestureDetector(
      onTap: _selectedImage == null ? _pickImage : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _selectedImage != null
                ? const Color(0xFF7C3AED)
                : const Color(0xFF7C3AED).withValues(alpha: 0.4),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.r),
              child: _selectedImage == null
                  ? _buildUploadDefault()
                  : _buildUploadPreview(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadDefault() {
    return Column(
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.add_photo_alternate_rounded,
            size: 24.sp,
            color: const Color(0xFF7C3AED),
          ),
        ),
        Gap(12.h),
        Text(
          'Ürün Fotoğrafı Yükle',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1B4B),
          ),
        ),
        Gap(6.h),
        Text(
          'JPG, PNG — max 10MB',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey.shade500,
            height: 1.6,
          ),
        ),
        Gap(10.h),
        Text(
          'Tıkla veya sürükle bırak',
          style: TextStyle(
            fontSize: 11.sp,
            color: const Color(0xFF7C3AED),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPreview() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: kIsWeb
              ? Image.network(
                  _selectedImage!.path,
                  width: 80.r,
                  height: 80.r,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  _selectedImage!.path,
                  width: 80.r,
                  height: 80.r,
                  fit: BoxFit.cover,
                ),
        ),
        Gap(14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✓ Fotoğraf yüklendi',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF059669),
                ),
              ),
              Gap(4.h),
              Text(
                'AI analiz için hazır',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade500,
                ),
              ),
              Gap(10.h),
              GestureDetector(
                onTap: _removeImage,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    'Kaldır',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label, {bool required = false, String? badge}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
            letterSpacing: 0.1,
          ),
        ),
        if (required) ...[
          Gap(6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'Zorunlu',
              style: TextStyle(
                fontSize: 9.sp,
                color: const Color(0xFF7C3AED),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        if (badge != null) ...[
          Gap(6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 9.sp,
                color: const Color(0xFF7C3AED),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlatformSelector(AiGenerationState state) {
    List<PlatformConfigEntity> configs = [];
    if (state is AiGenerationConfigsLoaded) {
      configs = state.configs;
    } else if (state is AiGenerationLoading && state.configs != null) {
      configs = state.configs!;
    }

    if (configs.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF7C3AED), strokeWidth: 2),
        ),
      );
    }

    final isDesktop = MediaQuery.of(context).size.width > 768;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 6 : 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: isDesktop ? 0.95 : 0.8,
      ),
      itemCount: configs.length,
      itemBuilder: (context, index) {
        final config = configs[index];
        return PlatformSelectorCard(
          config: config,
          isSelected: config.platform == _selectedPlatform,
          onTap: () => setState(() => _selectedPlatform = config.platform),
        );
      },
    );
  }

  Widget _buildProductNameField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _productNameController,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF1E1B4B),
            ),
            decoration: InputDecoration(
              hintText: 'ör. Hakiki Deri Bileklik',
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade400,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: Color(0xFF7C3AED),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        Gap(10.w),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            color: _productNameController.text.length > 2
                ? const Color(0xFF059669)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 14.sp,
            color: _productNameController.text.length > 2
                ? Colors.white
                : Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      children: [
        TextFormField(
          controller: _productDescController,
          maxLines: 4,
          maxLength: 500,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF1E1B4B)),
          onChanged: (v) => setState(() => _descCharCount = v.length),
          decoration: InputDecoration(
            hintText:
                'Ürününüzü detaylıca tanımlayın. Materyal, kullanım alanı, öne çıkan özellikler...',
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade400,
              height: 1.5,
            ),
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            contentPadding: EdgeInsets.all(14.r),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFF7C3AED),
                width: 1.5,
              ),
            ),
          ),
        ),
        Gap(4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Text(
              '$_descCharCount / 500',
              style: TextStyle(
                fontSize: 10.sp,
                color: _descCharCount > 480
                    ? Colors.red
                    : _descCharCount > 400
                        ? Colors.orange
                        : const Color(0xFFC4B5FD),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToneGrid() {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 6 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: isDesktop ? 2.8 : 2.2,
      ),
      itemCount: _tones.length,
      itemBuilder: (context, index) {
        final tone = _tones[index];
        final isActive = tone == _selectedTone;
        return GestureDetector(
          onTap: () => setState(() => _selectedTone = tone),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFEDE9FE) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isActive ? const Color(0xFF7C3AED) : const Color(0xFFE5E3F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _toneEmoji[tone] ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isActive ? null : Colors.black.withValues(alpha: 0.35),
                  ),
                ),
                Gap(5.w),
                Text(
                  _toneLabel[tone] ?? '',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? const Color(0xFF7C3AED) : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrustRow() {
    final items = [
      (Icons.verified_rounded, 'Platform kurallarına uygun format'),
      (Icons.security_rounded, 'Yasak kelime kontrolü'),
      (Icons.speed_rounded, '30 saniyede hazır'),
    ];
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E3F0)),
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: item == items.last ? 0 : 8.h),
            child: Row(
              children: [
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    item.$1,
                    size: 11.sp,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                Gap(8.w),
                Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCtaButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: _isFormReady
            ? [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: _isFormReady ? _startGeneration : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormReady
              ? const Color(0xFF4C1D95)
              : const Color(0xFFD8D0E8),
          disabledBackgroundColor: const Color(0xFFD8D0E8),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 18),
            Gap(8.w),
            Text(
              'Sihri Başlat',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalText() {
    return Text(
      'Platformda kullanılan ticari markalar ve logolar ilgili şirketlerin mülkiyetindedir; sadece referans amaçlı gösterilmiştir.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 9.sp,
        color: Colors.grey.shade400,
        height: 1.5,
      ),
    );
  }

  Widget _buildLoadingOverlay(AiGenerationLoading state) {
    final steps = [
      '⏳ Yüklenen fotoğraf analiz ediliyor...',
      '🎯 En yüksek dönüşüm açıları hesaplanıyor...',
      '🧠 Stüdyo ortamı inşa ediliyor...',
      '✍️ Platform kurallarına uygun metin yazılıyor...',
      '✨ Vitrinlik içeriğiniz hazırlanıyor...',
    ];

    return Container(
      color: Colors.black.withValues(alpha: 0.88),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: const Color(0xFFA78BFA),
                  size: 28.sp,
                ),
              ),
              Gap(20.h),
              Text(
                'AI çalışıyor...',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Gap(6.h),
              Text(
                'Rakiplerinizi geride bırakacak içerik hazırlanıyor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              Gap(28.h),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7C3AED),
                  ),
                  minHeight: 7,
                ),
              ),
              Gap(10.h),
              Text(
                '${((state.progress ?? 0) * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFA78BFA),
                ),
              ),
              Gap(16.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  state.message ?? steps[0],
                  key: ValueKey(state.message),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
