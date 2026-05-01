import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../models/player.dart';
import '../home_screen.dart';

class IndovinaResultScreen extends StatefulWidget {
  final List<Player> players;
  const IndovinaResultScreen({super.key, required this.players});

  @override
  State<IndovinaResultScreen> createState() => _IndovinaResultScreenState();
}

class _IndovinaResultScreenState extends State<IndovinaResultScreen> {
  late ConfettiController _confetti;
  late List<Player> _sorted;

  @override
  void initState() {
    super.initState();
    _sorted = [...widget.players]
      ..sort((a, b) => b.score.compareTo(a.score));
    _confetti =
        ConfettiController(duration: const Duration(seconds: 4));
    _confetti.play();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final winner = _sorted.first;
    final medals = ['🥇', '🥈', '🥉'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    AppColors.modeIndovina.withOpacity(0.12),
                    AppColors.bg,
                  ],
                ),
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 50,
              gravity: 0.08,
              shouldLoop: false,
              colors: const [
                AppColors.fire,
                AppColors.fireSoft,
                AppColors.fireGold,
                Colors.white,
                AppColors.modeIndovina,
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // ── Winner trophy ──
                  const SizedBox(height: 20),
                  const Text('🏆',
                      style: TextStyle(fontSize: 70))
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                          begin: const Offset(0.92, 0.92),
                          end: const Offset(1.08, 1.08),
                          duration: 1000.ms,
                          curve: Curves.easeInOut),
                  const SizedBox(height: 16),
                  const Text(
                    'GIOCO FINITO!',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.fire, AppColors.fireGold],
                    ).createShader(b),
                    child: Text(
                      winner.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3),
                  Text(
                    'VINCE con ${winner.score} ${winner.score == 1 ? 'punto' : 'punti'}!',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 500.ms),

                  const SizedBox(height: 36),

                  // ── Leaderboard ──
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sorted.length,
                      itemBuilder: (_, i) {
                        final p = _sorted[i];
                        final isWinner = i == 0;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isWinner
                                ? AppColors.modeIndovina.withOpacity(0.12)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isWinner
                                  ? AppColors.modeIndovina.withOpacity(0.4)
                                  : AppColors.border,
                              width: isWinner ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                i < 3 ? medals[i] : '  ${i + 1}.',
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isWinner
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Text(
                                '${p.score} pt',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isWinner
                                      ? AppColors.modeIndovina
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: Duration(milliseconds: 300 + i * 100))
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.3);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const HomeScreen()),
                                  (_) => false),
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Center(
                              child: Text(
                                'MENU',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            final players =
                                widget.players.map((p) => Player(name: p.name)).toList();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => IndovinaResultScreen(
                                        players: players)));
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    AppColors.modeIndovina,
                                    AppColors.fireSoft
                                  ]),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.modeIndovina.withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '🔄  GIOCA ANCORA',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
