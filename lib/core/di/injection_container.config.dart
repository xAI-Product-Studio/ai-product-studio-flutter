// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import '../../features/ai_generation/data/datasources/ai_remote_datasource.dart'
    as _i161;
import '../../features/ai_generation/data/repositories/ai_generation_repository_impl.dart'
    as _i272;
import '../../features/ai_generation/domain/repositories/ai_generation_repository.dart'
    as _i785;
import '../../features/ai_generation/domain/usecases/generate_all_usecase.dart'
    as _i168;
import '../../features/ai_generation/domain/usecases/get_generation_history_usecase.dart'
    as _i764;
import '../../features/ai_generation/domain/usecases/get_platform_configs_usecase.dart'
    as _i1067;
import '../../features/ai_generation/presentation/bloc/ai_generation_bloc.dart'
    as _i864;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i560;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../network/dio_client.dart' as _i667;
import '../router/app_router.dart' as _i81;
import '../storage/secure_storage.dart' as _i619;
import 'di_modules.dart' as _i176;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.lazySingleton<_i974.Logger>(() => appModule.logger);
    gh.lazySingleton<_i619.SecureStorageService>(
        () => _i619.SecureStorageService(gh<_i974.Logger>()));
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient(
          gh<_i619.SecureStorageService>(),
          gh<_i974.Logger>(),
        ));
    gh.factory<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i81.AppRouter>(
        () => _i81.AppRouter(gh<_i619.SecureStorageService>()));
    gh.lazySingleton<_i161.AiRemoteDataSource>(
        () => _i161.AiRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i161.AuthRemoteDataSource>(),
          gh<_i619.SecureStorageService>(),
          gh<_i974.Logger>(),
        ));
    gh.lazySingleton<_i785.AiGenerationRepository>(
        () => _i272.AiGenerationRepositoryImpl(
              gh<_i161.AiRemoteDataSource>(),
              gh<_i974.Logger>(),
            ));
    gh.factory<_i560.ForgotPasswordUseCase>(
        () => _i560.ForgotPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i17.GetCurrentUserUseCase>(
        () => _i17.GetCurrentUserUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i48.LogoutUseCase>(
        () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i941.RegisterUseCase>(
        () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i168.GenerateAllUseCase>(
        () => _i168.GenerateAllUseCase(gh<_i785.AiGenerationRepository>()));
    gh.factory<_i764.GetGenerationHistoryUseCase>(() =>
        _i764.GetGenerationHistoryUseCase(gh<_i785.AiGenerationRepository>()));
    gh.factory<_i1067.GetPlatformConfigsUseCase>(() =>
        _i1067.GetPlatformConfigsUseCase(gh<_i785.AiGenerationRepository>()));
    gh.lazySingleton<_i864.AiGenerationBloc>(() => _i864.AiGenerationBloc(
          gh<_i168.GenerateAllUseCase>(),
          gh<_i1067.GetPlatformConfigsUseCase>(),
          gh<_i764.GetGenerationHistoryUseCase>(),
        ));
    gh.singleton<_i797.AuthBloc>(() => _i797.AuthBloc(
          gh<_i188.LoginUseCase>(),
          gh<_i941.RegisterUseCase>(),
          gh<_i48.LogoutUseCase>(),
          gh<_i17.GetCurrentUserUseCase>(),
          gh<_i560.ForgotPasswordUseCase>(),
          gh<_i974.Logger>(),
        ));
    gh.lazySingleton<_i652.DashboardBloc>(() => _i652.DashboardBloc(
          gh<_i797.AuthBloc>(),
          gh<_i764.GetGenerationHistoryUseCase>(),
          gh<_i17.GetCurrentUserUseCase>(),
          gh<_i974.Logger>(),
        ));
    return this;
  }
}

class _$AppModule extends _i176.AppModule {}
