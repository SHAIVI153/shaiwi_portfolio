import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

// ─── Gradient Text ────────────────────────────────────────────────────────────
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  const GradientText(this.text,
      {super.key, required this.style, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (b) =>
          LinearGradient(colors: colors).createShader(b),
      child: Text(text, style: style),
    );
  }
}

// ─── Neon Glow Button ─────────────────────────────────────────────────────────
class GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool outlined;
  final double? fontSize;
  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
    this.outlined = false,
    this.fontSize,
  });
  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: widget.outlined
                ? Colors.transparent
                : (_hov ? widget.color : widget.color.withOpacity(0.88)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: widget.color, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hov ? 0.55 : 0.2),
                blurRadius: _hov ? 24 : 10,
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: widget.fontSize ?? 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: widget.outlined
                  ? (_hov ? widget.color : AppColors.textPrimary)
                  : AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String? subtitle;
  final double titleFs;

  const SectionHeader({
    super.key,
    required this.tag,
    required this.title,
    this.subtitle,
    this.titleFs = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
            color: AppColors.primary.withOpacity(0.07),
          ),
          child: Text(
            tag.toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: titleFs,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -1.5,
            height: 1.08,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.75,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Neon Card ────────────────────────────────────────────────────────────────
class NeonCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsets padding;
  final double radius;
  const NeonCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.primary,
    this.padding = const EdgeInsets.all(24),
    this.radius = 16,
  });
  @override State<NeonCard> createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _hov
              ? Color.lerp(AppColors.card, widget.glowColor, 0.04)
              : AppColors.card,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: _hov
                ? widget.glowColor.withOpacity(0.5)
                : AppColors.border,
          ),
          boxShadow: _hov
              ? [BoxShadow(
              color: widget.glowColor.withOpacity(0.14),
              blurRadius: 28, spreadRadius: 1)]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}

// ─── Skill Tag ────────────────────────────────────────────────────────────────
class SkillTag extends StatelessWidget {
  final String label;
  final int color;
  final double? fontSize;
  const SkillTag({
    super.key,
    required this.label,
    required this.color,
    this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    final c = Color(color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(0.09),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withOpacity(0.28)),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w600,
          color: c,
        ),
      ),
    );
  }
}

// ─── Pulsing Dot ─────────────────────────────────────────────────────────────
class PulsingDot extends StatefulWidget {
  final Color color;
  final double size;
  const PulsingDot({super.key, this.color = AppColors.accent, this.size = 8});
  @override State<PulsingDot> createState() => _PulsingDotState();
}
class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Container(
        width: widget.size, height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
            color: widget.color.withOpacity(0.3 + _c.value * 0.5),
            blurRadius: 4 + _c.value * 8,
            spreadRadius: _c.value * 2,
          )],
        ),
      ),
    );
  }
}

// ─── Section Title (legacy alias) ────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String tag;
  final String title;
  final String? subtitle;
  const SectionTitle({
    super.key,
    required this.tag,
    required this.title,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return SectionHeader(tag: tag, title: title, subtitle: subtitle);
  }
}

// ─── Neon ring avatar (Instagram-DP style, smooth anti-aliased ring) ─────────
/// Circular profile photo with a slowly-rotating brand-gradient ring,
/// painted with a CustomPainter (not stacked/clipped Containers) so the
/// ring edge stays crisp and anti-aliased at any size instead of looking
/// pixelated.
class NeonRingAvatar extends StatefulWidget {
  final String imagePath;
  final double size;
  final double ringWidth;
  final double gap;

  const NeonRingAvatar({
    super.key,
    required this.imagePath,
    this.size = 200,
    this.ringWidth = 4,
    this.gap = 8,
  });

  @override
  State<NeonRingAvatar> createState() => _NeonRingAvatarState();
}

class _NeonRingAvatarState extends State<NeonRingAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.size + (widget.gap + widget.ringWidth) * 2;

    return RepaintBoundary(
      child: SizedBox(
        width: total,
        height: total,
        child: Stack(alignment: Alignment.center, children: [
          // Soft ambient glow behind everything
          Container(
            width: total + 40,
            height: total + 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.primary.withOpacity(0.16),
                Colors.transparent,
              ]),
            ),
          ),

          // Smooth, anti-aliased rotating gradient ring
          AnimatedBuilder(
            animation: _spin,
            builder: (context, _) => CustomPaint(
              size: Size(total, total),
              painter: _RingPainter(
                rotation: _spin.value * 6.28319,
                strokeWidth: widget.ringWidth,
              ),
            ),
          ),

          // Circular profile photo
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.32),
                    blurRadius: 26, spreadRadius: 1),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: Center(
                    child: Icon(Icons.person_outline,
                        size: widget.size * 0.4,
                        color: AppColors.primary.withOpacity(0.35)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double rotation;
  final double strokeWidth;
  _RingPainter({required this.rotation, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        transform: GradientRotation(rotation),
        colors: const [
          AppColors.primary,
          AppColors.secondary,
          AppColors.accent,
          AppColors.primary,
        ],
      ).createShader(rect);

    canvas.drawArc(rect, 0, 6.28319, false, paint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}