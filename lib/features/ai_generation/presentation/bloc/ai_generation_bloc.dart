import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/generation_request_entity.dart';
import '../../domain/entities/generation_result_entity.dart';
import '../../domain/entities/platform_config_entity.dart';
import '../../domain/repositories/ai_generation_repository.dart';
import '../../domain/usecases/generate_all_usecase.dart';
import '../../domain/usecases/get_generation_history_usecase.dart';
import '../../domain/usecases/get_platform_configs_usecase.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import 'ai_generation_event.dart';
import 'ai_generation_state.dart';

@lazySingleton
class AiGenerationBloc extends Bloc<AiGenerationEvent, AiGenerationState> {
  final GenerateAllUseCase _generateAllUseCase;
  final GetPlatformConfigsUseCase _getPlatformConfigsUseCase;
  final GetGenerationHistoryUseCase _getHistoryUseCase;


  AiGenerationBloc(this._generateAllUseCase, this._getPlatformConfigsUseCase, this._getHistoryUseCase)
      : super(const AiGenerationInitial()) {
    on<AiGenerationConfigsRequested>(_onConfigsRequested);
    on<AiGenerationPlatformSelected>(_onPlatformSelected);
    on<AiGenerationStarted>(_onGenerationStarted);
    on<AiGenerationHistoryRequested>(_onHistoryRequested);
    on<AiGenerationFavoriteToggled>(_onFavoriteToggled);
    on<AiGenerationReset>(_onReset);
  }

  Future<void> _onConfigsRequested(AiGenerationConfigsRequested event, Emitter<AiGenerationState> emit) async {
    emit(const AiGenerationConfigsLoading());
    final result = await _getPlatformConfigsUseCase();
    result.fold(
      (failure) => emit(AiGenerationFailureState(message: failure.message)),
      (configs) => emit(AiGenerationConfigsLoaded(configs: configs, selectedPlatform: SupportedPlatform.shopify)),
    );
  }

  void _onPlatformSelected(AiGenerationPlatformSelected event, Emitter<AiGenerationState> emit) {
    if (state is AiGenerationConfigsLoaded) {
      final current = state as AiGenerationConfigsLoaded;
      emit(AiGenerationConfigsLoaded(configs: current.configs, selectedPlatform: event.platform));
    }
  }

  Future<void> _onGenerationStarted(AiGenerationStarted event, Emitter<AiGenerationState> emit) async {
    emit(const AiGenerationInProgress(progressMessage: 'Prompt hazırlanıyor...', progress: 0.1));
    await Future.delayed(const Duration(milliseconds: 800));
    emit(const AiGenerationInProgress(progressMessage: 'Talep gönderiliyor...', progress: 0.3));

    String? base64Image;
    if (event.imagePath != null) {
      try {
        final xFile = XFile(event.imagePath!);
        final bytes = await xFile.readAsBytes();
        base64Image = base64Encode(bytes);
      } catch (e) {
        // Web'de blob URL'den okuma
      }
    }

    final request = GenerationRequestEntity(
      productName: event.productName,
      productDescription: event.productDescription,
      keyFeatures: const [],
      platform: event.platform,
      imageStyle: ImageStyle.studioWhite,
      adCopyTone: event.tone,
      referenceImageBase64: base64Image,
    );

    final result = await _generateAllUseCase(GenerateAllParams(request: request));
    
    if (result.isLeft()) {
      emit(AiGenerationFailureState(
        message: result.fold((l) => l.message, (r) => ''),
        retryAfterSeconds: result.fold((l) => l is AiServiceFailure ? (l).retryAfter : null, (r) => null),
      ));
      return;
    }

    var generationResult = result.getOrElse(() => throw Exception());

    // Polling logic to wait for the background generation task on the server to finish
    if (generationResult.status == GenerationStatus.processing ||
        generationResult.status == GenerationStatus.pending) {
      final repository = getIt<AiGenerationRepository>();
      final id = generationResult.id;

      const maxRetries = 40; // 40 retries * 1.5 seconds = 60 seconds max timeout
      int retryCount = 0;
      bool isFinished = false;

      while (retryCount < maxRetries && !isFinished) {
        await Future.delayed(const Duration(milliseconds: 1500));
        retryCount++;

        final progressPercent = 0.3 + (0.6 * (retryCount / maxRetries));
        final progressMsg = retryCount < 12
            ? 'Yapay zeka görseli işliyor...'
            : retryCount < 24
                ? 'Arka plan ve sahneler düzenleniyor...'
                : 'Reklam metinleri ve SEO etiketleri yazılıyor...';

        emit(AiGenerationInProgress(progressMessage: progressMsg, progress: progressPercent));

        final statusResult = await repository.getGenerationById(id: id);

        statusResult.fold(
          (failure) {
            // Log or continue polling on minor network failures
          },
          (updatedResult) {
            generationResult = updatedResult;
            if (updatedResult.status == GenerationStatus.completed) {
              isFinished = true;
              try {
                getIt<DashboardBloc>().add(const DashboardDataRequested());
                Future.delayed(const Duration(seconds: 2), () {
                  getIt<DashboardBloc>().add(const DashboardDataRequested());
                });
              } catch (_) {}
            } else if (updatedResult.status == GenerationStatus.failed) {
              isFinished = true;
            }
          },
        );
      }
    }

    if (generationResult.status == GenerationStatus.failed) {
      emit(AiGenerationFailureState(
        message: generationResult.errorMessage ?? 'İçerik üretimi başarısız oldu.',
      ));
      return;
    }

    emit(const AiGenerationInProgress(progressMessage: 'İçerik başarıyla üretildi! Hazırlanıyor...', progress: 0.95));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AiGenerationSuccess(result: generationResult));
  }

  Future<void> _onHistoryRequested(AiGenerationHistoryRequested event, Emitter<AiGenerationState> emit) async {
    if (event.page == 1) emit(const AiGenerationConfigsLoading());
    final result = await _getHistoryUseCase(GetHistoryParams(page: event.page, platformFilter: event.platformFilter));
    result.fold(
      (failure) => emit(AiGenerationFailureState(message: failure.message)),
      (results) => emit(AiGenerationHistoryLoaded(results: results, hasMore: results.length == 20, currentPage: event.page)),
    );
  }

  Future<void> _onFavoriteToggled(AiGenerationFavoriteToggled event, Emitter<AiGenerationState> emit) async {
    if (state is! AiGenerationHistoryLoaded) return;
    final current = state as AiGenerationHistoryLoaded;
    final updatedResults = current.results.map((r) {
      if (r.id == event.generationId) {
        return GenerationResultEntity(
          id: r.id, request: r.request,
          image: r.image?.copyWith(isFavorited: event.isFavorite),
          adCopy: r.adCopy, status: r.status, errorMessage: r.errorMessage,
          createdAt: r.createdAt, creditsUsed: r.creditsUsed,
        );
      }
      return r;
    }).toList();
    emit(AiGenerationHistoryLoaded(results: updatedResults, hasMore: current.hasMore, currentPage: current.currentPage));
  }

  void _onReset(AiGenerationReset event, Emitter<AiGenerationState> emit) {
    emit(const AiGenerationInitial());
  }
}
