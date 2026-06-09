import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaiwi_portfolio/screens/responsive_screen.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';
import '../widgets/anime_character.dart';


class HomeScreen extends StatelessWidget {
  final VoidCallback onContactTap;
  final VoidCallback onProjectsTap;
  final ScrollController? scrollController;
  const HomeScreen({
    super.key,
    required this.onContactTap,
    required this.onProjectsTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      return Stack(
        children: [
          // Particle bg
          const Positioned.fill(child: _ParticleBg()),
          // Cyan glow top-left
          Positioned(top: -80, left: -80,
              child: _GlowBlob(AppColors.primary.withOpacity(0.07), 480)),
          // Purple glow bottom-right
          Positioned(bottom: -120, right: -80,
              child: _GlowBlob(AppColors.secondary.withOpacity(0.07), 520)),

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: r.hPad, vertical: r.vPad),
            child: r.sideBySide
                ? _DesktopHero(r: r,
                onContact: onContactTap,
                onProjects: onProjectsTap)
                : _MobileHero(r: r,
                onContact: onContactTap,
                onProjects: onProjectsTap),
          ),
        ],
      );
    });
  }
}

// ─── Desktop: text left, card right ──────────────────────────────────────────
class _DesktopHero extends StatelessWidget {
  final Rsp r;
  final VoidCallback onContact;
  final VoidCallback onProjects;
  const _DesktopHero(
      {required this.r, required this.onContact, required this.onProjects});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 55,
            child: _HeroText(r: r, onContact: onContact, onProjects: onProjects)),
        SizedBox(width: r.sp(48)),
        _ProfileCard(r: r),
      ],
    );
  }
}

// ─── Mobile: card top, text below — stacked vertically ─────────────────────────
class _MobileHero extends StatelessWidget {
  final Rsp r;
  final VoidCallback onContact;
  final VoidCallback onProjects;
  const _MobileHero(
      {required this.r, required this.onContact, required this.onProjects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: _ProfileCard(r: r)),
        SizedBox(height: r.sp(28)),
        _HeroText(r: r, onContact: onContact, onProjects: onProjects, centered: true),
      ],
    );
  }
}

// ─── Profile Card ─────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final Rsp r;
  const _ProfileCard({required this.r});

  @override
  Widget build(BuildContext context) {
    final w = r.profileCardWidth;
    final photoH = w * 1.08;

    return TiltCard(
      maxTilt: r.isMobile ? 4 : 8,
      child: Container(
        width: w,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.22), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.16),
                blurRadius: 48, spreadRadius: 3),
            BoxShadow(
                color: AppColors.secondary.withOpacity(0.10),
                blurRadius: 64, offset: const Offset(16, 24)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Photo
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(19)),
              child: SizedBox(
                width: w,
                height: photoH,
                child: Stack(fit: StackFit.expand, children: [
                  Image.asset(
                    'assets/images/profile.jpg',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.0, -0.3),
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: Center(
                        child: Icon(Icons.person_outline,
                            size: w * 0.3,
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                    ),
                  ),
                  // Top dark vignette
                  Positioned(top: 0, left: 0, right: 0,
                    child: Container(height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.45),
                              Colors.transparent]),
                      ),
                    ),
                  ),
                  // Green glow (matches photo bg)
                  Positioned(top: -30, right: -30,
                      child: _GlowBlob(
                          const Color(0xFF00FF88).withOpacity(0.15), 160)),
                  // Bottom fade into card
                  Positioned(bottom: 0, left: 0, right: 0,
                    child: Container(height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, AppColors.card],
                        ),
                      ),
                    ),
                  ),
                  // Badge top-right
                  Positioned(top: 14, right: 14,
                      child: _Badge('📱 Flutter Dev', AppColors.primary)),
                ]),
              ),
            ),

            // ── Info
            Padding(
              padding: EdgeInsets.fromLTRB(
                  r.sp(20), r.sp(6), r.sp(20), r.sp(20)),
              child: Column(
                children: [
                  Text(PortfolioData.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: r.fs(20),
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: r.sp(4)),
                  Text('@${PortfolioData.nickname}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: r.fs(12),
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: r.sp(12)),
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: const [
                      SkillTag(label: 'Flutter', color: 0xFF00D4FF),
                      SkillTag(label: 'Dart',    color: 0xFF00D4FF),
                      SkillTag(label: 'SEO',     color: 0xFF00FF88),
                      SkillTag(label: 'Marketing', color: 0xFF7B2FFF),
                    ],
                  ),
                  SizedBox(height: r.sp(12)),
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.accent.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PulsingDot(),
                        const SizedBox(width: 8),
                        Text('Open to work',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: r.fs(12),
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms, delay: 150.ms)
        .scale(begin: const Offset(0.93, 0.93),
        curve: Curves.easeOutBack);
  }
}

