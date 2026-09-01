import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';

/// Vector-painted luxury brand monogram badge for ILAVIYA.
class SplashBrandLogo extends StatelessWidget {
  final double size;
  final bool animateGlow;

  const SplashBrandLogo({
    super.key,
    this.size = 110,
    this.animateGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer subtle gold glow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: SplashTheme.goldPrimary.withValues(alpha: 0.25),
                  blurRadius: size * 0.35,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Custom Painted Geometric Monogram Badge
          CustomPaint(
            size: Size(size, size),
            painter: _LuxuryMonogramPainter(),
          ),
        ],
      ),
    );
  }
}

class _LuxuryMonogramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;

    // 1. Draw outer gradient ring
    final ringPaint = Paint()
      ..shader = SplashTheme.goldGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, ringPaint);

    // 2. Draw inner concentric thin border
    final innerRingPaint = Paint()
      ..color = SplashTheme.goldPrimary.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawCircle(center, radius - 5.0, innerRingPaint);

    // 3. Draw 4 cardinal accent dots on the ring
    final dotPaint = Paint()
      ..shader = SplashTheme.goldGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    const dotRadius = 1.8;
    canvas.drawCircle(Offset(center.dx, center.dy - radius), dotRadius, dotPaint);
    canvas.drawCircle(Offset(center.dx, center.dy + radius), dotRadius, dotPaint);
    canvas.drawCircle(Offset(center.dx - radius, center.dy), dotRadius, dotPaint);
    canvas.drawCircle(Offset(center.dx + radius, center.dy), dotRadius, dotPaint);

    // 4. Draw stylized luxury monogram "I • V"
    final strokePaint = Paint()
      ..shader = SplashTheme.goldGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.035;

    // Central Pillar / Serif Line for "I"
    final pTop = Offset(center.dx, center.dy - radius * 0.52);
    final pBottom = Offset(center.dx, center.dy + radius * 0.35);
    canvas.drawLine(pTop, pBottom, strokePaint);

    // Top horizontal crossbar for "I"
    canvas.drawLine(
      Offset(center.dx - radius * 0.25, pTop.dy),
      Offset(center.dx + radius * 0.25, pTop.dy),
      strokePaint,
    );

    // Diagonal lines forming modern "V" intertwining
    final vPath = Path();
    vPath.moveTo(center.dx - radius * 0.45, center.dy - radius * 0.25);
    vPath.lineTo(center.dx, center.dy + radius * 0.55);
    vPath.lineTo(center.dx + radius * 0.45, center.dy - radius * 0.25);

    canvas.drawPath(vPath, strokePaint);

    // Small center diamond accent
    final diamondPath = Path();
    const dSize = 3.0;
    diamondPath.moveTo(center.dx, center.dy - dSize);
    diamondPath.lineTo(center.dx + dSize, center.dy);
    diamondPath.lineTo(center.dx, center.dy + dSize);
    diamondPath.lineTo(center.dx - dSize, center.dy);
    diamondPath.close();

    final diamondPaint = Paint()
      ..color = SplashTheme.goldLight
      ..style = PaintingStyle.fill;
    canvas.drawPath(diamondPath, diamondPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
