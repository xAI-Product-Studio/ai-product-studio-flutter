import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ErrorSnackbar.show(
        context,
        message: 'Devam etmek için kullanım koşullarını kabul etmelisiniz.',
      );
      return;
    }
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            ErrorSnackbar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Scaffold(
            backgroundColor: const Color(0xFFF8F7FF),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                if (isMobile) {
                  return _buildRightPanel(context, isLoading, isMobile);
                }
                return Row(
                  children: [
                    Expanded(flex: 45, child: _buildLeftPanel()),
                    Expanded(flex: 55, child: _buildRightPanel(context, isLoading, isMobile)),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withOpacity(0.15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'T',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'titlora',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'İlk Bakışta Güven Ver',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'İlk Bakışta Sat',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C3AED),
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Trendyol · Hepsiburada · N11 · Instagram · TikTok',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _TrustItem(icon: Icons.lock_outline, text: 'SSL Şifreli'),
                    _TrustItem(icon: Icons.verified_user_outlined, text: 'KVKK Uyumlu'),
                    _TrustItem(icon: Icons.headset_mic_outlined, text: '7/24 Destek'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, bool isLoading, bool isMobile) {
    return Container(
      color: const Color(0xFFF8F7FF),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                children: [
                  if (isMobile)
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'T',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'titlora',
                          style: TextStyle(
                            color: Color(0xFF1E1B4B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  InkWell(
                    onTap: () => context.goNamed(AppRoutes.loginName),
                    child: const Text(
                      'Zaten hesabın var mı? Giriş yap →',
                      style: TextStyle(
                        color: Color(0xFF7C3AED),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Hesap oluştur',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1B4B),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Saniyeler içinde başla, ücretsiz',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B6880),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 32),
                          _AuthTextField(
                            controller: _fullNameController,
                            label: 'Ad Soyad',
                            hint: 'Adınız Soyadınız',
                            keyboardType: TextInputType.name,
                            validator: Validators.fullName,
                          ),
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _emailController,
                            label: 'E-posta',
                            hint: 'ornek@sirket.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _passwordController,
                            label: 'Şifre',
                            hint: 'En az 8 karakter',
                            obscureText: _obscurePassword,
                            validator: Validators.password,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF9490A9),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _confirmPasswordController,
                            label: 'Şifre Tekrar',
                            hint: 'Şifrenizi tekrar girin',
                            obscureText: _obscureConfirmPassword,
                            validator: (value) => Validators.confirmPassword(value, _passwordController.text),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF9490A9),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            onFieldSubmitted: (_) => _onRegisterPressed(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _acceptedTerms,
                                  onChanged: (val) {
                                    setState(() {
                                      _acceptedTerms = val ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF7C3AED),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(color: Color(0xFFE5E3F0)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Devam ederek ',
                                    style: const TextStyle(
                                      color: Color(0xFF6B6880),
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Kullanım Koşulları',
                                        style: const TextStyle(
                                          color: Color(0xFF7C3AED),
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => context.pushNamed(AppRoutes.termsName),
                                      ),
                                      const TextSpan(text: ' ve '),
                                      TextSpan(
                                        text: 'Gizlilik Politikası',
                                        style: const TextStyle(
                                          color: Color(0xFF7C3AED),
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => context.pushNamed(AppRoutes.privacyName),
                                      ),
                                      const TextSpan(text: "'nı kabul etmiş olursunuz."),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          _AuthButton(
                            text: 'Ücretsiz Başla',
                            isLoading: isLoading,
                            onPressed: isLoading ? null : _onRegisterPressed,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1B4B),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A1E1B4B),
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            style: const TextStyle(fontSize: 15, fontFamily: 'Inter', color: Color(0xFF1E1B4B)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF9490A9), fontSize: 15),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E3F0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool isOutline;

  const _AuthButton({
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      return SizedBox(
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(const Color(0xFF1E1B4B)),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
                return const BorderSide(color: Color(0xFF7C3AED), width: 2);
              }
              return const BorderSide(color: Color(0xFFE5E3F0), width: 2);
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Color(0xFF1E1B4B), strokeWidth: 2),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
        ),
      );
    }

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
        ),
      ),
    );
  }
}
