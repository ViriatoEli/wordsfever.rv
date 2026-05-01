// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _flameCtrl;

  late Animation<double> _rvScale;
  late Animation<double> _rvOpacity;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _versionFade;
  late Animation<double> _flamePulse;

  @override
  void initState() {
    super.initState();

    // RV logo: scale in + fade in
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _rvScale = CurvedAnimation(
      parent: _scaleCtrl,
      curve: Curves.elasticOut,
    );

    _rvOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Title + version: fade/slide in after RV
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _versionFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Flame pulse — continuous
    _flameCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _flamePulse = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _flameCtrl, curve: Curves.easeInOut),
    );

    // Sequence: RV → title → navigate
    _scaleCtrl.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _fadeCtrl.forward();
      });
    });

    // Navigate after ~2.8s total
    Future.delayed(const Duration(milliseconds: 2800), _navigateToAuth);
  }

  void _navigateToAuth() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AuthScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _fadeCtrl.dispose();
    _flameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background radial glow
          Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x443D0A00),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // RV Logo
                FadeTransition(
                  opacity: _rvOpacity,
                  child: ScaleTransition(
                    scale: _rvScale,
                    child: const _RVLogo(),
                  ),
                ),

                const SizedBox(height: 16),

                // Words Fever title
                FadeTransition(
                  opacity: _titleFade,
                  child: SlideTransition(
                    position: _titleSlide,
                    child: Text(
                      'WORDS FEVER',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: AppColors.textPrimary,
                        shadows: [
                          Shadow(
                            color: AppColors.fire.withOpacity(0.4),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Flame bars
                AnimatedBuilder(
                  animation: _flamePulse,
                  builder: (_, __) => _FlameBars(scale: _flamePulse.value),
                ),
              ],
            ),
          ),

          // Version bottom
          Positioned(
            bottom: 48,
            left: 0, right: 0,
            child: FadeTransition(
              opacity: _versionFade,
              child: const Text(
                'v1.0.0  ·  2026  ·  Classe 4I',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── RV Logo Widget ──────────────────────────────────────────────────────────
class _RVLogo extends StatelessWidget {
  const _RVLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF3D0A00), Color(0xFF1A0505)],
        ),
        border: Border.all(color: AppColors.fire.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.fire.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'RV',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppColors.fire,
            letterSpacing: 4,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ── Flame Bars ───────────────────────────────────────────────────────────────
class _FlameBars extends StatelessWidget {
  final double scale;
  const _FlameBars({required this.scale});

  @override
  Widget build(BuildContext context) {
    final heights = [18.0, 28.0, 22.0, 32.0, 20.0, 28.0, 16.0];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(heights.length, (i) {
        final delay = i * 0.1;
        final h = heights[i] * (0.7 + 0.3 * ((scale + delay) % 1.0));
        return Container(
          width: 5,
          height: h.clamp(10.0, 40.0),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.fire,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
