import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../models/player.dart';
import '../../data/word_data.dart';
import 'indovina_result_screen.dart';

class IndovinaGameScreen extends StatefulWidget {
  final List<Player> players;
  final List<TabooCard> wordList;
  final int timerSeconds;

  const IndovinaGameScreen({
    super.key,
    required this.players,
    required this.wordList,
    required this.timerSeconds,
  });

  @override
  State<IndovinaGameScreen> createState() => _IndovinaGameScreenState();
}

class _IndovinaGameScreenState extends State<IndovinaGameScreen>
    with SingleTickerProviderStateMixin {
  int _playerIndex = 0;
  int _wordIndex = 0;
  bool _passing = true;
  int _secondsLeft = 0;
  Timer? _timer;
  late AnimationController _flashCtrl;
  Color _flashColor = Colors.transparent;
  bool _showFlash = false;

  Player get _current => widget.players[_playerIndex];
  List<TabooCard> get _words => widget.wordList;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.timerSeconds;
    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    // Ensure at least some words
    if (_words.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _endGame());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flashCtrl.dispose();
    super.dispose();
  }

  void _startTurn() {
    setState(() {
      _passing = false;
      _secondsLeft = widget.timerSeconds;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        _endTurn();
      }
    });
  }

  void _correct() {
    _timer?.cancel();
    HapticFeedback.mediumImpact();
    _current.score++;
    _flash(AppColors.success);
    _nextWord();
  }

  void _skip() {
    _timer?.cancel();
    HapticFeedback.lightImpact();
    _flash(AppColors.textMuted);
    _nextWord();
  }

  void _nextWord() {
    _wordIndex++;
    if (_wordIndex >= _words.length) _wordIndex = 0;
    if (_secondsLeft > 0) _startTimer();
  }

  Future<void> _flash(Color color) async {
    setState(() {
      _flashColor = color;
      _showFlash = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _showFlash = false);
  }

  void _endTurn() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();
    if (_playerIndex + 1 >= widget.players.length) {
      _endGame();
    } else {
      setState(() {
        _playerIndex++;
        _passing = true;
        _secondsLeft = widget.timerSeconds;
      });
    }
  }

  void _endGame() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => IndovinaResultScreen(players: widget.players),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(AppColors.bg, AppColors.modeIndovina, 0.06)!,
                  AppColors.bg,
                ],
              ),
            ),
          ),

          // Flash overlay
          if (_showFlash)
            AnimatedOpacity(
              opacity: _showFlash ? 0.15 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(color: _flashColor),
            ),

          SafeArea(
            child: _passing ? _buildPassingScreen() : _buildGameScreen(),
          ),
        ],
      ),
    );
  }

  // ── Passing screen ────────────────────────────────────────────────────────
  Widget _buildPassingScreen() {
    final n = _playerIndex + 1;
    final total = widget.players.length;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TURNO $n/$total',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            Text(
              _current.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3),
            const SizedBox(height: 8),
            const Text(
              'È il tuo turno!\nPremi PRONTO quando hai il telefono.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.6),
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 48),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.modeIndovina.withOpacity(0.12),
                border: Border.all(
                    color: AppColors.modeIndovina.withOpacity(0.3), width: 2),
              ),
              child: const Center(
                child: Text('🧠', style: TextStyle(fontSize: 48)),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1.05, 1.05),
                    duration: 900.ms,
                    curve: Curves.easeInOut),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: _startTurn,
              child: Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.modeIndovina, AppColors.fireSoft],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.modeIndovina.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '✅  PRONTO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }

  // ── Game screen ───────────────────────────────────────────────────────────
  Widget _buildGameScreen() {
    final card = _words[_wordIndex % _words.length];
    final pct = _secondsLeft / widget.timerSeconds;
    final timerColor = pct > 0.5
        ? AppColors.success
        : pct > 0.25
            ? AppColors.warning
            : AppColors.fire;

    return Column(
      children: [
        // ── Top bar ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
              // Timer circle
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: pct.clamp(0, 1),
                      strokeWidth: 5,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation(timerColor),
                    ),
                    Center(
                      child: Text(
                        '$_secondsLeft',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: timerColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _current.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Punteggio: ${_current.score}',
                      style: const TextStyle(
                        color: AppColors.modeIndovina,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  card.category,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Word card ──
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Container(
                key: ValueKey('${card.word}_$_wordIndex'),
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.modeIndovina.withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.modeIndovina.withOpacity(0.12),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.word,
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 1,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: AppColors.border),
                    const SizedBox(height: 16),
                    const Text(
                      '🚫  PAROLE VIETATE',
                      style: TextStyle(
                        color: AppColors.modeIndovina,
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: card.forbidden
                          .map((w) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.bg3,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  w,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Buttons ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Row(
            children: [
              // SALTA
              Expanded(
                child: GestureDetector(
                  onTap: _skip,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        '⏭  SALTA',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // GIUSTO
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _correct,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.success, Color(0xFF16A34A)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '✅  GIUSTO!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
