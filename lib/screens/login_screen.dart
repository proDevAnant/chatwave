import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animations.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  late final AnimationController _bgCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  late final AnimationController _logoCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bgCtrl.dispose();
    _logoCtrl.dispose();
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_user.text.trim().isEmpty || _pass.text.isEmpty) {
      _snack('Username aur password bharein');
      return;
    }
    setState(() => _loading = true);
    try {
      final user = await ApiService.login(_user.text.trim(), _pass.text);
      await AuthService.save(user);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      _snack(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textDark,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + 2 * _bgCtrl.value, -1),
                    end: Alignment(1 - 2 * _bgCtrl.value, 1),
                    colors: const [
                      Color(0xFF41BEFA),
                      Color(0xFF2091D4),
                      Color(0xFF7C4DFF),
                    ],
                  ),
                ),
              );
            },
          ),
          ..._buildBubbles(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 46),
                  AnimatedBuilder(
                    animation: _logoCtrl,
                    builder: (context, child) {
                      final scale = 1 + 0.06 * sin(_logoCtrl.value * pi);
                      final angle = 0.05 * sin(_logoCtrl.value * pi * 2);
                      return Transform.rotate(
                        angle: angle,
                        child: Transform.scale(scale: scale, child: child),
                      );
                    },
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded,
                          size: 46, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FadeSlideIn(
                    delayMs: 100,
                    child: Column(
                      children: [
                        const Text('Wapas aapka swagat hai',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Login karke chatting shuru karein',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeSlideIn(
                    delayMs: 250,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 22),
                      padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _field(_user, 'Username', Icons.alternate_email),
                          const SizedBox(height: 16),
                          _field(_pass, 'Password', Icons.lock_outline,
                              obscure: _obscure,
                              suffix: IconButton(
                                icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textLight),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              )),
                          const SizedBox(height: 24),
                          _gradientButton('Login', _loading ? null : _login),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeSlideIn(
                    delayMs: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Naye ho? ',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9))),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(_fadeRoute(const RegisterScreen())),
                          child: const Text('Account banayein',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _fadeRoute(Widget page) => PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      );

  List<Widget> _buildBubbles() {
    final specs = [
      [0.10, 0.15, 70.0, 0.10],
      [0.75, 0.08, 110.0, 0.08],
      [0.85, 0.55, 60.0, 0.10],
      [0.05, 0.70, 90.0, 0.07],
      [0.50, 0.85, 130.0, 0.06],
    ];
    return specs.map((s) {
      final left = s[0];
      final top = s[1];
      final size = s[2];
      final opacity = s[3];
      return AnimatedBuilder(
        animation: _bgCtrl,
        builder: (context, _) {
          final dy = 22 * sin((_bgCtrl.value + left) * pi * 2);
          return Positioned(
            left: MediaQuery.of(context).size.width * left,
            top: MediaQuery.of(context).size.height * top + dy,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _field(TextEditingController c, String hint, IconData icon,
      {bool obscure = false, Widget? suffix}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.scaffold,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _gradientButton(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: _loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
      ),
    );
  }
}
