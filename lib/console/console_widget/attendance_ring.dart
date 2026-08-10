import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../consoleConstants.dart';

/// A circular attendance tracker with a liquid-wave filling animation.
/// Automatically adjusts colors based on the attendance percentage.
class GradientAttendanceRing extends StatefulWidget {
  final double percentage;
  const GradientAttendanceRing({required this.percentage, super.key});

  @override
  State<GradientAttendanceRing> createState() => _GradientAttendanceRingState();
}

class _GradientAttendanceRingState extends State<GradientAttendanceRing>
    with TickerProviderStateMixin {
  late final AnimationController _fill = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  late final Animation<double> _fillAnim =
  CurvedAnimation(parent: _fill, curve: Curves.elasticOut);
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fill.forward());
  }

  @override
  void dispose() {
    _fill.dispose();
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLow = widget.percentage < 75;
    final colors = isLow ? DarkColors.attendanceLow : DarkColors.attendanceGood;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: DarkColors.surface, borderRadius: BorderRadius.circular(30)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 76,
            height: 76,
            child: AnimatedBuilder(
              animation: Listenable.merge([_fillAnim, _wave]),
              builder: (context, _) {
                final progress = (widget.percentage / 100) *
                    _fillAnim.value.clamp(0.0, 1.4); 
                return CustomPaint(
                  painter: LiquidRingPainter(
                    progress: progress.clamp(0.0, 1.0),
                    colors: colors,
                    strokeWidth: 8,
                    wavePhase: _wave.value * 2 * math.pi,
                    settled: _fill.isCompleted,
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _fillAnim,
            builder: (context, child) {
              final shown = (widget.percentage * _fillAnim.value.clamp(0.0, 1.0)).clamp(0.0, widget.percentage);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${shown.toInt()}%',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: colors.first)),
                  const Text('Attd.',
                      style: TextStyle(fontSize: 10, color: DarkColors.textDim, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// The custom painter that draws the liquid wave effect inside the attendance ring.
class LiquidRingPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;
  final double wavePhase;
  final bool settled;
  LiquidRingPainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
    required this.wavePhase,
    required this.settled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = colors.first.withOpacity(0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * math.pi,
      colors: colors,
      transform: const GradientRotation(-math.pi / 2),
    );

    final waveAmplitude = settled ? 0.0 : math.sin(wavePhase) * 1.5;
    final fgPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + waveAmplitude
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant LiquidRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.wavePhase != wavePhase ||
          oldDelegate.colors != colors;
}
