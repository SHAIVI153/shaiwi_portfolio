// ═══════════════════════════════════════════════════════════════════════════════
//  about_section.dart — "Hello!" badge-card About section
//
//  Re-creation of the video-portfolio site's About.jsx (lanyard / ID-badge
//  card + bio text + tech icon row), rebuilt in Flutter and skinned with
//  shaiwi_code's own cyan / purple / green palette instead of red.
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/responsive_screen.dart';
import 'app_theme.dart';
import 'common_widgets.dart';
import 'portfolio_data.dart';
import 'tilt_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: r.hPad, vertical: r.vPad),
        child: r.sideBySide
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Badge(r: r),
            SizedBox(width: r.sp(56)),
            Expanded(child: _Info(r: r)),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: _Badge(r: r)),
            SizedBox(height: r.sp(32)),
            _Info(r: r, centered: true),
          ],
        ),
      );
    });
  }
}

// ─── Circular "Instagram DP" style avatar with animated neon ring ─────────────
class _Badge extends StatelessWidget {
  final Rsp r;
  const _Badge({required this.r});

  @override
  Widget build(BuildContext context) {
    final size = r.isMobile ? 190.0 : 240.0;

    return Column(
      children: [
        TiltCard(
          maxTilt: r.isMobile ? 3 : 6,
          child: NeonRingAvatar(
            imagePath: 'assets/images/profile.jpg',
            size: size,
          ),
        ),
        const SizedBox(height: 18),
        Text(PortfolioData.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(19),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text('@${PortfolioData.nickname}',
          style: GoogleFonts.jetBrainsMono(
            fontSize: r.fs(12),
            color: AppColors.primary,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).scale(
      begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack,
      duration: 650.ms,
    );
  }
}

// ─── Bio + tech row ────────────────────────────────────────────────────────────
class _Info extends StatelessWidget {
  final Rsp r;
  final bool centered;
  const _Info({required this.r, this.centered = false});

  @override
  Widget build(BuildContext context) {
    final align =
    centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        SectionHeader(
          tag: 'ABOUT ME',
          title: 'Hello!',
          titleFs: r.sectionTitleFs,
        ),
        SizedBox(height: r.sp(18)),
        Text(
          PortfolioData.bio,
          textAlign: textAlign,
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(15),
            fontWeight: FontWeight.w500,
            height: 1.75,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: r.sp(28)),

        // Core tech row — big, glowing icons (mirrors the React/Node/Mongo row)
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: r.sp(28),
          runSpacing: r.sp(20),
          children: const [
            _TechIcon(icon: '🐦', label: 'Flutter', color: AppColors.primary),
            _TechIcon(icon: '🎯', label: 'Dart', color: AppColors.primary),
            _TechIcon(icon: '🔥', label: 'Firebase', color: AppColors.accent),
            _TechIcon(icon: '📈', label: 'SEO', color: AppColors.secondary),
          ],
        ),

        SizedBox(height: r.sp(32)),
        Container(height: 1, color: AppColors.border),
        SizedBox(height: r.sp(24)),

        // Quick facts — extra detail not shown anywhere else on the page
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: r.sp(14),
          runSpacing: r.sp(14),
          children: const [
            _FactChip(icon: Icons.school_outlined, label: 'Self-taught Developer'),
            _FactChip(icon: Icons.location_on_outlined, label: 'Based in Pakistan'),
            _FactChip(icon: Icons.schedule_outlined, label: 'Available Full-time / Freelance'),
            _FactChip(icon: Icons.language_outlined, label: 'English · Urdu'),
          ],
        ),
      ],
    ).animate(delay: 150.ms).fadeIn(duration: 500.ms).slideX(
      begin: centered ? 0 : 0.08, curve: Curves.easeOutCubic, duration: 600.ms,
    );
  }
}

// ─── Quick fact chip (small pill with icon + label) ──────────────────────────
class _FactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FactChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12.5, fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ]),
    );
  }
}

class _TechIcon extends StatefulWidget {
  final String icon;
  final String label;
  final Color color;
  const _TechIcon(
      {required this.icon, required this.label, required this.color});

  @override
  State<_TechIcon> createState() => _TechIconState();
}

class _TechIconState extends State<_TechIcon> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedScale(
        scale: _hov ? 1.12 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: Column(children: [
          Container(
            width: 56, height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.color.withOpacity(0.28)),
              boxShadow: _hov
                  ? [BoxShadow(color: widget.color.withOpacity(0.25),
                  blurRadius: 20)]
                  : [],
            ),
            child: Text(widget.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 6),
          Text(widget.label,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
        ]),
      ),
    );
  }
}