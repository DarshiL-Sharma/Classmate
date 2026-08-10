import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../consoleConstants.dart';

/// A card that reveals a surprise when tapped.
/// Features a touch-driven parallax tilt effect and a confetti burst animation.
class SurpriseCard extends StatefulWidget {
  final VoidCallback onReveal;
  const SurpriseCard({required this.onReveal, super.key});

  @override
  State<SurpriseCard> createState() => _SurpriseCardState();
}

class _SurpriseCardState extends State<SurpriseCard> with TickerProviderStateMixin {
  Offset _tilt = Offset.zero; 
  bool _isRevealed = false;
  late final AnimationController _lock = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final AnimationController _confetti = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  final List<ConfettiParticle> _particles = List.generate(
    18,
        (i) => ConfettiParticle(seed: i),
  );

  @override
  void dispose() {
    _lock.dispose();
    _confetti.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isRevealed) {
      widget.onReveal();
      return;
    }
    setState(() => _isRevealed = true);
    _lock.forward();
    _confetti.forward(from: 0);
  }

  void _updateTilt(Offset localPosition, Size size) {
    final dx = (localPosition.dx / size.width) * 2 - 1;
    final dy = (localPosition.dy / size.height) * 2 - 1;
    setState(() => _tilt = Offset(dx.clamp(-1, 1), dy.clamp(-1, 1)));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, 120);
        return GestureDetector(
          onPanUpdate: (d) => _updateTilt(d.localPosition, size),
          onPanEnd: (_) => setState(() => _tilt = Offset.zero),
          onTap: _handleTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateX(_tilt.dy * 0.18)
              ..rotateY(-_tilt.dx * 0.18),
            transformAlignment: Alignment.center,
            height: 120,
            decoration: BoxDecoration(
              gradient: DarkColors.surpriseGradient,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 18,
                  offset: Offset(_tilt.dx * 6, 10 + _tilt.dy * 6),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.35 - _tilt.distance * 0.1),
                  blurRadius: 30,
                  spreadRadius: -10,
                  offset: Offset(-_tilt.dx * 20, -_tilt.dy * 20),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _lock,
                      builder: (context, child) {
                        final angle = _lock.value * math.pi;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateX(angle),
                          child: Icon(
                            _lock.value > 0.5 ? Icons.drafts_rounded : Icons.mail_lock_rounded,
                            color: const Color(0xFF4A2E52),
                            size: 30,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRevealed ? 'Tap to open' : 'Surprise for you',
                      style: const TextStyle(
                          color: Color(0xFF2E2140), fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (!_isRevealed)
                      const Text('Tap to reveal',
                          style: TextStyle(color: Color(0xFF5B4B66), fontSize: 11)),
                  ],
                ),
                AnimatedBuilder(
                  animation: _confetti,
                  builder: (context, _) => CustomPaint(
                    size: Size.infinite,
                    painter: ConfettiPainter(progress: _confetti.value, particles: _particles),
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

class ConfettiParticle {
  final double angle;
  final double distance;
  final double size;
  final Color color;
  final double delay;
  ConfettiParticle({required int seed})
      : angle = (seed * 47 % 360) * math.pi / 180,
        distance = 30.0 + (seed * 13 % 40),
        size = 4.0 + (seed % 4),
        delay = (seed % 5) * 0.06,
        color = const [
          Color(0xFFFF99C8),
          Color(0xFFA9DEF9),
          Color(0xFFFFE066),
          Color(0xFFB794F6),
          Color(0xFF8BE9C1),
        ][seed % 5];
}

class ConfettiPainter extends CustomPainter {
  final double progress;
  final List<ConfettiParticle> particles;
  ConfettiPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    for (final p in particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final eased = Curves.easeOut.transform(t);
      final travel = p.distance * (1 + eased * 1.8);
      final dx = math.cos(p.angle) * travel;
      final dy = math.sin(p.angle) * travel - (eased * 40);
      final opacity = (1 - eased).clamp(0.0, 1.0);
      final paint = Paint()..color = p.color.withOpacity(opacity);
      canvas.drawCircle(center + Offset(dx, dy), p.size * (1 - eased * 0.3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
