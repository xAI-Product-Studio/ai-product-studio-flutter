import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/router/app_routes.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String name = 'Kullanıcı';
          String email = '';
          int credits = 0;

          if (state is AuthAuthenticated) {
            name = state.user.fullName;
            email = state.user.email;
            credits = state.user.credits;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                Text('Hesabım', style: TextStyle(fontSize: isDesktop ? 28 : 22, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
                const SizedBox(height: 8),
                Text('Hesap bilgilerinizi ve aboneliğinizi yönetin.', style: TextStyle(fontSize: isDesktop ? 16 : 14, color: Colors.grey.shade500)),
                const SizedBox(height: 32),

                // Profil kartı
                Container(
                  padding: EdgeInsets.all(isDesktop ? 28 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E3F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: const BoxDecoration(color: Color(0xFF4C1D95), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'T',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                            const SizedBox(height: 4),
                            Text(email, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Plan & Kredi
                if (isDesktop)
                  Row(
                    children: [
                      Expanded(child: _buildPlanCard(credits)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildCreditCard(credits)),
                    ],
                  )
                else ...[
                  _buildPlanCard(credits),
                  const SizedBox(height: 16),
                  _buildCreditCard(credits),
                ],
                const SizedBox(height: 20),

                // Pro'ya geç CTA
                if (credits <= 5)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pro plan yakında aktif olacak!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isDesktop ? 28 : 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pro Plana Geç', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 8),
                          Text('Aylık 60 kredi, tüm platformlar, öncelikli destek.', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: const Text('₺390/ay — Başla', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF4C1D95))),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Ayarlar listesi
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E3F0)),
                  ),
                  child: Column(
                    children: [
                      _buildSettingRow(Icons.lock_outline_rounded, 'Şifre Değiştir', () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Yakında!'), behavior: SnackBarBehavior.floating),
                        );
                      }),
                      const Divider(height: 1, color: Color(0xFFE5E3F0)),
                      _buildSettingRow(Icons.description_outlined, 'Kullanım Koşulları', () => context.go(AppRoutes.terms)),
                      const Divider(height: 1, color: Color(0xFFE5E3F0)),
                      _buildSettingRow(Icons.shield_outlined, 'Gizlilik Politikası', () => context.go(AppRoutes.privacy)),
                      const Divider(height: 1, color: Color(0xFFE5E3F0)),
                      _buildSettingRow(Icons.help_outline_rounded, 'Destek', () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('destek@titlora.com adresine e-posta gönderin.'), behavior: SnackBarBehavior.floating),
                        );
                      }),
                      const Divider(height: 1, color: Color(0xFFE5E3F0)),
                      _buildSettingRow(Icons.logout_rounded, 'Çıkış Yap', () {
                        context.read<AuthBloc>().add(const AuthLogoutRequested());
                      }, isDestructive: true),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(int credits) {
    final planName = credits <= 5 ? 'Ücretsiz' : credits <= 60 ? 'Pro' : 'Max';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E3F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mevcut Plan', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(20)),
                child: Text(planName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7C3AED))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(planName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
          const SizedBox(height: 4),
          Text(credits <= 5 ? '5 kredi/ay' : credits <= 60 ? '60 kredi/ay · ₺390' : '150 kredi/ay · ₺890',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildCreditCard(int credits) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E3F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kalan Kredi', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 12),
          Text('$credits', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
          const SizedBox(height: 4),
          Text('1 kredi = 1 ürün (görsel + metin)', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? const Color(0xFFEF4444) : const Color(0xFF374151);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: TextStyle(fontSize: 15, color: color))),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
