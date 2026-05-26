import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that applies a 3D tilt/parallax effect on mouse hover.
/// On mobile it gently auto-animates the tilt.
class TiltCard extends StatefulWidget {
  final Widget child;
  final double maxTilt; // degrees
  final double perspective;

  const TiltCard({
    super.key,
    required this.child,
    this.maxTilt = 8.0,
    this.perspective = 800.0,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard>
    with SingleTickerProviderStateMixin {
  double _rotateX = 0;
  double _rotateY = 0;
  late AnimationController _autoController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // Auto gentle float animation for mobile
    _autoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _autoController.addListener(() {
      if (!_isHovered) {
        final t = _autoController.value;
        setState(() {
          _rotateX = math.sin(t * math.pi) * 3.0;
          _rotateY = math.cos(t * math.pi * 0.7) * 3.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final localPos = box.globalToLocal(event.position);

    final dx = (localPos.dx / size.width - 0.5) * 2; // -1 to 1
    final dy = (localPos.dy / size.height - 0.5) * 2; // -1 to 1

    setState(() {
      _isHovered = true;
      _rotateY = dx * widget.maxTilt;
      _rotateX = -dy * widget.maxTilt;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
      _rotateX = 0;
      _rotateY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: AnimatedContainer(
        duration: _isHovered
            ? Duration.zero
            : const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 1 / widget.perspective)
            ..rotateX(_rotateX * math.pi / 180)
            ..rotateY(_rotateY * math.pi / 180),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Floating particle dots for background effect
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<_Particle> _particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final rng = math.Random();
    _particles = List.generate(
      60,
          (i) => _Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: rng.nextDouble() * 2 + 0.5,
        speed: rng.nextDouble() * 0.2 + 0.05,
        opacity: rng.nextDouble() * 0.4 + 0.1,
        colorIndex: i % 3,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        for (final p in _particles) {
          p.y -= p.speed * 0.003;
          if (p.y < 0) p.y = 1.0;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(_particles),
      child: const SizedBox.expand(),
    );
  }
}

class _Particle {
  double x, y, size, speed, opacity;
  int colorIndex;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.colorIndex,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  static const colors = [
    Color(0xFF00D4FF),
    Color(0xFF7B2FFF),
    Color(0xFF00FF88),
  ];

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = colors[p.colorIndex].withOpacity(p.opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}