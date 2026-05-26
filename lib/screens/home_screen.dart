import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onContactTap;
  final VoidCallback onProjectsTap;

  const HomeScreen({
    super.key,
    required this.onContactTap,
    required this.onProjectsTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Stack(
      children: [
        // ── Animated particle background
        const Positioned.fill(child: ParticleBackground()),

        // ── Radial glows
        Positioned(
          top: -120,
          left: -120,
          child: Container(
            width: 550,
            height: 550,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.primary.withOpacity(0.07),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          right: -100,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.secondary.withOpacity(0.07),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        // ── Content
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80,
              vertical: isMobile ? 32 : 40,
            ),
            child: isMobile
                ? _buildMobileLayout(context, size)
                : _buildDesktopLayout(context, size),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DESKTOP LAYOUT
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildDesktopLayout(BuildContext context, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _buildHeroText(isMobile: false)),
        const SizedBox(width: 60),
        _buildProfileCard(isMobile: false, screenWidth: size.width),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // MOBILE LAYOUT
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfileCard(isMobile: true, screenWidth: size.width),
        const SizedBox(height: 40),
        _buildHeroText(isMobile: true),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PROFILE CARD — Responsive, professional, full photo
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildProfileCard({required bool isMobile, required double screenWidth}) {
    // Responsive card width
    final cardWidth = isMobile
        ? (screenWidth - 40).clamp(260.0, 340.0)
        : 320.0;
    // Photo height: taller on desktop, comfortable on mobile
    final photoHeight = isMobile ? cardWidth * 1.05 : cardWidth * 1.1;

    return TiltCard(
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.25),
            width: 1.5,
          ),
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.18),
              blurRadius: 50,
              spreadRadius: 4,
            ),
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.10),
              blurRadius: 70,
              offset: const Offset(20, 30),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Photo section — fills card width, properly cropped
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
              child: SizedBox(
                width: cardWidth,
                height: photoHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Actual photo — centered on face
                    Image.asset(
                      'assets/images/profile.jpg',
                      width: cardWidth,
                      height: photoHeight,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.0, -0.35), // slight up = show face fully
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline,
                                  size: 56,
                                  color: AppColors.primary.withOpacity(0.35)),
                              const SizedBox(height: 8),
                              Text('profile.jpg',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Subtle dark vignette at top so badge is readable
                    Positioned(
                      top: 0, left: 0, right: 0,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.45),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Green glow from top-right (matches photo bg)
                    Positioned(
                      top: -20, right: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFF00FF88).withOpacity(0.18),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),

                    // Gradient fade at bottom into card bg
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.card.withOpacity(0.95),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Flutter Dev badge — top right
                    Positioned(
                      top: 14, right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('📱', style: TextStyle(fontSize: 10)),
                            const SizedBox(width: 4),
                            Text('Flutter Dev',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Info section below photo
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name
                  Text(
                    PortfolioData.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: isMobile ? 19 : 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Nickname
                  Text(
                    '@${PortfolioData.nickname}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Skill badges — Flutter, Dart, SEO only (web removed)
                  const Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    alignment: WrapAlignment.center,
                    children: [
                      SkillTag(label: 'Flutter', color: AppColors.primary),
                      SkillTag(label: 'Dart', color: AppColors.primary),
                      SkillTag(label: 'SEO', color: AppColors.accent),
                      SkillTag(
                          label: 'Digital Marketing',
                          color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Status dot
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.accent.withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _PulsingDot(),
                        const SizedBox(width: 8),
                        Text('Open to work',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            )),
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
        .fadeIn(duration: 800.ms, delay: 200.ms)
        .scale(
      begin: const Offset(0.92, 0.92),
      curve: Curves.easeOutBack,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HERO TEXT — Webflow-style staggered cinematic animation
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildHeroText({required bool isMobile}) {
    return Column(
      crossAxisAlignment:
      isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── "Available" tag — slides down + fade
        _AvailableTag()
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideY(begin: -0.6, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 28),

        // ── Name — letters reveal one by one (Webflow style)
        _AnimatedName(isMobile: isMobile),

        const SizedBox(height: 10),

        // ── Title line — typewriter + slide
        _TypewriterTitle()
            .animate(delay: 600.ms)
            .fadeIn(duration: 500.ms)
            .slideX(begin: -0.15, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 30),

        // ── Bio — word-by-word appear
        _AnimatedBio(isMobile: isMobile)
            .animate(delay: 800.ms)
            .fadeIn(duration: 700.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 44),

        // ── Buttons — staggered pop-in
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            GlowButton(
              label: 'VIEW PROJECTS',
              onTap: onProjectsTap,
              color: AppColors.primary,
            )
                .animate(delay: 1000.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack),
            GlowButton(
              label: 'HIRE ME',
              onTap: onContactTap,
              color: AppColors.secondary,
              outlined: true,
            )
                .animate(delay: 1150.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack),
          ],
        ),

        const SizedBox(height: 56),

        // ── Stats row — count-up animation
        _StatsRow(isMobile: isMobile)
            .animate(delay: 1300.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED NAME — each word slides + fades like Webflow hero text
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedName extends StatelessWidget {
  final bool isMobile;
  const _AnimatedName({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final words = PortfolioData.name.split(' ');
    return Wrap(
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: words.asMap().entries.map((entry) {
        final i = entry.key;
        final word = entry.value;
        final isLast = i == words.length - 1;
        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 10),
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              colors: i == 0
                  ? [AppColors.textPrimary, AppColors.textPrimary]
                  : [AppColors.primary, const Color(0xFF00A8CC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              word,
              style: GoogleFonts.spaceGrotesk(
                fontSize: isMobile ? 44 : 62,
                fontWeight: FontWeight.w900,
                letterSpacing: -2.0,
                height: 1.05,
              ),
            ),
          )
              .animate(delay: (300 + i * 180).ms)
              .fadeIn(duration: 600.ms)
              .slideY(
            begin: 0.5,
            end: 0,
            duration: 600.ms,
            curve: Curves.easeOutCubic,
          )
              .blur(
            begin: const Offset(0, 8),
            end: Offset.zero,
            duration: 500.ms,
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPEWRITER TITLE — "Flutter Developer • SEO & Digital Marketing"
// ─────────────────────────────────────────────────────────────────────────────
class _TypewriterTitle extends StatefulWidget {
  @override
  State<_TypewriterTitle> createState() => _TypewriterTitleState();
}

class _TypewriterTitleState extends State<_TypewriterTitle> {
  // Roles to cycle through
  static const _roles = [
    'Flutter Developer',
    'SEO Specialist',
    'Digital Marketer',
    'Dart Programmer',
    'Web Developer',
  ];

  int _roleIndex = 0;
  String _displayed = '';
  bool _deleting = false;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), _type);
  }

  void _type() {
    if (!mounted) return;
    final target = _roles[_roleIndex];

    if (!_deleting) {
      if (_charIndex < target.length) {
        setState(() {
          _charIndex++;
          _displayed = target.substring(0, _charIndex);
        });
        Future.delayed(
            Duration(milliseconds: _charIndex == 1 ? 300 : 55), _type);
      } else {
        // Pause then delete
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) {
            setState(() => _deleting = true);
            _type();
          }
        });
      }
    } else {
      if (_charIndex > 0) {
        setState(() {
          _charIndex--;
          _displayed = target.substring(0, _charIndex);
        });
        Future.delayed(const Duration(milliseconds: 35), _type);
      } else {
        setState(() {
          _deleting = false;
          _roleIndex = (_roleIndex + 1) % _roles.length;
        });
        Future.delayed(const Duration(milliseconds: 300), _type);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '> ',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 18,
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          _displayed,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 18,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        _BlinkingCursor(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED BIO — slides up with slight blur (Webflow-style reveal)
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedBio extends StatelessWidget {
  final bool isMobile;
  const _AnimatedBio({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 540),
      child: Text(
        PortfolioData.bio,
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 15,
          color: AppColors.textSecondary,
          height: 1.85,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AVAILABLE TAG
// ─────────────────────────────────────────────────────────────────────────────
class _AvailableTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent.withOpacity(0.45)),
        borderRadius: BorderRadius.circular(6),
        color: AppColors.accent.withOpacity(0.07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(color: AppColors.accent, size: 7),
          const SizedBox(width: 8),
          Text(
            'AVAILABLE FOR HIRE',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PULSING DOT
// ─────────────────────────────────────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;
  const _PulsingDot({
    this.color = AppColors.accent,
    this.size = 8,
  });

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
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
      builder: (_, __) => Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.3 + _ctrl.value * 0.5),
              blurRadius: 4 + _ctrl.value * 8,
              spreadRadius: _ctrl.value * 2,
            )
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BLINKING CURSOR
// ─────────────────────────────────────────────────────────────────────────────
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
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
      builder: (_, __) => Opacity(
        opacity: _ctrl.value,
        child: Text(
          '|',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 18,
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATS ROW — with count-up numbers
// ─────────────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final bool isMobile;
  const _StatsRow({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'value': '2+', 'label': 'Years Exp.'},
      {'value': '15+', 'label': 'Projects'},
      {'value': '10+', 'label': 'Happy Clients'},
    ];

    return Wrap(
      spacing: 0,
      runSpacing: 20,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: stats.asMap().entries.map((entry) {
        final i = entry.key;
        final stat = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (i > 0)
              Container(
                width: 1,
                height: 38,
                color: AppColors.border,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
            _CountUpStat(
              value: stat['value']!,
              label: stat['label']!,
              delay: i * 150,
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _CountUpStat extends StatelessWidget {
  final String value;
  final String label;
  final int delay;

  const _CountUpStat({
    required this.value,
    required this.label,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientText(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
          colors: const [AppColors.primary, AppColors.secondary],
        )
            .animate(delay: Duration(milliseconds: delay))
            .fadeIn(duration: 500.ms)
            .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeOutBack,
        ),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}