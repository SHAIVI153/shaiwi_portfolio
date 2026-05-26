import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

// ─── Glowing Neon Button ─────────────────────────────────────────────────────
class GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool outlined;

  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
    this.outlined = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.outlined
                ? Colors.transparent
                : (_hovering ? widget.color : widget.color.withOpacity(0.85)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: widget.color, width: 1.5),
            boxShadow: _hovering
                ? [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 24,
                spreadRadius: 2,
              )
            ]
                : [
              BoxShadow(
                color: widget.color.withOpacity(0.2),
                blurRadius: 12,
              )
            ],
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: widget.outlined
                  ? (_hovering ? widget.color : AppColors.textPrimary)
                  : AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
            color: AppColors.primary.withOpacity(0.06),
          ),
          child: Text(
            tag.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.7,
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
  final EdgeInsets? padding;

  const NeonCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.primary,
    this.padding,
  });

  @override
  State<NeonCard> createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: widget.padding ?? const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovering
              ? AppColors.card.withOpacity(0.9)
              : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovering
                ? widget.glowColor.withOpacity(0.5)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: _hovering
              ? [
            BoxShadow(
              color: widget.glowColor.withOpacity(0.12),
              blurRadius: 30,
              spreadRadius: 2,
            )
          ]
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
  final Color color;

  const SkillTag({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color(color.value).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(color.value).withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(color.value),
        ),
      ),
    );
  }
}

// ─── Animated Gradient Text ───────────────────────────────────────────────────
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;

  const GradientText(
      this.text, {
        super.key,
        required this.style,
        required this.colors,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(text, style: style),
    );
  }
}

// ─── Nav Bar ──────────────────────────────────────────────────────────────────
class PortfolioNavBar extends StatelessWidget {
  final Function(String) onNavTap;
  final String activeSection;

  const PortfolioNavBar({
    super.key,
    required this.onNavTap,
    required this.activeSection,
  });

  @override
  Widget build(BuildContext context) {
    final items = ['Home', 'Skills', 'Projects', 'Services', 'Contact'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.85),
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GradientText(
            'shaiwi_code',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            colors: const [AppColors.primary, AppColors.secondary],
          ),
          // Nav items
          Row(
            children: items.map((item) {
              final isActive = activeSection == item;
              return GestureDetector(
                onTap: () => onNavTap(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(left: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 2,
                        width: isActive ? 20 : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.6),
                              blurRadius: 6,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}