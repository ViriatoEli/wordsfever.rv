import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/fire_button.dart';
import '../../models/player.dart';
import '../../data/word_data.dart';
import 'indovina_game_screen.dart';

class IndovinaSetupScreen extends StatefulWidget {
  const IndovinaSetupScreen({super.key});

  @override
  State<IndovinaSetupScreen> createState() => _IndovinaSetupScreenState();
}

class _IndovinaSetupScreenState extends State<IndovinaSetupScreen> {
  final List<TextEditingController> _names = [
    TextEditingController(),
    TextEditingController(),
  ];
  String _category = 'Tutti';
  int _timerSec = 60;

  final List<int> _timerOptions = [30, 60, 90];
  final List<String> _categories = ['Tutti', ...WordData.categoryNames];

  @override
  void dispose() {
    for (final c in _names) c.dispose();
    super.dispose();
  }

  void _addPlayer() {
    if (_names.length < 8) {
      setState(() => _names.add(TextEditingController()));
    }
  }

  void _removePlayer(int i) {
    if (_names.length > 2) {
      setState(() {
        _names[i].dispose();
        _names.removeAt(i);
      });
    }
  }

  void _start() {
    final names = _names
        .map((c) => c.text.trim())
        .where((n) => n.isNotEmpty)
        .toList();
    if (names.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Servono almeno 2 giocatori!'),
      ));
      return;
    }
    HapticFeedback.mediumImpact();
    final players = names.map((n) => Player(name: n)).toList();
    final words = WordData.getTabooCards(
      category: _category == 'Tutti' ? null : _category,
      limit: players.length * 8,
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => IndovinaGameScreen(
        players: players,
        wordList: words,
        timerSeconds: _timerSec,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        accent: AppColors.modeIndovina,
        child: SafeArea(
          child: Column(
            children: [
              // ── App bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary),
                    ),
                    const Text(
                      '🧠  INDOVINA LA PAROLA',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: AppColors.modeIndovina,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text(
                      'IMPOSTAZIONI',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Aggiungi i giocatori e scegli le opzioni di gioco.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                    const SizedBox(height: 28),

                    // Players
                    _sectionLabel('GIOCATORI', Icons.people_outline),
                    const SizedBox(height: 10),
                    ...List.generate(_names.length, (i) {
                      final colors = [
                        AppColors.modeIndovina, AppColors.modeBomb,
                        AppColors.modeImpostor, AppColors.modeSpiega,
                        AppColors.fireSoft, AppColors.fireGold,
                        AppColors.success, AppColors.warning,
                      ];
                      return _PlayerField(
                        ctrl: _names[i],
                        index: i,
                        color: colors[i % colors.length],
                        canRemove: _names.length > 2,
                        onRemove: () => _removePlayer(i),
                      );
                    }),
                    if (_names.length < 8)
                      _AddPlayerButton(onTap: _addPlayer),
                    const SizedBox(height: 28),

                    // Category
                    _sectionLabel('CATEGORIA', Icons.category_outlined),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((c) {
                        final sel = c == _category;
                        return GestureDetector(
                          onTap: () => setState(() => _category = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.modeIndovina.withOpacity(0.2)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: sel
                                    ? AppColors.modeIndovina
                                    : AppColors.border,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              c,
                              style: TextStyle(
                                color: sel
                                    ? AppColors.modeIndovina
                                    : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // Timer
                    _sectionLabel('TEMPO PER TURNO', Icons.timer_outlined),
                    const SizedBox(height: 10),
                    Row(
                      children: _timerOptions.map((t) {
                        final sel = t == _timerSec;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _timerSec = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppColors.modeIndovina.withOpacity(0.2)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: sel
                                      ? AppColors.modeIndovina
                                      : AppColors.border,
                                  width: sel ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$t',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: sel
                                          ? AppColors.modeIndovina
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'sec',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: sel
                                          ? AppColors.modeIndovina
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),

                    FireButton(
                      label: 'INIZIA IL GIOCO',
                      color: AppColors.modeIndovina,
                      width: double.infinity,
                      height: 60,
                      icon: Icons.play_arrow_rounded,
                      onTap: _start,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.modeIndovina),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.modeIndovina,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Player field ──────────────────────────────────────────────────────────────
class _PlayerField extends StatelessWidget {
  final TextEditingController ctrl;
  final int index;
  final Color color;
  final bool canRemove;
  final VoidCallback onRemove;

  const _PlayerField({
    required this.ctrl,
    required this.index,
    required this.color,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.18),
              border: Border.all(color: color.withOpacity(0.35)),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: ctrl,
              maxLength: 14,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Giocatore ${index + 1}',
                counterText: '',
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          if (canRemove) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.remove_circle_outline,
                  color: AppColors.textMuted, size: 22),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddPlayerButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPlayerButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.modeIndovina.withOpacity(0.3), width: 1.5),
          color: AppColors.modeIndovina.withOpacity(0.05),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline,
                color: AppColors.modeIndovina, size: 18),
            SizedBox(width: 8),
            Text(
              'Aggiungi giocatore',
              style: TextStyle(
                color: AppColors.modeIndovina,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
