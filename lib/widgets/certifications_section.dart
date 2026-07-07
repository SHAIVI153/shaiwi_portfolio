// ═══════════════════════════════════════════════════════════════════════════════
//  certifications_section.dart — Certificates showcase
//
//  Cards alternate sliding in from the left/right as they scroll into view —
//  the same alternating-direction reveal used across the video-portfolio site —
//  themed with shaiwi_code's own cyan / purple / green palette.
//
//  To add your own certificates: edit PortfolioData.certifications in
//  lib/widgets/portfolio_data.dart, and drop the certificate images into
//  assets/images/certifications/ (remember to register that folder in
//  pubspec.yaml under flutter -> assets).
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/responsive_screen.dart';
import 'app_theme.dart';
import 'common_widgets.dart';
import 'portfolio_data.dart';
import 'tilt_card.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

  static const _colors = [
    AppColors.primary, AppColors.secondary, AppColors.accent,
    Color(0xFFFF6B35),
  ];

  @override
  Widget build(BuildContext context) {
    final certs = PortfolioData.certifications;

    return ResponsiveBuilder(builder: (ctx, r) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: r.hPad, vertical: r.vPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              tag: 'CREDENTIALS',
              title: 'Certifications\n& Courses',
              subtitle: 'Continuous learning across mobile, web and '
                  'digital marketing.',
              titleFs: r.sectionTitleFs,
            ),
            SizedBox(height: r.sp(40)),

            if (certs.isEmpty)
              _EmptyState(r: r)
            else
              ...certs.asMap().entries.map((e) {
                final i = e.key;
                final cert = e.value;
                final color = _colors[i % _colors.length];
                final fromLeft = i.isEven;
                return Padding(
                  padding: EdgeInsets.only(bottom: r.sp(22)),
                  child: _CertCard(r: r, cert: cert, color: color),
                )
                    .animate(delay: (i * 120).ms)
                    .fadeIn(duration: 480.ms)
                    .slideX(
                  begin: fromLeft ? -0.12 : 0.12,
                  curve: Curves.easeOutCubic,
                );
              }),
          ],
        ),
      );
    });
  }
}

class _CertCard extends StatefulWidget {
  final Rsp r;
  final Map<String, String> cert;
  final Color color;
  const _CertCard({required this.r, required this.cert, required this.color});

  @override
  State<_CertCard> createState() => _CertCardState();
}

class _CertCardState extends State<_CertCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final cert = widget.cert;
    final color = widget.color;
    final isPending = cert['status'] == 'pending';
    final hasLink = !isPending && (cert['credentialUrl'] ?? '').isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: TiltCard(
        maxTilt: r.isMobile ? 2 : 4,
        child: NeonCard(
          glowColor: color,
          padding: EdgeInsets.all(r.sp(18)),
          child: r.sideBySide
              ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            isPending
                ? _PendingThumb(color: color, r: r)
                : _Thumb(cert: cert, color: color, r: r),
            SizedBox(width: r.sp(22)),
            Expanded(child: _Details(
                r: r, cert: cert, color: color, isPending: isPending)),
            if (hasLink) ...[
              SizedBox(width: r.sp(14)),
              _VerifyButton(
                color: color,
                onTap: () => _launch(cert['credentialUrl']!),
              ),
            ],
          ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            isPending
                ? _PendingThumb(color: color, r: r, full: true)
                : _Thumb(cert: cert, color: color, r: r, full: true),
            SizedBox(height: r.sp(16)),
            _Details(r: r, cert: cert, color: color, isPending: isPending),
            if (hasLink) ...[
              SizedBox(height: r.sp(14)),
              _VerifyButton(
                color: color,
                onTap: () => _launch(cert['credentialUrl']!),
              ),
            ],
          ]),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─── "Coming Soon" placeholder thumbnail for pending certificates ────────────
class _PendingThumb extends StatelessWidget {
  final Color color;
  final Rsp r;
  final bool full;
  const _PendingThumb({required this.color, required this.r,
    this.full = false});

