import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardDataRequested());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardBloc>().add(const DashboardDataRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final w = MediaQuery.of(context).size.width;
        final isDesktop = w > 768;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FF),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 40 : 20,
              isDesktop ? 40 : 20,
              isDesktop ? 40 : 20,
              40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isDesktop) _buildMobileHeader(state),
                if (!isDesktop) const SizedBox(height: 24),
                _buildGreeting(state, isDesktop),
                const SizedBox(height: 28),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildStatsRow(state, isDesktop)),
                      const SizedBox(width: 20),
                      Expanded(flex: 2, child: _buildCreditCard(state, isDesktop)),
                    ],
                  )
                else ...[
                  _buildStatsRow(state, isDesktop),
                  const SizedBox(height: 16),
                  _buildCreditCard(state, isDesktop),
                ],
                const SizedBox(height: 20),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildCtaCard(isDesktop)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildProgressCard(state, isDesktop)),
                    ],
                  )
                else ...[
                  _buildCtaCard(isDesktop),
                  const SizedBox(height: 16),
                  _buildProgressCard(state, isDesktop),
                ],
                const SizedBox(height: 36),
                _buildSectionHeader(),
                const SizedBox(height: 16),
                _buildRecentGenerations(state, isDesktop),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── MOBILE HEADER ───────────────────────────────────────────────────────────

  Widget _buildMobileHeader(DashboardState state) {
    return Row(
      children: [
        SvgPicture.asset('assets/logos/titlora_logo.svg', height: 28),
        const Spacer(),
        _iconBtn(Icons.notifications_none_rounded),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _showProfileMenu(context),
          child: Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitial(state),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E3F0)),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF9490A9)),
    );
  }

  // ─── GREETING ────────────────────────────────────────────────────────────────

  Widget _buildGreeting(DashboardState state, bool isDesktop) {
    final name = state is DashboardLoaded
        ? state.user.fullName.split(' ').first
        : 'Satıcı';
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Günaydın' : hour < 18 ? 'İyi günler' : 'İyi akşamlar';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $name 👋',
                style: TextStyle(
                  fontSize: isDesktop ? 26 : 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1B4B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rakiplerinizi geride bırakma zamanı.',
                style: TextStyle(
                  fontSize: isDesktop ? 15 : 13,
                  color: const Color(0xFF9490A9),
                ),
              ),
            ],
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showProfileMenu(context),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E3F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitial(state),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state is DashboardLoaded ? state.user.fullName : 'Kullanıcı',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B)),
                        ),
                        Text(
                          'Başlangıç Planı',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF9490A9)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─── STATS ROW ───────────────────────────────────────────────────────────────

  Widget _buildStatsRow(DashboardState state, bool isDesktop) {
    final images = state is DashboardLoaded ? state.imageCount : 0;
    final texts = state is DashboardLoaded ? state.textCount : 0;
    final total = state is DashboardLoaded ? state.totalGenerations : 0;

    return Row(
      children: [
        Expanded(child: _statCard('Toplam Üretim', total.toString(), Icons.auto_awesome_rounded, const Color(0xFF7C3AED), const Color(0xFFF5F3FF), isDesktop, '+${total > 0 ? total : 0} bu ay')),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Görsel', images.toString(), Icons.image_rounded, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), isDesktop, 'AI stüdyo kalitesi')),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Metin', texts.toString(), Icons.edit_note_rounded, const Color(0xFF10B981), const Color(0xFFD1FAE5), isDesktop, 'SEO optimize')),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, Color bg, bool isDesktop, String sub) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E3F0)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: isDesktop ? 36 : 28,
                height: isDesktop ? 36 : 28,
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: isDesktop ? 18 : 14, color: color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 10, color: Color(0xFF10B981)),
                    const SizedBox(width: 2),
                    Text('↑', style: TextStyle(fontSize: 10, color: const Color(0xFF10B981), fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 14 : 10),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 30 : 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E1B4B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: isDesktop ? 13 : 11, color: const Color(0xFF9490A9), fontWeight: FontWeight.w500)),
          SizedBox(height: isDesktop ? 12 : 8),
          Container(height: 1, color: const Color(0xFFF3F2F8)),
          SizedBox(height: isDesktop ? 10 : 6),
          Text(sub, style: TextStyle(fontSize: isDesktop ? 11 : 10, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ─── CREDIT CARD ─────────────────────────────────────────────────────────────

  Widget _buildCreditCard(DashboardState state, bool isDesktop) {
    final credits = state is DashboardLoaded ? state.credits : 5;
    final plan = state is DashboardLoaded ? state.user.subscriptionPlan : SubscriptionPlan.free;
    final maxCredits = plan == SubscriptionPlan.enterprise ? 150 : plan == SubscriptionPlan.professional ? 60 : 5;
    final displayMax = credits > maxCredits ? credits : maxCredits;
    final planName = plan == SubscriptionPlan.enterprise ? 'MAX' : plan == SubscriptionPlan.professional ? 'Pro' : 'Başlangıç';
    final usedRatio = (credits / displayMax).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E3F0)),
        boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kredi Durumu', style: TextStyle(fontSize: isDesktop ? 15 : 13, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    const Text('Aktif', style: TextStyle(fontSize: 11, color: Color(0xFF065F46), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 20 : 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$credits',
                style: TextStyle(
                  fontSize: isDesktop ? 44 : 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1B4B),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$credits / $displayMax kredi',
                style: TextStyle(fontSize: isDesktop ? 15 : 13, color: const Color(0xFF9490A9)),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: usedRatio,
              backgroundColor: const Color(0xFFF3F2F8),
              valueColor: AlwaysStoppedAnimation<Color>(
                credits <= 1 ? const Color(0xFFEF4444) : const Color(0xFF7C3AED),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$credits kredi kaldı · $planName Planı',
            style: TextStyle(fontSize: isDesktop ? 12 : 11, color: const Color(0xFF9490A9)),
          ),
          SizedBox(height: isDesktop ? 20 : 14),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pro plan yakında aktif olacak!'), behavior: SnackBarBehavior.floating),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      plan == SubscriptionPlan.enterprise
                          ? 'MAX Planındasınız'
                          : plan == SubscriptionPlan.professional
                              ? 'MAX\'a Yükselt · ₺890/ay'
                              : 'Pro\'ya Yükselt · ₺390/ay',
                      style: TextStyle(fontSize: isDesktop ? 14 : 12, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CTA CARD ────────────────────────────────────────────────────────────────

  Widget _buildCtaCard(bool isDesktop) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/generate'),
        child: Container(
          padding: EdgeInsets.all(isDesktop ? 28 : 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7C3AED), Color(0xFF1E1B4B)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, size: 22, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Yeni İçerik Üret', style: TextStyle(fontSize: isDesktop ? 20 : 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                        Text('30 saniyede görsel + metin hazır', style: TextStyle(fontSize: isDesktop ? 13 : 11, color: Colors.white.withValues(alpha: 0.65))),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                ],
              ),
              SizedBox(height: isDesktop ? 20 : 16),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: ['Trendyol', 'Hepsiburada', 'N11', 'Instagram', 'TikTok', '+7'].map((label) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Text(label, style: TextStyle(fontSize: isDesktop ? 12 : 10, color: Colors.white, fontWeight: FontWeight.w600)),
                  );
                }).toList(),
              ),
              SizedBox(height: isDesktop ? 20 : 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 18, color: Color(0xFF7C3AED)),
                    SizedBox(width: 8),
                    Text('İçerik Üret', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED))),
                    SizedBox(width: 4),
                    Text('→', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── PROGRESS CARD ───────────────────────────────────────────────────────────

  Widget _buildProgressCard(DashboardState state, bool isDesktop) {
    final total = state is DashboardLoaded ? state.totalGenerations : 0;
    final steps = [
      _ProgressStep('Hesap oluşturuldu', true),
      _ProgressStep('İlk içerik üretildi', total > 0),
      _ProgressStep('İlk satış kazanıldı', false),
    ];

    return Container(
      padding: EdgeInsets.all(isDesktop ? 28 : 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('İLERLEME', style: TextStyle(fontSize: isDesktop ? 11 : 9, color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w700, letterSpacing: 1)),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          Text(
            total == 0 ? 'İlk üretimini yap 🚀' : 'Harika gidiyorsun! 🎉',
            style: TextStyle(fontSize: isDesktop ? 18 : 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3),
          ),
          SizedBox(height: isDesktop ? 20 : 16),
          ...steps.map((step) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: step.done ? const Color(0xFF7C3AED) : Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: step.done ? const Color(0xFF7C3AED) : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(step.done ? Icons.check_rounded : Icons.radio_button_unchecked_rounded, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  step.label,
                  style: TextStyle(
                    fontSize: isDesktop ? 14 : 12,
                    color: step.done ? Colors.white : Colors.white.withValues(alpha: 0.45),
                    fontWeight: step.done ? FontWeight.w600 : FontWeight.w400,
                    decoration: step.done ? TextDecoration.none : TextDecoration.none,
                  ),
                ),
                if (step.done) ...[
                  const Spacer(),
                  const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF7C3AED)),
                ],
              ],
            ),
          )),
          SizedBox(height: isDesktop ? 8 : 4),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/generate'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  total == 0 ? 'Hemen Başla →' : 'Devam Et →',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isDesktop ? 14 : 12, color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECTION HEADER ──────────────────────────────────────────────────────────

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Son Üretimler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B), letterSpacing: -0.3)),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go('/generate'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.2)),
              ),
              child: const Text('+ Yeni üretim', style: TextStyle(fontSize: 13, color: Color(0xFF7C3AED), fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }

  // ─── RECENT GENERATIONS ──────────────────────────────────────────────────────

  Widget _buildRecentGenerations(DashboardState state, bool isDesktop) {
    if (state is DashboardLoaded && state.recentGenerations.isNotEmpty) {
      final items = state.recentGenerations.take(isDesktop ? 8 : 6).toList();
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => _genCard(items[i], isDesktop),
      );
    }

    return _buildEmptyState(isDesktop);
  }

  Widget _genCard(dynamic gen, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E3F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: gen.image?.imageUrl != null
                  ? Image.network(gen.image!.imageUrl, fit: BoxFit.cover, width: double.infinity,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: const Color(0xFFF5F3FF),
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF7C3AED))),
                        );
                      },
                      errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gen.request.productName.isNotEmpty ? gen.request.productName : 'Ürün',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: isDesktop ? 13 : 12, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text('Tamamlandı', style: TextStyle(fontSize: isDesktop ? 11 : 10, color: const Color(0xFF9490A9))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF5F3FF),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 36, color: Color(0xFFDDD6FE)),
      ),
    );
  }

  Widget _buildEmptyState(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 56 : 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E3F0)),
      ),
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFEDE9FE), Color(0xFFDDD6FE)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.auto_awesome_rounded, size: 32, color: Color(0xFF7C3AED)),
          ),
          const SizedBox(height: 20),
          Text('Henüz üretim yok', style: TextStyle(fontSize: isDesktop ? 18 : 15, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
          const SizedBox(height: 8),
          Text(
            'İlk ürün görselinizi ve SEO metninizi\nyükleyin, 30 saniyede hazır.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isDesktop ? 14 : 12, color: const Color(0xFF9490A9), height: 1.6),
          ),
          const SizedBox(height: 24),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/generate'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('İlk İçeriği Üret', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    SizedBox(width: 4),
                    Text('→', style: TextStyle(fontSize: 15, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────────

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
              ),
              title: const Text('Çıkış Yap', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getInitial(DashboardState state) {
    if (state is DashboardLoaded) {
      final name = state.user.fullName;
      return name.isNotEmpty ? name[0].toUpperCase() : 'T';
    }
    return 'T';
  }
}

class _ProgressStep {
  final String label;
  final bool done;
  const _ProgressStep(this.label, this.done);
}

class _StatItem {
  final String label, value;
  final IconData icon;
  final Color color, bgColor;
  const _StatItem(this.label, this.value, this.icon, this.color, this.bgColor);
}
