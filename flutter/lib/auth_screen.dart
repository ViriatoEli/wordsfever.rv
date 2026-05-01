// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'loading_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _fadeAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // Stagger 5 elements
    _fadeAnims = List.generate(5, (i) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(i * 0.12, i * 0.12 + 0.5, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onPlayGuest() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoadingScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Background glow top
            Positioned(
              top: -60,
              left: MediaQuery.of(context).size.width / 2 - 150,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x33FF4D1C), Colors.transparent],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo circle
                  _FadeItem(
                    animation: _fadeAnims[0],
                    child: Container(
                      width: 96,
                      height: 96,
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
                            color: AppColors.fire.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🔥',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // App name
                  _FadeItem(
                    animation: _fadeAnims[1],
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.fire, AppColors.fireSoft],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'WORDS FEVER',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Payoff
                  _FadeItem(
                    animation: _fadeAnims[2],
                    child: Text(
                      'Il tuo gioco preferito per una serata\ntra amici e famiglia. Divertiti!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Buttons
                  _FadeItem(
                    animation: _fadeAnims[3],
                    child: Column(
                      children: [
                        // GIOCA button
                        _AuthButton(
                          label: 'GIOCA',
                          emoji: '🎮',
                          isPrimary: true,
                          onTap: _onPlayGuest,
                        ),

                        const SizedBox(height: 12),

                        // Google
                        _AuthButton(
                          label: 'Accedi con Google',
                          customIcon: _GoogleIcon(),
                          onTap: () {}, // TODO: implement
                        ),

                        const SizedBox(height: 10),

                        // Facebook
                        _AuthButton(
                          label: 'Accedi con Facebook',
                          customIcon: _FacebookIcon(),
                          onTap: () {}, // TODO: implement
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Footer hint
                  _FadeItem(
                    animation: _fadeAnims[4],
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Giocando accetti i Termini di Servizio',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted.withOpacity(0.5),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Auth Button ───────────────────────────────────────────────────────────────
class _AuthButton extends StatefulWidget {
  final String label;
  final String? emoji;
  final Widget? customIcon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _AuthButton({
    required this.label,
    this.emoji,
    this.customIcon,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  State<_AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<_AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: widget.isPrimary ? 58 : 50,
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    colors: [AppColors.fire, AppColors.fireSoft],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: widget.isPrimary ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: widget.isPrimary
                ? null
                : Border.all(color: AppColors.border, width: 1),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.fire.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.emoji != null) ...[
                Text(widget.emoji!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
              ],
              if (widget.customIcon != null) ...[
                widget.customIcon!,
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.isPrimary ? 17 : 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: widget.isPrimary ? 2.0 : 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Fade Wrapper ──────────────────────────────────────────────────────────────
class _FadeItem extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const _FadeItem({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: child,
        ),
      ),
    );
  }
}

// ── Social Icons ──────────────────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20, height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Simplified: just 4-color circle
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -1.57, 1.57, true, paint);
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
        0, 1.57, true, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
        1.57, 1.57, true, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
        3.14, 1.57, true, paint);

    // Inner white circle
    paint.color = const Color(0xFF1A1A2E);
    canvas.drawCircle(Offset(cx, cy), r * 0.55, paint);

    // G notch (simplified)
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(cx - 0.5, cy - r * 0.3, r * 0.8, r * 0.25),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF1877F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}
