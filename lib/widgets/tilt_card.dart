import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 3D tilt on hover (desktop/web) + gentle auto-float on mobile.
class TiltCard extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final double perspective;

  const TiltCard({
    super.key,
    required this.child,
    this.maxTilt = 7.0,
    this.perspective = 900.0,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard>
    with SingleTickerProviderStateMixin {
  double _rx = 0, _ry = 0;
  bool _hovered = false;
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _floatCtrl.addListener(() {
      if (!_hovered) {
        final t = _floatCtrl.value;
        setState(() {
          _rx = math.sin(t * math.pi) * 2.5;
          _ry = math.cos(t * math.pi * 0.7) * 2.5;
        });
      }
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent e) {
    final box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(e.position);
    final size = box.size;
    final dx = (local.dx / size.width  - 0.5) * 2;
    final dy = (local.dy / size.height - 0.5) * 2;
    setState(() {
      _hovered = true;
      _ry = dx * widget.maxTilt;
      _rx = -dy * widget.maxTilt;
    });
  }

  void _onExit(PointerEvent e) {
    setState(() {
      _hovered = false;
      _rx = 0; _ry = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: AnimatedContainer(
        duration: _hovered
            ? Duration.zero
            : const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 1 / widget.perspective)
            ..rotateX(_rx * math.pi / 180)
            ..rotateY(_ry * math.pi / 180),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Particle background
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});
  @override State<ParticleBackground> createState() => _PBState();
}

class _PBState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late List<_P> _pts;
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    final seed = identityHashCode(this);
    _pts = List.generate(55, (i) => _P(
      x: ((seed * (i + 1) * 1234567) % 1000) / 1000,
      y: ((seed * (i + 2) * 7654321) % 1000) / 1000,
      sz: 0.5 + ((seed * i * 13) % 100) / 55,
      spd: 0.04 + ((seed * i * 7) % 100) / 500,
      op: 0.08 + ((seed * i * 11) % 100) / 360,
      ci: i % 3,
    ));
    _c = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
    _c.addListener(() {
      for (final p in _pts) {
        p.y -= p.spd * 0.003;
        if (p.y < 0) p.y = 1.0;
      }
      if (mounted) setState(() {});
    });
  }

  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _PP(_pts), child: const SizedBox.expand());
  }
}

class _P {
  double x, y, sz, spd, op; int ci;
  _P({required this.x, required this.y, required this.sz,
    required this.spd, required this.op, required this.ci});
}

class _PP extends CustomPainter {
  final List<_P> pts;
  static const _c = [Color(0xFF00D4FF), Color(0xFF7B2FFF), Color(0xFF00FF88)];
  _PP(this.pts);
  @override void paint(Canvas canvas, Size size) {
    for (final p in pts) {
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height), p.sz,
        Paint()
          ..color = _c[p.ci].withOpacity(p.op)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
  }
  @override bool shouldRepaint(_PP _) => true;
}