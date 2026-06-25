import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/ai_generation/presentation/bloc/ai_generation_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/account/presentation/pages/account_page.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/ai_generation/presentation/pages/generation_page.dart';
import '../../features/ai_generation/presentation/pages/result_page.dart';
import '../../features/legal/terms_page.dart';
import '../../features/legal/privacy_page.dart';
import '../di/injection_container.dart';
import '../storage/secure_storage.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

@lazySingleton
class AppRouter {
  final SecureStorageService _storage;


  AppRouter(this._storage);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: const bool.fromEnvironment('dart.vm.product') == false,
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    redirect: (BuildContext context, GoRouterState state) async {
      final token = await _storage.getAccessToken();
      final hasToken = token != null && token.isNotEmpty;
      final location = state.matchedLocation;
      final isOnSplash = location == AppRoutes.splash;
      final isOnLogin = location == AppRoutes.login;
      final isOnRegister = location == AppRoutes.register;
      final isOnLegal = location == AppRoutes.terms || location == AppRoutes.privacy;
      if (isOnSplash) return hasToken ? AppRoutes.dashboard : AppRoutes.login;
      if (!hasToken && !isOnLogin && !isOnRegister && !isOnLegal) return AppRoutes.login;
      if (hasToken && (isOnLogin || isOnRegister)) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.terms,
        name: AppRoutes.termsName,
        builder: (context, state) => const TermsPage(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        name: AppRoutes.privacyName,
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            name: AppRoutes.registerName,
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<AiGenerationBloc>()),
            BlocProvider.value(value: getIt<AuthBloc>()),
            BlocProvider.value(value: getIt<DashboardBloc>()),
          ],
          child: _AppShell(child: child),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: AppRoutes.dashboardName,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.generate,
            name: AppRoutes.generateName,
            builder: (context, state) => const GenerationPage(),
          ),
          GoRoute(
            path: AppRoutes.account,
            name: AppRoutes.accountName,
            builder: (context, state) => const AccountPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.result,
        name: AppRoutes.resultName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ResultPage(generationId: extra?['generationId'] as String? ?? '');
        },
      ),
    ],
    errorBuilder: (context, state) => _RouterErrorPage(error: state.error),
  );
}

class _AppShell extends StatelessWidget {
  final Widget child;
  const _AppShell({required this.child});

  static const List<_NavItem> _navItems = [
    _NavItem(label: 'Ana Sayfa', icon: Icons.home_outlined, activeIcon: Icons.home_rounded, route: AppRoutes.dashboard),
    _NavItem(label: 'Üret', icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome_rounded, route: AppRoutes.generate),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F7FF),
        body: Row(
          children: [
            // SIDEBAR
            Container(
              width: 240,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Color(0xFFE5E3F0), width: 0.5)),
              ),
              child: Column(
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/logos/titlora_logo.svg', height: 28),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E3F0)),
                  const SizedBox(height: 12),
                  // Nav items
                  ...List.generate(_navItems.length, (index) {
                    final item = _navItems[index];
                    final isActive = location.startsWith(item.route);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      child: Material(
                        color: isActive ? const Color(0xFFEDE9FE) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => context.go(item.route),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  isActive ? item.activeIcon : item.icon,
                                  size: 20,
                                  color: isActive ? const Color(0xFF7C3AED) : const Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                    color: isActive ? const Color(0xFF7C3AED) : const Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  // Profil + Çıkış
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Hesabım butonu
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => context.go('/account'),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline_rounded, size: 20, color: Color(0xFF6B7280)),
                                  SizedBox(width: 12),
                                  Text('Hesabım', style: TextStyle(fontSize: 14, color: Color(0xFF374151))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Çıkış butonu
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              context.read<AuthBloc>().add(const AuthLogoutRequested());
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.logout_rounded, size: 20, color: Color(0xFFEF4444)),
                                  SizedBox(width: 12),
                                  Text('Çıkış Yap', style: TextStyle(fontSize: 14, color: Color(0xFFEF4444))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // CONTENT
            Expanded(child: child),
          ],
        ),
      );
    }

    // MOBILE
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(location),
        onTap: (index) => context.go(_navItems[index].route),
        items: _navItems.map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: item.label,
        )).toList(),
      ),
    );
  }

  int _getSelectedIndex(String location) {
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].route)) return i;
    }
    return 0;
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  const _NavItem({required this.label, required this.icon, required this.activeIcon, required this.route});
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _RouterErrorPage extends StatelessWidget {
  final Exception? error;
  const _RouterErrorPage({this.error});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Sayfa bulunamadı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(error?.toString() ?? 'Bilinmeyen bir yönlendirme hatası oluştu.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => context.go(AppRoutes.dashboard), child: const Text('Ana Sayfaya Dön')),
          ],
        ),
      ),
    );
  }
}
