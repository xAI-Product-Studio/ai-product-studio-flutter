import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../ai_generation/domain/usecases/get_generation_history_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@lazySingleton
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AuthBloc _authBloc;
  final GetGenerationHistoryUseCase _getHistoryUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final Logger _logger;

  DashboardBloc(
    this._authBloc,
    this._getHistoryUseCase,
    this._getCurrentUserUseCase,
    this._logger,
  ) : super(const DashboardInitial()) {
    on<DashboardDataRequested>(_onDataRequested);
  }

  Future<void> _onDataRequested(
    DashboardDataRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final authState = _authBloc.state;
    if (authState is! AuthAuthenticated) {
      emit(const DashboardFailure(message: 'Kullanıcı oturumu bulunamadı.'));
      return;
    }

    // /users/me den taze veri çek
    final userResult = await _getCurrentUserUseCase();
    
    userResult.fold(
      (failure) => _logger.e('Users/me hatası: ${failure.message}'),
      (freshUser) => _logger.i('Taze kredi: ${freshUser.credits}'),
    );

    final user = userResult.fold(
      (failure) => authState.user,
      (freshUser) => freshUser,
    );

    _logger.i('Dashboard user kredisi: ${user.credits}');

    final historyResult = await _getHistoryUseCase(
      const GetHistoryParams(page: 1, limit: 20),
    );

    historyResult.fold(
      (failure) => emit(DashboardFailure(message: failure.message)),
      (results) {
        final total = results.length;
        final images = results.where((r) => r.image != null).length;
        final texts = results.where((r) => r.adCopy != null).length;
        emit(
          DashboardLoaded(
            user: user,
            totalGenerations: total,
            imageCount: images,
            textCount: texts,
            credits: user.credits,
            recentGenerations: results,
          ),
        );
      },
    );
  }
}
