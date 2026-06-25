import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/platform_config_entity.dart';

class StyleSelectorRow extends StatelessWidget {
  final ImageStyle selectedStyle;
  final void Function(ImageStyle) onStyleSelected;

  const StyleSelectorRow({
    super.key,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  static const List<_StyleOption> _options = [
    _StyleOption(
      style: ImageStyle.studioWhite,
      label: 'Stüdyo\nBeyaz',
      icon: Icons.wb_sunny_outlined,
    ),
    _StyleOption(
      style: ImageStyle.lifestyle,
      label: 'Lifestyle',
      icon: Icons.nature_people_outlined,
    ),
    _StyleOption(
      style: ImageStyle.flatLay,
      label: 'Flat Lay',
      icon: Icons.grid_view_rounded,
    ),
    _StyleOption(
      style: ImageStyle.gradient,
      label: 'Gradient',
      icon: Icons.gradient_rounded,
    ),
    _StyleOption(
      style: ImageStyle.natural,
      label: 'Doğal',
      icon: Icons.eco_outlined,
    ),
    _StyleOption(
      style: ImageStyle.dramatic,
      label: 'Dramatik',
      icon: Icons.brightness_3_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, __) => Gap(10.w),
        itemBuilder: (context, index) {
          final option = _options[index];
          final isSelected = selectedStyle == option.style;
          final colorScheme = Theme.of(context).colorScheme;

          return GestureDetector(
            onTap: () => onStyleSelected(option.style),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 72.w,
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    option.icon,
                    size: 20.sp,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  Gap(4.h),
                  Text(
                    option.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9.sp,
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
        },
      ),
    );
  }
}

class _StyleOption {
  final ImageStyle style;
  final String label;
  final IconData icon;
  const _StyleOption({
    required this.style,
    required this.label,
    required this.icon,
  });
}
