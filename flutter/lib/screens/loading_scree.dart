// lib/screens/loading_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.05;
  String _statusText = 'Inizializzazione...';

  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  // Fake loading steps: {delay_ms, progress_value, label}
  final List<Map<String, dynamic>> _steps = [
    {'delay': 300,  'value': 0.30, 'label': 'Caricamento parole...'},
    {'delay': 700,  'value': 0.70, 'label': 'Connessione al server...'},
    {'delay': 1200, 'value': 1.00, 'label': 'Pronti!'},
  ];

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _runLoadingSequence();
  }

  void _runLoadingSequence() {
    for (final step in _steps) {
      Future.delayed(
        Duration(milliseconds: step['delay'] as int),
        () {
          if (!mounted) return;
          setState(() {
            _progress = step['value'] as double;
            _statusText = step['label'] as String;
          });
        },
      );
    }

    // Navigate after 100%
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, anim, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: FadeTransition(opacity: anim, child: child),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing fire icon
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Transform.scale(
                  scale: _pulse.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF3D0A00), Color(0xFF1A0505)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.fire.withOpacity(0.5 * _pulse.value),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🔥', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'WORDS FEVER',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 40),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.05, end: _progress),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  builder: (_, value, __) {
                    return Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.fire, AppColors.fireSoft],
                            ),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.fire.withOpacity(0.6),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Percentage + status
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 5, end: _progress * 100),
                duration: const Duration(milliseconds: 350),
                builder: (_, value, __) => Text(
                  '${value.round()}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.fire,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _statusText,
                  key: ValueKey(_statusText),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
