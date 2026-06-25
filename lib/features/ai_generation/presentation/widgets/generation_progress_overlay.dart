import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GenerationProgressOverlay extends StatelessWidget {
  final String message;
  final double progress;

  const GenerationProgressOverlay({
    super.key,
    required this.message,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          width: 300.w,
          padding: EdgeInsets.all(32.r),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 64.w,
                height: 64.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64.w,
                      height: 64.h,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor: colorScheme.primaryContainer,
                        color: colorScheme.primary,
                      ),
                    ),
                    Icon(Icons.auto_awesome_rounded, size: 28.sp, color: colorScheme.primary),
                  ],
                ),
              ),
              Gap(20.h),
              Text(
                'Yapay Zeka Çalışıyor',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Gap(8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
              Gap(20.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6.h,
                  backgroundColor: colorScheme.primaryContainer,
                  color: colorScheme.primary,
                ),
              ),
              Gap(8.h),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
