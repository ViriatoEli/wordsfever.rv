// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ── Game Mode Data ────────────────────────────────────────────────────────────
class _GameMode {
  final String emoji;
  final String name;
  final String description;
  final Color accent;
  final String route; // Future routing

  const _GameMode({
    required this.emoji,
    required this.name,
    required this.description,
    required this.accent,
    required this.route,
  });
}

const _modes = [
  _GameMode(
    emoji: '🧠',
    name: 'Indovina la parola',
    description: "L'originale e divertente",
    accent: AppColors.modeIndovina,
    route: '/indovina',
  ),
  _GameMode(
    emoji: '💣',
    name: 'Bomb Word',
    description: 'A chi scoppierà?',
    accent: AppColors.modeBomb,
    route: '/bomb',
  ),
  _GameMode(
    emoji: '🕵️',
    name: 'Impostor',
    description: 'Chi è l\'impostore tra di voi?',
    accent: AppColors.modeImpostor,
    route: '/impostor',
  ),
  _GameMode(
    emoji: '💬',
    name: 'Spiega la parola',
    description: 'Aiuta il tuo compagno con parole diverse',
    accent: AppColors.modeSpiega,
    route: '/spiega',
  ),
];

// ── HomeScreen ────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Bar ──
            _TopBar(animation: _ctrl),

            const SizedBox(height: 8),

            // ── Welcome ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) {
                  final t = CurvedAnimation(
                    parent: _ctrl,
                    curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
                  );
                  return Opacity(
                    opacity: t.value,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - t.value)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SCEGLI',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              height: 1,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (b) => const LinearGradient(
                              colors: [AppColors.fire, AppColors.fireSoft],
                            ).createShader(b),
                            child: const Text(
                              'LA MODALITÀ',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ── Mode Cards ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: _modes.length,
                itemBuilder: (_, i) {
                  final delay = 0.15 + i * 0.1;
                  return AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) {
                      final t = CurvedAnimation(
                        parent: _ctrl,
                        curve: Interval(
                          delay, (delay + 0.4).clamp(0.0, 1.0),
                          curve: Curves.easeOut,
                        ),
                      );
                      return Opacity(
                        opacity: t.value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - t.value)),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ModeCard(mode: _modes[i]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final AnimationController animation;
  const _TopBar({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final t = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        );
        return Opacity(
          opacity: t.value,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppColors.fire, AppColors.fireSoft],
                  ).createShader(b),
                  child: const Text(
                    'WORDS FEVER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Settings button
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Impostazioni — Coming soon!'),
                        backgroundColor: AppColors.surface,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Mode Card ─────────────────────────────────────────────────────────────────
class _ModeCard extends StatefulWidget {
  final _GameMode mode;
  const _ModeCard({required this.mode});

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // TODO: Navigate to game mode
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.mode.name} — Coming soon!'),
            backgroundColor: AppColors.surface,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _pressed
                  ? widget.mode.accent.withOpacity(0.4)
                  : AppColors.border,
              width: 1,
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: widget.mode.accent.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Top accent line
              Positioned(
                top: 0, left: 20, right: 20,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.mode.accent.withOpacity(0),
                        widget.mode.accent,
                        widget.mode.accent.withOpacity(0),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(2),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Emoji container
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: widget.mode.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: widget.mode.accent.withOpacity(0.25),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.mode.emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.mode.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.mode.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow
                    Icon(
                      Icons.chevron_right_rounded,
                      color: widget.mode.accent.withOpacity(0.6),
                      size: 22,
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
}