  @override
  Widget build(BuildContext context) {
    final size = full ? double.infinity : (r.isMobile ? 92.0 : 120.0);
    return Container(
      width: size,
      height: full ? (r.isMobile ? 130 : 150) : (r.isMobile ? 92 : 120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.surface,
        border: Border.all(
            color: color.withOpacity(0.25), style: BorderStyle.solid),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.hourglass_top_rounded,
          size: full ? 36 : 28, color: color.withOpacity(0.5)),
    );
  }
}

class _Thumb extends StatelessWidget {
  final Map<String, String> cert;
  final Color color;
  final Rsp r;
  final bool full;
  const _Thumb({required this.cert, required this.color, required this.r,
    this.full = false});

  @override
  Widget build(BuildContext context) {
    final size = full ? double.infinity : (r.isMobile ? 92.0 : 120.0);
    final imagePath = cert['image'] ?? '';

    return GestureDetector(
      onTap: () => _openLightbox(context, imagePath, cert['title'] ?? ''),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: size,
              height: full ? (r.isMobile ? 160 : 190) : (r.isMobile ? 92 : 120),
              decoration: BoxDecoration(
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: Icon(Icons.workspace_premium_rounded,
                      size: full ? 44 : 34, color: color.withOpacity(0.45)),
                ),
              ),
            ),
          ),
          // Tiny zoom hint icon, bottom-right of the thumbnail
          Positioned(
            bottom: 6, right: 6,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.zoom_in_rounded,
                  size: 14, color: Colors.white),
            ),
          ),
        ]),
      ),
    );
  }

  void _openLightbox(BuildContext context, String imagePath, String title) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.88),
      builder: (ctx) => _CertLightbox(imagePath: imagePath, title: title),
    );
  }
}

// ─── Fullscreen tap-to-zoom certificate viewer ───────────────────────────────
class _CertLightbox extends StatelessWidget {
  final String imagePath;
  final String title;
  const _CertLightbox({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(children: [
        Center(
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => Container(
                  width: 280, height: 200,
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: Icon(Icons.workspace_premium_rounded,
                      size: 60, color: AppColors.textSecondary.withOpacity(0.4)),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0, right: 0,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Details extends StatelessWidget {
  final Rsp r;
  final Map<String, String> cert;
  final Color color;
  final bool isPending;
  const _Details({required this.r, required this.cert, required this.color,
    this.isPending = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          Icon(
            isPending
                ? Icons.hourglass_top_rounded
                : Icons.workspace_premium_rounded,
            size: r.fs(15), color: color,
          ),
          SizedBox(width: r.sp(6)),
          Container(
            padding: isPending
                ? const EdgeInsets.symmetric(horizontal: 8, vertical: 2)
                : EdgeInsets.zero,
            decoration: isPending
                ? BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            )
                : null,
            child: Text((cert['date'] ?? '').toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: r.fs(11), fontWeight: FontWeight.w700,
                color: color, letterSpacing: 1.5,
              ),
            ),
          ),
        ]),
        SizedBox(height: r.sp(8)),
        Text(cert['title'] ?? '',
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(17), fontWeight: FontWeight.w800,
            color: isPending
                ? AppColors.textPrimary.withOpacity(0.6)
                : AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: r.sp(4)),
        Text(cert['issuer'] ?? '',
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(13), color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _VerifyButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  const _VerifyButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.verified_rounded, size: 14, color: color),
            const SizedBox(width: 6),
            Text('Verify',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12, fontWeight: FontWeight.w700, color: color,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Rsp r;
  const _EmptyState({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.sp(36)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Icon(Icons.workspace_premium_outlined,
            size: 40, color: AppColors.textSecondary.withOpacity(0.5)),
        SizedBox(height: r.sp(12)),
        Text('Certificates coming soon',
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(14), color: AppColors.textSecondary,
          ),
        ),
      ]),
    );
  }
}