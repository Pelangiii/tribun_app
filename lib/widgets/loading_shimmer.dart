import 'dart:math'; // Fix pi, jangan lupa!
import 'package:flutter/material.dart';

class MinimalLoadingIndicator extends StatefulWidget {
  const MinimalLoadingIndicator({super.key});

  @override
  State<MinimalLoadingIndicator> createState() => _MinimalLoadingIndicatorState();
}

class _MinimalLoadingIndicatorState extends State<MinimalLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Lebih lambat biar smooth kayak video
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 20, 134, 227).withOpacity(0.4),
      end: const Color.fromARGB(255, 37, 98, 205).withOpacity(0.8), // Full biru biar match gambar
    ).animate(_controller);

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center( 
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Ini yang bikin teks & spinner tepat tengah
              children: [
                // Spinner arc biru dengan glow (custom painter biar arc presisi kayak gambar)
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _colorAnimation.value ?? Colors.transparent,
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: ArcSpinnerPainter(
                      color: _colorAnimation.value ?? Colors.blue,
                      opacity: _opacityAnimation.value,
                      progress: (_controller.value * 0.75 + 0.25) % 1.0, // Arc dari 25% ke 100% biar semi-lengkung
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Painter buat arc spinner biru (tetep sama)
class ArcSpinnerPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final double progress;

  ArcSpinnerPainter({
    required this.color,
    required this.opacity,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - paint.strokeWidth / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Mulai dari atas
      2 * pi * progress, // Panjang arc dinamis (semi-lengkung berputar)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}