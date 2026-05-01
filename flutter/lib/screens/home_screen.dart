import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_background.dart';
import 'indovina/indovina_setup_screen.dart';
import 'bomb/bomb_setup_screen.dart';
import 'impostor/impostor_setup_screen.dart';
import 'spiega/spiega_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShaderMask(
                          shaderCallback: (b) => const LinearGradient(
                            colors: [AppColors.fire, AppColors.fireSoft],
                          ).createShader(b),
                          child: const Text(
                            '🔥 WORDS FEVER',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.fire.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.fire.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'v1.0.0',
                            style: TextStyle(
                              color: AppColors.fire,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3),

                    const SizedBox(height: 28),

                    const Text(
                      'SCEGLI',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        height: 1,
                        color: AppColors.textPrimary,
                      ),
                    ).animate(delay: 150.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3),

                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [AppColors.fire, AppColors.fireSoft, AppColors.fireGold],
                      ).createShader(b),
                      child: const Text(
                        'LA TUA ARMA',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          height: 1,
                          color: Colors.white,
                        ),
                      ),
                    ).animate(delay: 250.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3),

                    const SizedBox(height: 8),

                    const Text(
                      '4 modalità. 1 telefono. Serata perfetta.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ).animate(delay: 350.ms).fadeIn(duration: 500.ms),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Mode cards ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  children: [
                    _ModeCard(
                      delay: 400,
                      emoji: '🧠',
                      title: 'INDOVINA LA PAROLA',
                      subtitle: 'Taboo-style • 2-8 giocatori',
                      description:
                          'Spiega la parola senza dirla né usare quelle vietate. Il team indovina e guadagna punti.',
                      accent: AppColors.modeIndovina,
                      onTap: () => _push(context, const IndovinaSetupScreen()),
                    ),
                    _ModeCard(
                      delay: 500,
                      emoji: '💣',
                      title: 'BOMB WORD',
                      subtitle: 'Hot potato • 3-8 giocatori',
                      description:
                          'Il telefono è una bomba a orologeria. Dì una parola della categoria e passalo in fretta — o perdi una vita.',
                      accent: AppColors.modeBomb,
                      onTap: () => _push(context, const BombSetupScreen()),
                    ),
                    _ModeCard(
                      delay: 600,
                      emoji: '🕵️',
                      title: "L'IMPOSTORE",
                      subtitle: 'Social deduction • 4-10 giocatori',
                      description:
                          'Tutti ricevono la stessa parola tranne uno. Scopri chi mente prima che inganni il gruppo.',
                      accent: AppColors.modeImpostor,
                      onTap: () => _push(context, const ImpostorSetupScreen()),
                    ),
                    _ModeCard(
                      delay: 700,
                      emoji: '💬',
                      title: 'SPIEGA LA PAROLA',
                      subtitle: 'Taboo a squadre • 4+ giocatori',
                      description:
                          'Due squadre si sfidano. Un giocatore spiega, la squadra indovina. Vince chi guadagna più punti.',
                      accent: AppColors.modeSpiega,
                      onTap: () => _push(context, const SpiegaSetupScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _push(BuildContext ctx, Widget screen) {
    HapticFeedback.mediumImpact();
    Navigator.of(ctx).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    );
  }
}

// ── Mode Card ─────────────────────────────────────────────────────────────────
class _ModeCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String description;
  final Color accent;
  final VoidCallback onTap;
  final int delay;

  const _ModeCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accent,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        HapticFeedback.selectionClick();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 14),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.bg3
              : AppColors.bg2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _pressed
                ? widget.accent.withOpacity(0.45)
                : AppColors.border,
            width: 1.5,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: widget.accent.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Accent left stripe
            Container(
              width: 4,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.accent,
                    widget.accent.withOpacity(0.2),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Emoji
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: widget.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: widget.accent.withOpacity(0.22)),
              ),
              child: Center(
                child: Text(widget.emoji,
                    style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: widget.accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded,
                  color: widget.accent.withOpacity(0.6), size: 24),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.delay)).fadeIn(duration: 400.ms).slideY(begin: 0.25);
  }
}
