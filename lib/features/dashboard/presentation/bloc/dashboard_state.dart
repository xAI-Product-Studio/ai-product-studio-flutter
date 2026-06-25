import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../ai_generation/domain/entities/generation_result_entity.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final UserEntity user;
  final int totalGenerations;
  final int imageCount;
  final int textCount;
  final int credits;
  final List<GenerationResultEntity> recentGenerations;

  const DashboardLoaded({
    required this.user,
    required this.totalGenerations,
    required this.imageCount,
    required this.textCount,
    required this.credits,
    required this.recentGenerations,
  });

  @override
  List<Object?> get props => [
        user,
        totalGenerations,
        imageCount,
        textCount,
        credits,
        recentGenerations,
      ];
}

class DashboardFailure extends DashboardState {
  final String message;
  const DashboardFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
