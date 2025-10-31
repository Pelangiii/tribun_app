import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // kita ubah jadi animasi "slide + pulse"
    _slideAnimation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutExpo),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _animationController.repeat(reverse: true); // efek berdenyut glow

    _startLoading();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.HOME);
    });
  }

  void _startLoading() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (_progress >= 1) return false;
      setState(() => _progress += 0.02);
      return true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size.infinite, painter: StripeBackgroundPainter()),

          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with shape-following glow effect - simple appearance with pulse only
                  AnimatedOpacity(
                    opacity: _fadeAnimation.value, // Simple fade in
                    duration: const Duration(milliseconds: 1000),
                    child: Transform.scale(
                      scale: _scaleAnimation.value, // Keep subtle pulse
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow layer following logo shape
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Adjust based on logo shape
                            child: Image.asset(
                              'assets/images/earena non bg.png',
                              width: 180,
                              height: 180,
                              color: Colors.transparent,
                              colorBlendMode: BlendMode.dstIn, // Use logo as mask for glow
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.6),
                                    Colors.purple.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Actual logo on top
                          Image.asset(
                            'assets/images/earena non bg.png',
                            width: 180,
                            height: 180,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const SizedBox(height: 60),

                  // Horizontal progress bar with number on top (long line, not circle)
                  Column(
                    children: [
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 200, // Long horizontal bar
                        height: 8, // Thin height for line
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class StripeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF12122A)
      ..strokeWidth = 2;

    for (double y = 0; y < size.height; y += 14) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}