// ─── Hero Text ────────────────────────────────────────────────────────────────
class _HeroText extends StatelessWidget {
  final Rsp r;
  final VoidCallback onContact;
  final VoidCallback onProjects;
  final bool centered;
  const _HeroText({
    required this.r,
    required this.onContact,
    required this.onProjects,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    final align = centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final wrapAlign = centered ? WrapAlignment.center : WrapAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        // Available tag
        _AvailTag(r: r)
            .animate().fadeIn(duration: 500.ms, delay: 100.ms)
            .slideY(begin: -0.5, end: 0, curve: Curves.easeOutCubic),

        SizedBox(height: r.sp(22)),

        // Name — word by word
        _AnimatedName(r: r, centered: centered),

        SizedBox(height: r.sp(10)),

        // Typewriter title
        _TypewriterRow(r: r)
            .animate(delay: 550.ms)
            .fadeIn(duration: 450.ms)
            .slideX(begin: -0.1, end: 0, curve: Curves.easeOutCubic),

        SizedBox(height: r.sp(22)),

        // Bio
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            PortfolioData.bio,
            textAlign: textAlign,
            style: GoogleFonts.spaceGrotesk(
              fontSize: r.fs(15),
              color: AppColors.textSecondary,
              height: 1.8,
            ),
          ),
        )
            .animate(delay: 750.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),

        SizedBox(height: r.sp(36)),

        // Buttons
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: wrapAlign,
          children: [
            GlowButton(
              label: 'VIEW PROJECTS',
              onTap: onProjects,
              color: AppColors.primary,
              fontSize: r.fs(12),
            )
                .animate(delay: 950.ms)
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack),
            GlowButton(
              label: 'HIRE ME',
              onTap: onContact,
              color: AppColors.secondary,
              outlined: true,
              fontSize: r.fs(12),
            )
                .animate(delay: 1100.ms)
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack),
          ],
        ),

        SizedBox(height: r.sp(48)),

        // Stats
        _StatsRow(r: r, centered: centered)
            .animate(delay: 1250.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}

// ─── Animated name ────────────────────────────────────────────────────────────
class _AnimatedName extends StatelessWidget {
  final Rsp r;
  final bool centered;
  const _AnimatedName({required this.r, required this.centered});

  @override
  Widget build(BuildContext context) {
    final words = PortfolioData.name.split(' ');
    return Wrap(
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      children: words.asMap().entries.map((e) {
        final i = e.key;
        final word = e.value;
        return Padding(
          padding: EdgeInsets.only(right: i < words.length - 1 ? 10 : 0),
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (b) => LinearGradient(
              colors: i == 0
                  ? [AppColors.textPrimary, AppColors.textPrimary]
                  : [AppColors.primary, const Color(0xFF00B8E0)],
            ).createShader(b),
            child: Text(word,
              style: GoogleFonts.spaceGrotesk(
                fontSize: r.fs(60),
                fontWeight: FontWeight.w900,
                letterSpacing: -2.0,
                height: 1.05,
              ),
            ),
          )
              .animate(delay: (280 + i * 160).ms)
              .fadeIn(duration: 550.ms)
              .slideY(begin: 0.45, end: 0, curve: Curves.easeOutCubic)
              .blur(begin: const Offset(0, 6), end: Offset.zero,
              duration: 500.ms),
        );
      }).toList(),
    );
  }
}

// ─── Typewriter cycling title ─────────────────────────────────────────────────
class _TypewriterRow extends StatefulWidget {
  final Rsp r;
  const _TypewriterRow({required this.r});
  @override State<_TypewriterRow> createState() => _TypewriterRowState();
}
class _TypewriterRowState extends State<_TypewriterRow> {
  static const _roles = [
    'Flutter Developer',
    'SEO Specialist',
    'Digital Marketer',
    'Dart Programmer',
  ];
  int _ri = 0;
  String _text = '';
  bool _del = false;
  int _ci = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), _tick);
  }

  void _tick() {
    if (!mounted) return;
    final t = _roles[_ri];
    if (!_del) {
      if (_ci < t.length) {
        setState(() { _ci++; _text = t.substring(0, _ci); });
        Future.delayed(Duration(milliseconds: _ci == 1 ? 280 : 52), _tick);
      } else {
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) { setState(() => _del = true); _tick(); }
        });
      }
    } else {
      if (_ci > 0) {
        setState(() { _ci--; _text = t.substring(0, _ci); });
        Future.delayed(const Duration(milliseconds: 34), _tick);
      } else {
        setState(() { _del = false; _ri = (_ri + 1) % _roles.length; });
        Future.delayed(const Duration(milliseconds: 280), _tick);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('> ', style: GoogleFonts.jetBrainsMono(
          fontSize: widget.r.fs(16),
          color: AppColors.accent, fontWeight: FontWeight.w700)),
      Text(_text, style: GoogleFonts.jetBrainsMono(
          fontSize: widget.r.fs(16),
          color: AppColors.primary, fontWeight: FontWeight.w600)),
      _Cursor(fs: widget.r.fs(16)),
    ]);
  }
}

