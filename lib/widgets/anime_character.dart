// lib/widgets/anime_character.dart
//
// Male anime character widget — unique pose per section.
// Pure Flutter CustomPainter — no image assets required.
// Sections: 'home' | 'skills' | 'projects' | 'services' | 'cv' | 'contact'
//
// Usage:
//   AnimeCharacter(section: 'skills', size: r.sp(180))

import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Public Widget ─────────────────────────────────────────────────────────────
class AnimeCharacter extends StatefulWidget {
  final String section;
  final double size;

  const AnimeCharacter({
    super.key,
    required this.section,
    this.size = 160,
  });

  @override
  State<AnimeCharacter> createState() => _AnimeCharacterState();
}

class _AnimeCharacterState extends State<AnimeCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _float;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _float = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _glow = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, _float.value),
          child: SizedBox(
            width: widget.size,
            height: widget.size * 1.15,
            child: CustomPaint(
              painter: _CharacterPainter(
                section: widget.section,
                glowOpacity: _glow.value,
                floatT: _ctrl.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Painter ───────────────────────────────────────────────────────────────────
class _CharacterPainter extends CustomPainter {
  final String section;
  final double glowOpacity;
  final double floatT; // 0..1 animation progress

  const _CharacterPainter({
    required this.section,
    required this.glowOpacity,
    required this.floatT,
  });

  // Palette
  static const _cyan   = Color(0xFF00D4FF);
  static const _purple = Color(0xFF7B2FFF);
  static const _green  = Color(0xFF00FF88);
  static const _orange = Color(0xFFFF6B35);
  static const _bg     = Color(0xFF050A0F);
  static const _skin   = Color(0xFFF5C5A3);
  static const _skinDark = Color(0xFFE0A882);
  static const _white  = Color(0xFFEEF2FF);
  static const _dark   = Color(0xFF0D1520);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (section) {
      case 'home':
        _drawHome(canvas, w, h);
        break;
      case 'skills':
        _drawSkills(canvas, w, h);
        break;
      case 'projects':
        _drawProjects(canvas, w, h);
        break;
      case 'services':
        _drawServices(canvas, w, h);
        break;
      case 'cv':
        _drawCV(canvas, w, h);
        break;
      case 'contact':
        _drawContact(canvas, w, h);
        break;
      default:
        _drawSkills(canvas, w, h);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Paint _fill(Color c) => Paint()
    ..color = c
    ..style = PaintingStyle.fill;

  Paint _stroke(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _glow(Color c) => Paint()
    ..color = c.withOpacity(0.22 * glowOpacity)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

  void _drawGlowCircle(Canvas c, Offset center, double r, Color col) {
    c.drawCircle(center, r, _glow(col));
  }

  // ── Shadow under character
  void _shadow(Canvas canvas, double cx, double by, double w) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, by), width: w, height: w * 0.18),
      paint,
    );
  }

  // ── Common body parts ───────────────────────────────────────────────────────

  /// Draws a simple male head at (cx, cy) with radius [r].
  /// [accentColor] is used for hair streak.
  void _head(Canvas canvas, double cx, double cy, double r,
      {Color hairColor = const Color(0xFF1A1A2E),
        Color accentColor = _cyan,
        bool hasGlasses = false}) {

    // Neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - r * 0.22, cy + r * 0.75, r * 0.44, r * 0.55),
        Radius.circular(r * 0.1),
      ),
      _fill(_skin),
    );

    // Head shape
    final headPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(cx, cy), width: r * 1.9, height: r * 2.05));
    canvas.drawPath(headPath, _fill(_skin));

    // Jaw line slight shade
    final jawPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, _skinDark.withOpacity(0.3)],
      ).createShader(Rect.fromCenter(
          center: Offset(cx, cy + r * 0.6), width: r * 2, height: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.6), width: r * 1.6, height: r * 0.9),
      jawPaint,
    );

    // Hair base
    final hairPath = Path()
      ..moveTo(cx - r * 0.95, cy - r * 0.1)
      ..quadraticBezierTo(cx - r * 1.0, cy - r * 1.3, cx, cy - r * 1.1)
      ..quadraticBezierTo(cx + r * 1.0, cy - r * 1.3, cx + r * 0.95, cy - r * 0.1)
      ..quadraticBezierTo(cx, cy - r * 0.2, cx - r * 0.95, cy - r * 0.1)
      ..close();
    canvas.drawPath(hairPath, _fill(hairColor));

    // Hair accent strand
    final strandPath = Path()
      ..moveTo(cx - r * 0.15, cy - r * 1.05)
      ..quadraticBezierTo(cx + r * 0.25, cy - r * 0.65, cx + r * 0.05, cy - r * 0.3);
    canvas.drawPath(strandPath, _stroke(accentColor, r * 0.08));

    // Eyes
    _eyes(canvas, cx, cy, r, accentColor: accentColor);

    // Nose
    final nosePath = Path()
      ..moveTo(cx + r * 0.08, cy + r * 0.15)
      ..quadraticBezierTo(cx + r * 0.22, cy + r * 0.35, cx + r * 0.08, cy + r * 0.45);
    canvas.drawPath(nosePath, _stroke(_skinDark, r * 0.065));

    // Mouth — slight smile
    final mouthPath = Path()
      ..moveTo(cx - r * 0.22, cy + r * 0.6)
      ..quadraticBezierTo(cx, cy + r * 0.76, cx + r * 0.22, cy + r * 0.6);
    canvas.drawPath(mouthPath, _stroke(const Color(0xFFD4856A), r * 0.07));

    if (hasGlasses) {
      _glasses(canvas, cx, cy, r, accentColor);
    }
  }

  void _eyes(Canvas canvas, double cx, double cy, double r,
      {Color accentColor = _cyan}) {
    // Left eye
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - r * 0.38, cy + r * 0.02),
          width: r * 0.42,
          height: r * 0.35),
      _fill(_white),
    );
    canvas.drawCircle(
        Offset(cx - r * 0.35, cy + r * 0.04), r * 0.13, _fill(accentColor));
    canvas.drawCircle(
        Offset(cx - r * 0.35, cy + r * 0.04), r * 0.07, _fill(_dark));
    // Shine
    canvas.drawCircle(
        Offset(cx - r * 0.3, cy + r * 0.0), r * 0.035, _fill(_white));

    // Right eye
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + r * 0.38, cy + r * 0.02),
          width: r * 0.42,
          height: r * 0.35),
      _fill(_white),
    );
    canvas.drawCircle(
        Offset(cx + r * 0.35, cy + r * 0.04), r * 0.13, _fill(accentColor));
    canvas.drawCircle(
        Offset(cx + r * 0.35, cy + r * 0.04), r * 0.07, _fill(_dark));
    canvas.drawCircle(
        Offset(cx + r * 0.4, cy + r * 0.0), r * 0.035, _fill(_white));

    // Eyebrows
    final brow = _stroke(const Color(0xFF2A1A0E), r * 0.08);
    final lbPath = Path()
      ..moveTo(cx - r * 0.56, cy - r * 0.2)
      ..quadraticBezierTo(cx - r * 0.35, cy - r * 0.28, cx - r * 0.16, cy - r * 0.2);
    canvas.drawPath(lbPath, brow);
    final rbPath = Path()
      ..moveTo(cx + r * 0.16, cy - r * 0.2)
      ..quadraticBezierTo(cx + r * 0.35, cy - r * 0.28, cx + r * 0.56, cy - r * 0.2);
    canvas.drawPath(rbPath, brow);
  }

  void _glasses(Canvas canvas, double cx, double cy, double r, Color c) {
    final gp = _stroke(c, r * 0.06);
    // Left lens frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx - r * 0.37, cy + r * 0.03),
            width: r * 0.52,
            height: r * 0.38),
        Radius.circular(r * 0.08),
      ),
      gp,
    );
    // Right lens frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx + r * 0.37, cy + r * 0.03),
            width: r * 0.52,
            height: r * 0.38),
        Radius.circular(r * 0.08),
      ),
      gp,
    );
    // Bridge
    canvas.drawLine(
      Offset(cx - r * 0.11, cy + r * 0.03),
      Offset(cx + r * 0.11, cy + r * 0.03),
      gp,
    );
  }

  // ─── SECTION: HOME — coding pose, laptop ──────────────────────────────────
  void _drawHome(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final s = w * 0.85; // scale unit
    final by = h * 0.95; // base y

    _shadow(canvas, cx, by, w * 0.7);
    _drawGlowCircle(canvas, Offset(cx, h * 0.45), s * 0.5, _cyan);

    // ── Body (torso) — hoodie style
    final torsoY = h * 0.48;
    final torso = Path()
      ..moveTo(cx - s * 0.25, torsoY - s * 0.05)
      ..lineTo(cx - s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.25, torsoY - s * 0.05)
      ..close();
    canvas.drawPath(torso, _fill(const Color(0xFF1A2540)));
    // Hoodie pocket
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, torsoY + s * 0.24), width: s * 0.28, height: s * 0.14),
        Radius.circular(s * 0.04),
      ),
      _stroke(_cyan.withOpacity(0.4), s * 0.018),
    );

    // ── Legs — seated
    final legY = torsoY + s * 0.42;
    // Left leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.28, legY, s * 0.22, s * 0.25),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF232D42)),
    );
    // Right leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.06, legY, s * 0.22, s * 0.25),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF232D42)),
    );

    // ── Laptop on lap
    final lapY = legY + s * 0.04;
    // Base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.29, lapY, s * 0.58, s * 0.07),
        Radius.circular(s * 0.025),
      ),
      _fill(const Color(0xFF2A3550)),
    );
    // Screen
    final screenPath = Path()
      ..moveTo(cx - s * 0.24, lapY)
      ..lineTo(cx - s * 0.26, lapY - s * 0.22)
      ..lineTo(cx + s * 0.26, lapY - s * 0.22)
      ..lineTo(cx + s * 0.24, lapY)
      ..close();
    canvas.drawPath(screenPath, _fill(const Color(0xFF0D1520)));
    canvas.drawPath(screenPath, _stroke(_cyan.withOpacity(0.5), s * 0.012));
    // Code lines on screen
    for (int i = 0; i < 4; i++) {
      final ly = lapY - s * 0.19 + i * s * 0.043;
      final lw = [0.28, 0.18, 0.24, 0.14][i];
      canvas.drawLine(
        Offset(cx - s * 0.2, ly),
        Offset(cx - s * 0.2 + s * lw, ly),
        _stroke(i == 0 ? _cyan : i == 2 ? _green : _white.withOpacity(0.4), s * 0.013),
      );
    }

    // ── Arms
    // Left arm down to keyboard
    final lArmPath = Path()
      ..moveTo(cx - s * 0.25, torsoY + s * 0.05)
      ..quadraticBezierTo(cx - s * 0.38, torsoY + s * 0.28, cx - s * 0.22, lapY + s * 0.02);
    canvas.drawPath(lArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx - s * 0.22, lapY + s * 0.02), s * 0.05, _fill(_skin));

    // Right arm down to keyboard
    final rArmPath = Path()
      ..moveTo(cx + s * 0.25, torsoY + s * 0.05)
      ..quadraticBezierTo(cx + s * 0.38, torsoY + s * 0.28, cx + s * 0.22, lapY + s * 0.02);
    canvas.drawPath(rArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx + s * 0.22, lapY + s * 0.02), s * 0.05, _fill(_skin));

    // ── Head
    final headCy = torsoY - s * 0.22;
    _head(canvas, cx, headCy, s * 0.22, accentColor: _cyan);

    // ── Floating code symbols
    _floatingSymbols(canvas, cx, h * 0.15, s, _cyan,
        symbols: ['</', '/>', '{}', '=>']);
  }

  // ─── SECTION: SKILLS — thinking pose, floating icons ──────────────────────
  void _drawSkills(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final s = w * 0.82;
    final by = h * 0.95;

    _shadow(canvas, cx, by, w * 0.65);
    _drawGlowCircle(canvas, Offset(cx, h * 0.43), s * 0.48, _cyan);

    final torsoY = h * 0.5;

    // ── Body — t-shirt with skill badge
    final torso = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, torsoY + s * 0.16), width: s * 0.54, height: s * 0.42),
      Radius.circular(s * 0.06),
    );
    canvas.drawRRect(torso, _fill(const Color(0xFF1E2D45)));
    // Collar
    final collarPath = Path()
      ..moveTo(cx - s * 0.1, torsoY - s * 0.05)
      ..lineTo(cx, torsoY + s * 0.04)
      ..lineTo(cx + s * 0.1, torsoY - s * 0.05);
    canvas.drawPath(collarPath, _stroke(const Color(0xFF2A3F5C), s * 0.03));
    // Badge / icon on chest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, torsoY + s * 0.2), width: s * 0.2, height: s * 0.2),
        Radius.circular(s * 0.04),
      ),
      _fill(_cyan.withOpacity(0.15)),
    );
    // Flutter logo-ish on badge
    canvas.drawLine(
      Offset(cx - s * 0.055, torsoY + s * 0.13),
      Offset(cx + s * 0.055, torsoY + s * 0.2),
      _stroke(_cyan, s * 0.025),
    );
    canvas.drawLine(
      Offset(cx - s * 0.055, torsoY + s * 0.27),
      Offset(cx + s * 0.055, torsoY + s * 0.2),
      _stroke(_cyan.withOpacity(0.5), s * 0.025),
    );

    // ── Legs standing
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.25, torsoY + s * 0.37, s * 0.2, s * 0.32),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF2A3050)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.05, torsoY + s * 0.37, s * 0.2, s * 0.32),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF2A3050)),
    );

    // ── Left arm raised with thinking gesture (hand on chin)
    final lArmPath = Path()
      ..moveTo(cx - s * 0.27, torsoY + s * 0.04)
      ..quadraticBezierTo(cx - s * 0.46, torsoY - s * 0.1, cx - s * 0.36, torsoY - s * 0.22);
    canvas.drawPath(lArmPath, _stroke(_skin, s * 0.085));
    canvas.drawCircle(Offset(cx - s * 0.36, torsoY - s * 0.22), s * 0.052, _fill(_skin));

    // ── Right arm casual down
    final rArmPath = Path()
      ..moveTo(cx + s * 0.27, torsoY + s * 0.04)
      ..quadraticBezierTo(cx + s * 0.42, torsoY + s * 0.18, cx + s * 0.38, torsoY + s * 0.36);
    canvas.drawPath(rArmPath, _stroke(_skin, s * 0.085));
    canvas.drawCircle(Offset(cx + s * 0.38, torsoY + s * 0.36), s * 0.052, _fill(_skin));

    // ── Head — slightly tilted
    final headCy = torsoY - s * 0.24;
    _head(canvas, cx + s * 0.03, headCy, s * 0.22,
        accentColor: _cyan, hairColor: const Color(0xFF1A1030));

    // ── Floating skill orbits
    _drawSkillOrbit(canvas, cx, headCy, s);
  }

  void _drawSkillOrbit(Canvas canvas, double cx, double cy, double s) {
    final orbitR = s * 0.54;
    final icons = ['📱', '🌐', '🎨', '⚡'];
    final colors = [_cyan, _purple, _green, _orange];
    for (int i = 0; i < 4; i++) {
      final angle = (i / 4) * 2 * math.pi + floatT * math.pi * 0.4;
      final ox = cx + math.cos(angle) * orbitR;
      final oy = cy + math.sin(angle) * orbitR * 0.55;

      // Orbit dot glow
      canvas.drawCircle(
        Offset(ox, oy),
        s * 0.075,
        Paint()
          ..color = colors[i].withOpacity(0.2 * glowOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.drawCircle(Offset(ox, oy), s * 0.065, _fill(colors[i].withOpacity(0.9)));

      // Draw letter in circle
      final tp = TextPainter(
        text: TextSpan(
          text: icons[i],
          style: TextStyle(fontSize: s * 0.068, color: _white),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(ox - tp.width / 2, oy - tp.height / 2));
    }
    // Faint orbit ring
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: orbitR * 2, height: orbitR * 1.1),
      _stroke(_cyan.withOpacity(0.1), s * 0.01),
    );
  }

  // ─── SECTION: PROJECTS — presenting pose, floating project card ───────────
  void _drawProjects(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final s = w * 0.82;
    final by = h * 0.95;

    _shadow(canvas, cx, by, w * 0.68);
    _drawGlowCircle(canvas, Offset(cx, h * 0.44), s * 0.5, _purple);

    final torsoY = h * 0.5;

    // ── Body — jacket
    final torsoPath = Path()
      ..moveTo(cx - s * 0.28, torsoY - s * 0.05)
      ..lineTo(cx - s * 0.32, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.32, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.28, torsoY - s * 0.05)
      ..close();
    canvas.drawPath(torsoPath, _fill(const Color(0xFF1C1840)));
    // Jacket lapels
    final lLapel = Path()
      ..moveTo(cx - s * 0.28, torsoY - s * 0.05)
      ..lineTo(cx - s * 0.06, torsoY + s * 0.06)
      ..lineTo(cx - s * 0.18, torsoY + s * 0.42);
    canvas.drawPath(lLapel, _fill(const Color(0xFF16122E)));
    final rLapel = Path()
      ..moveTo(cx + s * 0.28, torsoY - s * 0.05)
      ..lineTo(cx + s * 0.06, torsoY + s * 0.06)
      ..lineTo(cx + s * 0.18, torsoY + s * 0.42);
    canvas.drawPath(rLapel, _fill(const Color(0xFF16122E)));
    // Tie
    final tiePath = Path()
      ..moveTo(cx - s * 0.04, torsoY + s * 0.04)
      ..lineTo(cx + s * 0.04, torsoY + s * 0.04)
      ..lineTo(cx + s * 0.02, torsoY + s * 0.38)
      ..lineTo(cx, torsoY + s * 0.42)
      ..lineTo(cx - s * 0.02, torsoY + s * 0.38)
      ..close();
    canvas.drawPath(tiePath, _fill(_purple));

    // ── Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.28, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1A1530)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.06, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1A1530)),
    );

    // ── Left arm extended forward — holding a project card
    final lArmPath = Path()
      ..moveTo(cx - s * 0.28, torsoY + s * 0.04)
      ..quadraticBezierTo(cx - s * 0.52, torsoY - s * 0.02, cx - s * 0.5, torsoY - s * 0.18);
    canvas.drawPath(lArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx - s * 0.5, torsoY - s * 0.18), s * 0.052, _fill(_skin));

    // Floating project card held by character
    _drawMiniCard(canvas, cx - s * 0.52, torsoY - s * 0.42, s);

    // ── Right arm casual
    final rArmPath = Path()
      ..moveTo(cx + s * 0.28, torsoY + s * 0.04)
      ..quadraticBezierTo(cx + s * 0.44, torsoY + s * 0.22, cx + s * 0.4, torsoY + s * 0.35);
    canvas.drawPath(rArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx + s * 0.4, torsoY + s * 0.35), s * 0.052, _fill(_skin));

    // ── Head
    _head(canvas, cx + s * 0.05, torsoY - s * 0.25, s * 0.22,
        accentColor: _purple, hairColor: const Color(0xFF0E0A1E));

    // ── Floating stars
    _floatingSymbols(canvas, cx + s * 0.3, h * 0.18, s, _purple,
        symbols: ['★', '✦', '◆', '✧']);
  }

  void _drawMiniCard(Canvas canvas, double cx, double cy, double s) {
    final cardW = s * 0.38;
    final cardH = s * 0.28;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: cardW, height: cardH),
        Radius.circular(s * 0.04),
      ),
      _fill(const Color(0xFF0F1C2E)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: cardW, height: cardH),
        Radius.circular(s * 0.04),
      ),
      _stroke(_purple.withOpacity(0.6), s * 0.015),
    );
    // Card content lines
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - cardW * 0.38, cy - cardH * 0.34, cardW * 0.76, cardH * 0.28),
        Radius.circular(s * 0.02),
      ),
      _fill(_purple.withOpacity(0.25)),
    );
    canvas.drawLine(
      Offset(cx - cardW * 0.35, cy + cardH * 0.04),
      Offset(cx + cardW * 0.25, cy + cardH * 0.04),
      _stroke(_white.withOpacity(0.5), s * 0.013),
    );
    canvas.drawLine(
      Offset(cx - cardW * 0.35, cy + cardH * 0.17),
      Offset(cx + cardW * 0.1, cy + cardH * 0.17),
      _stroke(_white.withOpacity(0.3), s * 0.011),
    );
  }

  // ─── SECTION: SERVICES — dynamic pose, wrench + phone ─────────────────────
  void _drawServices(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final s = w * 0.82;
    final by = h * 0.95;

    _shadow(canvas, cx, by, w * 0.68);
    _drawGlowCircle(canvas, Offset(cx, h * 0.45), s * 0.5, _orange);

    final torsoY = h * 0.51;

    // ── Body — work shirt
    final torso = Path()
      ..moveTo(cx - s * 0.27, torsoY - s * 0.04)
      ..lineTo(cx - s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.27, torsoY - s * 0.04)
      ..close();
    canvas.drawPath(torso, _fill(const Color(0xFF1A2830)));
    // Shirt lines
    canvas.drawLine(
      Offset(cx, torsoY + s * 0.0),
      Offset(cx, torsoY + s * 0.42),
      _stroke(const Color(0xFF243545), s * 0.015),
    );
    // Chest pocket
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx - s * 0.14, torsoY + s * 0.1),
            width: s * 0.13,
            height: s * 0.11),
        Radius.circular(s * 0.02),
      ),
      _stroke(_orange.withOpacity(0.5), s * 0.015),
    );

    // ── Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.26, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1E2C38)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.04, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1E2C38)),
    );

    // ── Right arm raised holding phone
    final rArmPath = Path()
      ..moveTo(cx + s * 0.27, torsoY + s * 0.04)
      ..quadraticBezierTo(cx + s * 0.48, torsoY - s * 0.04, cx + s * 0.44, torsoY - s * 0.22);
    canvas.drawPath(rArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx + s * 0.44, torsoY - s * 0.22), s * 0.052, _fill(_skin));
    // Phone in hand
    _drawPhone(canvas, cx + s * 0.44, torsoY - s * 0.38, s);

    // ── Left arm with wrench tool
    final lArmPath = Path()
      ..moveTo(cx - s * 0.27, torsoY + s * 0.04)
      ..quadraticBezierTo(cx - s * 0.46, torsoY + s * 0.1, cx - s * 0.44, torsoY + s * 0.28);
    canvas.drawPath(lArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx - s * 0.44, torsoY + s * 0.28), s * 0.052, _fill(_skin));
    // Wrench
    _drawWrench(canvas, cx - s * 0.44, torsoY + s * 0.38, s);

    // ── Head
    _head(canvas, cx, torsoY - s * 0.26, s * 0.22,
        accentColor: _orange, hairColor: const Color(0xFF0E1510));

    // ── Service icons floating
    _floatingSymbols(canvas, cx - s * 0.3, h * 0.16, s, _orange,
        symbols: ['⚙', '🔧', '✦', '▲']);
  }

  void _drawPhone(Canvas canvas, double cx, double cy, double s) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy), width: s * 0.13, height: s * 0.22),
        Radius.circular(s * 0.025),
      ),
      _fill(const Color(0xFF0D1520)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy), width: s * 0.13, height: s * 0.22),
        Radius.circular(s * 0.025),
      ),
      _stroke(_orange, s * 0.015),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy), width: s * 0.095, height: s * 0.155),
        Radius.circular(s * 0.015),
      ),
      _fill(_orange.withOpacity(0.15)),
    );
  }

  void _drawWrench(Canvas canvas, double cx, double cy, double s) {
    final path = Path()
      ..moveTo(cx - s * 0.02, cy - s * 0.12)
      ..lineTo(cx - s * 0.02, cy + s * 0.12)
      ..lineTo(cx + s * 0.02, cy + s * 0.12)
      ..lineTo(cx + s * 0.02, cy - s * 0.12)
      ..close();
    canvas.drawPath(path, _fill(_orange.withOpacity(0.8)));
    canvas.drawCircle(Offset(cx, cy - s * 0.1), s * 0.048, _fill(_orange));
    canvas.drawCircle(Offset(cx, cy - s * 0.1), s * 0.024, _fill(_dark));
  }

  // ─── SECTION: CV — reading/scrolling pose ─────────────────────────────────
  void _drawCV(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final s = w * 0.82;
    final by = h * 0.95;

    _shadow(canvas, cx, by, w * 0.66);
    _drawGlowCircle(canvas, Offset(cx, h * 0.44), s * 0.5, _green);

    final torsoY = h * 0.5;

    // ── Body — smart casual shirt
    final torso = Path()
      ..moveTo(cx - s * 0.26, torsoY - s * 0.04)
      ..lineTo(cx - s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.26, torsoY - s * 0.04)
      ..close();
    canvas.drawPath(torso, _fill(const Color(0xFF1A2A20)));
    // Shirt collar detail
    final collarL = Path()
      ..moveTo(cx - s * 0.1, torsoY - s * 0.04)
      ..lineTo(cx - s * 0.04, torsoY + s * 0.08)
      ..lineTo(cx - s * 0.16, torsoY - s * 0.04);
    canvas.drawPath(collarL, _fill(const Color(0xFF243530)));
    final collarR = Path()
      ..moveTo(cx + s * 0.1, torsoY - s * 0.04)
      ..lineTo(cx + s * 0.04, torsoY + s * 0.08)
      ..lineTo(cx + s * 0.16, torsoY - s * 0.04);
    canvas.drawPath(collarR, _fill(const Color(0xFF243530)));

    // ── Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.26, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1C2820)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.04, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1C2820)),
    );

    // ── Both arms holding a large CV document
    final lArmPath = Path()
      ..moveTo(cx - s * 0.26, torsoY + s * 0.05)
      ..quadraticBezierTo(cx - s * 0.42, torsoY - s * 0.0, cx - s * 0.38, torsoY - s * 0.18);
    canvas.drawPath(lArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx - s * 0.38, torsoY - s * 0.18), s * 0.052, _fill(_skin));

    final rArmPath = Path()
      ..moveTo(cx + s * 0.26, torsoY + s * 0.05)
      ..quadraticBezierTo(cx + s * 0.42, torsoY - s * 0.0, cx + s * 0.38, torsoY - s * 0.18);
    canvas.drawPath(rArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx + s * 0.38, torsoY - s * 0.18), s * 0.052, _fill(_skin));

    // CV document held in front
    _drawCVDoc(canvas, cx, torsoY - s * 0.36, s);

    // ── Head peeking over document
    _head(canvas, cx, torsoY - s * 0.56, s * 0.22,
        accentColor: _green, hairColor: const Color(0xFF0A1510),
        hasGlasses: true);

    // ── Floating achievement stars
    _floatingSymbols(canvas, cx, h * 0.12, s, _green,
        symbols: ['★', '✓', '📄', '🏆']);
  }

  void _drawCVDoc(Canvas canvas, double cx, double cy, double s) {
    final dw = s * 0.52;
    final dh = s * 0.38;
    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + s * 0.015, cy + s * 0.015), width: dw, height: dh),
        Radius.circular(s * 0.03),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: dw, height: dh),
        Radius.circular(s * 0.03),
      ),
      _fill(_white),
    );
    // Header bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - dw / 2, cy - dh / 2, dw, dh * 0.22),
        const Radius.circular(4),
      ),
      _fill(_green.withOpacity(0.9)),
    );
    // Content lines
    for (int i = 0; i < 5; i++) {
      final ly = cy - dh * 0.16 + i * dh * 0.14;
      final lw = [0.7, 0.5, 0.65, 0.4, 0.55][i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              cx - dw * 0.42, ly - dh * 0.025, dw * 0.84 * lw, dh * 0.048),
          const Radius.circular(2),
        ),
        _fill(const Color(0xFFCCCCCC)),
      );
    }
  }

  // ─── SECTION: CONTACT — waving pose with chat bubble ─────────────────────
  void _drawContact(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final s = w * 0.82;
    final by = h * 0.95;

    _shadow(canvas, cx, by, w * 0.68);
    _drawGlowCircle(canvas, Offset(cx, h * 0.44), s * 0.5, _cyan);

    final torsoY = h * 0.51;

    // ── Body — casual polo
    final torso = Path()
      ..moveTo(cx - s * 0.26, torsoY - s * 0.04)
      ..lineTo(cx - s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.3, torsoY + s * 0.42)
      ..lineTo(cx + s * 0.26, torsoY - s * 0.04)
      ..close();
    canvas.drawPath(torso, _fill(const Color(0xFF18283A)));
    // Polo collar
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, torsoY + s * 0.01), width: s * 0.25, height: s * 0.1),
      _stroke(const Color(0xFF243A50), s * 0.025),
    );

    // ── Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.26, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1E2A35)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.04, torsoY + s * 0.4, s * 0.22, s * 0.3),
        Radius.circular(s * 0.06),
      ),
      _fill(const Color(0xFF1E2A35)),
    );

    // ── Right arm — waving up enthusiastically
    final rArmPath = Path()
      ..moveTo(cx + s * 0.26, torsoY + s * 0.02)
      ..quadraticBezierTo(cx + s * 0.5, torsoY - s * 0.12, cx + s * 0.48, torsoY - s * 0.3);
    canvas.drawPath(rArmPath, _stroke(_skin, s * 0.09));
    // Hand waving
    canvas.drawCircle(Offset(cx + s * 0.48, torsoY - s * 0.3), s * 0.055, _fill(_skin));
    // Fingers
    for (int i = 0; i < 4; i++) {
      final angle = (-0.3 + i * 0.22);
      canvas.drawLine(
        Offset(cx + s * 0.48, torsoY - s * 0.3),
        Offset(cx + s * 0.48 + math.cos(angle - math.pi / 2) * s * 0.072,
            torsoY - s * 0.3 + math.sin(angle - math.pi / 2) * s * 0.072),
        _stroke(_skin, s * 0.032),
      );
    }

    // ── Left arm casual
    final lArmPath = Path()
      ..moveTo(cx - s * 0.26, torsoY + s * 0.04)
      ..quadraticBezierTo(cx - s * 0.42, torsoY + s * 0.2, cx - s * 0.38, torsoY + s * 0.36);
    canvas.drawPath(lArmPath, _stroke(_skin, s * 0.09));
    canvas.drawCircle(Offset(cx - s * 0.38, torsoY + s * 0.36), s * 0.052, _fill(_skin));

    // ── Head — smiling
    _head(canvas, cx - s * 0.04, torsoY - s * 0.26, s * 0.22, accentColor: _cyan);

    // ── Chat bubbles floating
    _drawChatBubble(canvas, cx + s * 0.28, torsoY - s * 0.55, s, _cyan, '👋');
    _drawChatBubble(canvas, cx - s * 0.3, torsoY - s * 0.6, s, _purple, '💬');

    // ── Motion lines on waving arm
    for (int i = 0; i < 3; i++) {
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(cx + s * 0.48, torsoY - s * 0.3),
            width: s * (0.16 + i * 0.1),
            height: s * (0.16 + i * 0.1)),
        -math.pi * 0.9,
        math.pi * 0.5,
        false,
        _stroke(_cyan.withOpacity(0.25 - i * 0.07), s * 0.013),
      );
    }
  }

  void _drawChatBubble(Canvas canvas, double cx, double cy, double s,
      Color color, String emoji) {
    final bw = s * 0.28;
    final bh = s * 0.18;
    // Bubble
    final bubblePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, cy), width: bw, height: bh),
          Radius.circular(s * 0.05)))
      ..moveTo(cx - s * 0.04, cy + bh / 2)
      ..lineTo(cx - s * 0.1, cy + bh / 2 + s * 0.07)
      ..lineTo(cx + s * 0.04, cy + bh / 2)
      ..close();
    canvas.drawPath(bubblePath, _fill(color.withOpacity(0.18)));
    canvas.drawPath(
        bubblePath, _stroke(color.withOpacity(0.55), s * 0.013));

    final tp = TextPainter(
      text: TextSpan(
          text: emoji, style: TextStyle(fontSize: s * 0.1, color: _white)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  // ─── Floating symbols helper ───────────────────────────────────────────────
  void _floatingSymbols(Canvas canvas, double cx, double cy, double s,
      Color color, {required List<String> symbols}) {
    for (int i = 0; i < symbols.length; i++) {
      final offsetX = [s * 0.32, s * 0.5, -s * 0.08, s * 0.42][i % 4];
      final offsetY = [0.0, s * 0.2, s * 0.1, s * 0.32][i % 4];
      final bobY = math.sin((floatT + i * 0.28) * math.pi * 2) * s * 0.03;

      final opacity = (0.4 + 0.4 * math.sin((floatT + i * 0.5) * math.pi))
          .clamp(0.2, 0.85);

      final tp = TextPainter(
        text: TextSpan(
          text: symbols[i],
          style: TextStyle(
              fontSize: s * 0.1,
              color: color.withOpacity(opacity),
              fontWeight: FontWeight.w900),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(cx + offsetX - tp.width / 2,
            cy + offsetY + bobY - tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_CharacterPainter old) =>
      old.glowOpacity != glowOpacity || old.floatT != floatT;
}