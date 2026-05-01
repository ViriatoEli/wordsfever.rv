import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 3000), _toHome);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _toHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background glow
          Center(
            child: AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.fire
                          .withOpacity(0.08 + 0.04 * _pulseCtrl.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fire icon with glow
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, child) => Transform.scale(
                    scale: 1.0 + 0.04 * _pulseCtrl.value,
                    child: child,
                  ),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF3D0A00), Color(0xFF1A0505)],
                      ),
                      border: Border.all(
                        color: AppColors.fire.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.fire.withOpacity(0.4),
                          blurRadius: 50,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🔥', style: TextStyle(fontSize: 52)),
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 28),

                // WORDS FEVER
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppColors.fire, AppColors.fireSoft, AppColors.fireGold],
                  ).createShader(b),
                  child: const Text(
                    'WORDS FEVER',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, curve: Curves.easeOutCubic),

                const SizedBox(height: 10),

                const Text(
                  'IL PARTY GAME ITALIANO',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                  ),
                )
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 48),

                // Loading dots
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.fire.withOpacity(0.7),
                      ),
                    )
                        .animate(
                          onPlay: (ctrl) => ctrl.repeat(reverse: true),
                          delay: Duration(milliseconds: 800 + i * 150),
                        )
                        .scaleXY(
                          begin: 0.5,
                          end: 1.0,
                          duration: 400.ms,
                          curve: Curves.easeInOut,
                        )
                        .fadeIn(duration: 300.ms);
                  }),
                ),
              ],
            ),
          ),

          // Version bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: const Text(
              'v1.0.0  ·  Classe 4I  ·  2026',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                letterSpacing: 1.5,
              ),
            ).animate(delay: 1000.ms).fadeIn(duration: 500.ms),
          ),
        ],
      ),
    );
  }
}