class _Cursor extends StatefulWidget {
  final double fs;
  const _Cursor({required this.fs});
  @override State<_Cursor> createState() => _CursorState();
}
class _CursorState extends State<_Cursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 520))..repeat(reverse: true);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _c,
      builder: (_, __) => Opacity(opacity: _c.value,
        child: Text('|', style: GoogleFonts.jetBrainsMono(
            fontSize: widget.fs,
            color: AppColors.accent, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ─── Available tag ────────────────────────────────────────────────────────────
class _AvailTag extends StatelessWidget {
  final Rsp r;
  const _AvailTag({required this.r});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: r.sp(14), vertical: r.sp(6)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(6),
        color: AppColors.accent.withOpacity(0.07),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const PulsingDot(size: 7),
        const SizedBox(width: 8),
        Text('AVAILABLE FOR HIRE',
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(10.5),
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
            color: AppColors.accent,
          ),
        ),
      ]),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final Rsp r;
  final bool centered;
  const _StatsRow({required this.r, required this.centered});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'v': '2+',  'l': 'Years Exp.'},
      {'v': '15+', 'l': 'Projects'},
      {'v': '10+', 'l': 'Clients'},
    ];
    return Wrap(
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 0, runSpacing: 16,
      children: stats.asMap().entries.map((e) {
        final i = e.key;
        return Row(mainAxisSize: MainAxisSize.min, children: [
          if (i > 0)
            Container(width: 1, height: 36,
                color: AppColors.border,
                margin: EdgeInsets.symmetric(horizontal: r.sp(22))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GradientText(e.value['v']!,
              style: GoogleFonts.spaceGrotesk(
                fontSize: r.fs(28),
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
              colors: const [AppColors.primary, AppColors.secondary],
            ),
            Text(e.value['l']!,
              style: GoogleFonts.spaceGrotesk(
                fontSize: r.fs(11),
                color: AppColors.textSecondary,
              ),
            ),
          ]),
        ]);
      }).toList(),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob(this.color, this.size);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
            colors: [color, Colors.transparent]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.62),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.45)),
        boxShadow: [BoxShadow(
            color: color.withOpacity(0.18), blurRadius: 12)],
      ),
      child: Text(text,
          style: GoogleFonts.jetBrainsMono(
              fontSize: 10, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

// ─── Particle background (lightweight) ───────────────────────────────────────
class _ParticleBg extends StatefulWidget {
  const _ParticleBg();
  @override State<_ParticleBg> createState() => _ParticleBgState();
}
class _ParticleBgState extends State<_ParticleBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  final _pts = <_Pt>[];

  @override
  void initState() {
    super.initState();
    final rng = identityHashCode(this);
    for (int i = 0; i < 55; i++) {
      _pts.add(_Pt(
        x: ((rng * (i + 1) * 1234567) % 1000) / 1000,
        y: ((rng * (i + 2) * 7654321) % 1000) / 1000,
        sz: 0.5 + ((rng * i * 13) % 100) / 50,
        spd: 0.04 + ((rng * i * 7) % 100) / 500,
        op: 0.08 + ((rng * i * 11) % 100) / 350,
        ci: i % 3,
      ));
    }
    _c = AnimationController(vsync: this,
        duration: const Duration(seconds: 1))..repeat();
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
    return CustomPaint(painter: _PtPainter(_pts),
        child: const SizedBox.expand());
  }
}

class _Pt {
  double x, y, sz, spd, op;
  int ci;
  _Pt({required this.x, required this.y, required this.sz,
    required this.spd, required this.op, required this.ci});
}

class _PtPainter extends CustomPainter {
  final List<_Pt> pts;
  static const _colors = [
    Color(0xFF00D4FF), Color(0xFF7B2FFF), Color(0xFF00FF88)];
  _PtPainter(this.pts);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pts) {
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.sz,
        Paint()
          ..color = _colors[p.ci].withOpacity(p.op)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
  }

  @override bool shouldRepaint(_PtPainter _) => true;
}