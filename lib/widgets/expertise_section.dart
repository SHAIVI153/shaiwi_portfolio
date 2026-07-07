// ═══════════════════════════════════════════════════════════════════════════════
//  expertise_section.dart — "Building Modern Digital Solutions" timeline cards
//
//  Re-creation of the video-portfolio site's Expertise.jsx (scroll-revealed
//  cards strung along a connecting line), rebuilt in Flutter with shaiwi_code's
//  own cyan / purple / green / orange palette instead of red.
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/responsive_screen.dart';
import 'app_theme.dart';
import 'common_widgets.dart';

class ExpertiseSection extends StatelessWidget {
  const ExpertiseSection({super.key});

  static const _cards = [
    (
    number: '01',
    title: 'Mobile Development',
    text: 'Crafting cross-platform iOS & Android apps with Flutter, '
        'Dart, clean state management and pixel-perfect UI.',
    color: AppColors.primary,
    ),
    (
    number: '02',
    title: 'Web Development',
    text: 'Building responsive, fast-loading websites and Webflow-style '
        'interfaces with HTML, CSS, JavaScript and modern frameworks.',
    color: AppColors.secondary,
    ),
    (
    number: '03',
    title: 'Backend & Database',
    text: 'Wiring up Firebase, Firestore, REST APIs and MySQL to power '
        'real-time, data-driven applications.',
    color: AppColors.accent,
    ),
    (
    number: '04',
    title: 'SEO & Digital Marketing',
    text: 'Driving organic growth through technical SEO, content '
        'strategy and analytics-backed marketing.',
    color: Color(0xFFFF6B35),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: r.hPad, vertical: r.vPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              tag: 'MY EXPERTISE',
              title: 'Building Modern\nDigital Solutions',
              subtitle: 'Combining mobile development, web technology, and '
                  'data-driven strategy to create impactful digital '
                  'experiences.',
              titleFs: r.sectionTitleFs,
            ),
            SizedBox(height: r.sp(44)),

            // Connecting vertical line + staggered cards
            Stack(
              children: [
                Positioned(
                  left: r.isMobile ? 27 : 39,
                  top: 8,
                  bottom: 8,
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _cards.map((c) => c.color.withOpacity(0.35))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: _cards.asMap().entries.map((e) {
                    final i = e.key;
                    final c = e.value;
                    final fromLeft = i.isEven;
                    return Padding(
                      padding: EdgeInsets.only(bottom: r.sp(22)),
                      child: _ExpertiseRow(r: r, index: i, card: c),
                    )
                        .animate(delay: (i * 140).ms)
                        .fadeIn(duration: 480.ms)
                        .slideX(
                      begin: fromLeft ? -0.10 : 0.10,
                      curve: Curves.easeOutCubic,
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _ExpertiseRow extends StatefulWidget {
  final Rsp r;
  final int index;
  final ({String number, String title, String text, Color color}) card;
  const _ExpertiseRow({required this.r, required this.index, required this.card});

  @override
  State<_ExpertiseRow> createState() => _ExpertiseRowState();
}

class _ExpertiseRowState extends State<_ExpertiseRow> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final c = widget.card;
    final dotSize = r.isMobile ? 14.0 : 18.0;
    final lineGutter = r.isMobile ? 56.0 : 80.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          SizedBox(
            width: lineGutter,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: r.sp(18)),
                child: AnimatedContainer(
                  duration: 300.ms,
                  width: dotSize, height: dotSize,
                  decoration: BoxDecoration(
                    color: _hov ? c.color : AppColors.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.color, width: 2),
                    boxShadow: _hov
                        ? [BoxShadow(color: c.color.withOpacity(0.6),
                        blurRadius: 14, spreadRadius: 1)]
                        : [],
                  ),
                ),
              ),
            ),
          ),

          // Card
          Expanded(
            child: AnimatedContainer(
              duration: 300.ms,
              padding: EdgeInsets.all(r.sp(24)),
              decoration: BoxDecoration(
                color: _hov ? c.color.withOpacity(0.08) : AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _hov ? c.color.withOpacity(0.5) : AppColors.border,
                ),
                boxShadow: _hov
                    ? [BoxShadow(color: c.color.withOpacity(0.14),
                    blurRadius: 30, spreadRadius: 1)]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.number,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: r.fs(13),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: c.color.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: r.sp(6)),
                  Text(c.title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: r.fs(19),
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: r.sp(8)),
                  Text(c.text,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: r.fs(13),
                      color: AppColors.textSecondary,
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}