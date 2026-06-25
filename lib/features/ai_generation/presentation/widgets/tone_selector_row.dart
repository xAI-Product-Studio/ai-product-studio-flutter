import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/platform_config_entity.dart';

class ToneSelectorRow extends StatelessWidget {
  final AdCopyTone selectedTone;
  final void Function(AdCopyTone) onToneSelected;

  const ToneSelectorRow({
    super.key,
    required this.selectedTone,
    required this.onToneSelected,
  });

  static const List<_ToneOption> _options = [
    _ToneOption(
      tone: AdCopyTone.professional,
      label: 'Profesyonel',
      emoji: '👔',
    ),
    _ToneOption(
      tone: AdCopyTone.friendly,
      label: 'Samimi',
      emoji: '😊',
    ),
    _ToneOption(
      tone: AdCopyTone.urgent,
      label: 'Acil',
      emoji: '⚡',
    ),
    _ToneOption(
      tone: AdCopyTone.luxurious,
      label: 'Lüks',
      emoji: '💎',
    ),
    _ToneOption(
      tone: AdCopyTone.playful,
      label: 'Eğlenceli',
      emoji: '🎉',
    ),
    _ToneOption(
      tone: AdCopyTone.minimalist,
      label: 'Minimal',
      emoji: '✦',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _options.map((option) {
        final isSelected = selectedTone == option.tone;
        final colorScheme = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () => onToneSelected(option.tone),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option.emoji,
                  style: TextStyle(fontSize: 14.sp),
                ),
                Gap(6.w),
                Text(
                  option.label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ToneOption {
  final AdCopyTone tone;
  final String label;
  final String emoji;
  const _ToneOption({
    required this.tone,
    required this.label,
    required this.emoji,
  });
}
