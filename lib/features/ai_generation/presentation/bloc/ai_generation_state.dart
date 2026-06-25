import 'package:equatable/equatable.dart';
import '../../domain/entities/generation_result_entity.dart';
import '../../domain/entities/platform_config_entity.dart';

sealed class AiGenerationState extends Equatable {
  const AiGenerationState();
  @override
  List<Object?> get props => [];
}

final class AiGenerationInitial extends AiGenerationState {
  const AiGenerationInitial();
}

sealed class AiGenerationLoading extends AiGenerationState {
  double? get progress;
  String? get message;
  List<PlatformConfigEntity>? get configs;
  const AiGenerationLoading();
}

final class AiGenerationConfigsLoading extends AiGenerationLoading {
  const AiGenerationConfigsLoading();

  @override
  double? get progress => null;
  @override
  String? get message => null;
  @override
  List<PlatformConfigEntity>? get configs => null;
}

final class AiGenerationConfigsLoaded extends AiGenerationState {
  final List<PlatformConfigEntity> configs;
  final SupportedPlatform selectedPlatform;
  const AiGenerationConfigsLoaded({required this.configs, required this.selectedPlatform});
  @override
  List<Object> get props => [configs, selectedPlatform];
}

final class AiGenerationInProgress extends AiGenerationLoading {
  final String progressMessage;
  @override
  final double progress;
  const AiGenerationInProgress({this.progressMessage = 'Yapay zeka içerik üretiyor...', this.progress = 0.0});

  @override
  String? get message => progressMessage;
  @override
  List<PlatformConfigEntity>? get configs => null;

  @override
  List<Object> get props => [progressMessage, progress];
}

final class AiGenerationSuccess extends AiGenerationState {
  final GenerationResultEntity result;
  const AiGenerationSuccess({required this.result});
  @override
  List<Object> get props => [result];
}

final class AiGenerationFailureState extends AiGenerationState {
  final String message;
  final int? retryAfterSeconds;
  const AiGenerationFailureState({required this.message, this.retryAfterSeconds});
  @override
  List<Object?> get props => [message, retryAfterSeconds];
}

final class AiGenerationHistoryLoaded extends AiGenerationState {
  final List<GenerationResultEntity> results;
  final bool hasMore;
  final int currentPage;
  const AiGenerationHistoryLoaded({required this.results, required this.hasMore, required this.currentPage});
  @override
  List<Object> get props => [results, hasMore, currentPage];
}

typedef AiGenerationFailure = AiGenerationFailureState;
