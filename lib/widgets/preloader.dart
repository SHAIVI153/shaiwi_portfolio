// ═══════════════════════════════════════════════════════════════════════════════
//  preloader.dart — Intro loading animation (Webflow-style splash)
//
//  Inspired by the "water-fill" logo reveal used on the video-portfolio site,
//  rebuilt in Flutter and re-skinned with shaiwi_code's own cyan / purple /
//  green brand palette (AppColors) instead of changing the visual theme.
//
//  Flow:
//   1. Full-screen panel in AppColors.background covers the app.
//   2. "shaiwi_code" logo fills from bottom -> top with the brand gradient.
//   3. After a short pause the whole panel slides up and off-screen,
//      revealing the real app underneath (Shell).
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class AppPreloader extends StatefulWidget {
  final Widget child;
  const AppPreloader({super.key, required this.child});

  @override
  State<AppPreloader> createState() => _AppPreloaderState();
}

class _AppPreloaderState extends State<AppPreloader>
    with TickerProviderStateMixin {
  late final AnimationController _fillCtrl;
  late final AnimationController _exitCtrl;
  bool _removed = false;

  @override
  void initState() {
    super.initState();

    _fillCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    // Fill animation (1.5s) + short pause (0.5s) before the panel exits.
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      _exitCtrl.forward().whenCompleteOrCancel(() {
        if (mounted) setState(() => _removed = true);
      });
    });
  }

  @override
  void dispose() {
    _fillCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_removed)
          AnimatedBuilder(
            animation: _exitCtrl,
            builder: (context, _) {
              final t = Curves.easeInOutCubic.transform(_exitCtrl.value);
              final h = MediaQuery.of(context).size.height;
              return Transform.translate(
                offset: Offset(0, -h * t),
                child: IgnorePointer(
                  ignoring: _exitCtrl.value > 0,
                  child: _PreloaderPanel(fillCtrl: _fillCtrl, exitT: t),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _PreloaderPanel extends StatelessWidget {
  final AnimationController fillCtrl;
  final double exitT;
  const _PreloaderPanel({required this.fillCtrl, required this.exitT});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft brand glow blobs (kept subtle, matches shaiwi's own aesthetic)
          Positioned(
            top: -100,
            left: -100,
            child: _blob(AppColors.primary.withOpacity(0.10), 380),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: _blob(AppColors.secondary.withOpacity(0.10), 420),
          ),

          Opacity(
            opacity: 1 - exitT.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, -20 * exitT),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 76,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dim background copy of the logo (empty state)
                        Text(
                          'shaiwi_code',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            color: AppColors.textPrimary.withOpacity(0.08),
                          ),
                        ),
                        // Gradient-filled logo, revealed bottom -> top
                        AnimatedBuilder(
                          animation: fillCtrl,
                          builder: (context, child) => ClipRect(
                            clipper: _BottomUpClipper(fillCtrl.value),
                            child: child,
                          ),
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (b) => const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ).createShader(b),
                            child: Text(
                              'shaiwi_code',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedBuilder(
                    animation: fillCtrl,
                    builder: (context, _) => Opacity(
                      opacity: fillCtrl.value.clamp(0.0, 1.0),
                      child: Text(
                        'FLUTTER & WEB DEVELOPER',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                          color: AppColors.textSecondary,
                        ),
                      ),
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

  Widget _blob(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent]),
    ),
  );
}

/// Reveals its child from the bottom edge upward as [progress] goes 0 -> 1,
/// used for the "water fill" logo animation.
class _BottomUpClipper extends CustomClipper<Rect> {
  final double progress;
  _BottomUpClipper(this.progress);

  @override
  Rect getClip(Size size) {
    final revealed = size.height * progress.clamp(0.0, 1.0);
    return Rect.fromLTWH(0, size.height - revealed, size.width, revealed);
  }

  @override
  bool shouldReclip(covariant _BottomUpClipper oldClipper) =>
      oldClipper.progress != progress;
}