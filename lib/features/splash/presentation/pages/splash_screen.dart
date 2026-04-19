import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _barController;
  late AnimationController _fadeController;

  late Animation<double> _fadeIn;
  late Animation<double> _bar1;
  late Animation<double> _bar2;
  late Animation<double> _bar3;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeIn = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _bar1 = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4), weight: 50),
    ]).animate(CurvedAnimation(parent: _barController, curve: Curves.easeInOut));

    _bar2 = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4), weight: 50),
    ]).animate(CurvedAnimation(
      parent: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )
        ..repeat()
        ..value = 0.17,
      curve: Curves.easeInOut,
    ));

    _bar3 = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4), weight: 50),
    ]).animate(CurvedAnimation(
      parent: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )
        ..repeat()
        ..value = 0.33,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();

    // After 3 seconds, move to the dashboard. 
    // GoRouter's redirect logic will then decide if the user needs to log in first.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/dashboard');
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C16),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 36),
              _buildAppName(),
              const SizedBox(height: 8),
              _buildTagline(),
              const SizedBox(height: 64),
              _buildBarsLoader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1624),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2D45), width: 1),
      ),
      child: CustomPaint(
        painter: _ChartIconPainter(),
      ),
    );
  }

  Widget _buildAppName() {
    return const Text(
      'CryptoAI',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Color(0xFFFFFFFF),
        letterSpacing: -0.6,
        height: 1,
      ),
    );
  }

  Widget _buildTagline() {
    return const Text(
      'Smart Investment Tracker',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFF7C8FA8),
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _buildBarsLoader() {
    return AnimatedBuilder(
      animation: _barController,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _bar(scale: _bar1.value, maxH: 24, opacity: 1.0),
            const SizedBox(width: 10),
            _bar(scale: _bar2.value, maxH: 32, opacity: 0.65),
            const SizedBox(width: 10),
            _bar(scale: _bar3.value, maxH: 18, opacity: 0.4),
          ],
        );
      },
    );
  }

  Widget _bar({
    required double scale,
    required double maxH,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 4,
        height: (maxH * scale).clamp(2.0, maxH), // Ensure minimum visibility
        decoration: BoxDecoration(
          color: const Color(0xFF7C73FF),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _ChartIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF7C73FF)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final baselinePaint = Paint()
      ..color = const Color(0xFF1E2D45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF7C73FF)
      ..style = PaintingStyle.fill;

    // Scale factor from original 34x34 viewBox
    final scaleX = size.width / 34;
    final scaleY = size.height / 34;

    Offset p(double x, double y) => Offset(x * scaleX, y * scaleY);

    // Trend line: points="3,24 11,14 18,18 29,7"
    final path = Path()
      ..moveTo(p(3, 24).dx, p(3, 24).dy)
      ..lineTo(p(11, 14).dx, p(11, 14).dy)
      ..lineTo(p(18, 18).dx, p(18, 18).dy)
      ..lineTo(p(29, 7).dx, p(29, 7).dy);

    canvas.drawPath(path, linePaint);

    // Dot at end of line
    canvas.drawCircle(p(29, 7), 3 * scaleX, dotPaint);

    // Baseline
    canvas.drawLine(p(3, 28), p(31, 28), baselinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
