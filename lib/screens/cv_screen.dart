import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';

class CVScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const CVScreen({super.key, this.scrollController});

  @override
  State<CVScreen> createState() => _CVScreenState();
}

class _CVScreenState extends State<CVScreen> {
  bool _downloading = false;

  Future<void> _downloadCV() async {
    setState(() => _downloading = true);
    final uri = Uri.parse(PortfolioData.cvDownloadUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size     = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Stack(
      children: [
        // Background glows
        Positioned(
          top: 0, right: -150,
          child: Container(
            width: 450, height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.secondary.withOpacity(0.07),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -100, left: -100,
          child: Container(
            width: 400, height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.primary.withOpacity(0.06),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        SingleChildScrollView(
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 18 : 80,
            vertical: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section title
              const SectionTitle(
                tag: 'RESUME',
                title: 'My CV &\nResume',
                subtitle:
                'Download my full resume to see my experience, education, and everything I bring to the table.',
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOutCubic),

              const SizedBox(height: 56),

              isMobile
                  ? Column(children: [
                _buildCVCard(isMobile),
                const SizedBox(height: 32),
                _buildInfoCards(),
                const SizedBox(height: 32),
                _buildSocialLinks(),
                const SizedBox(height: 32),
                _buildResumeDetails(),
              ])
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildCVCard(isMobile)),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 5,
                    child: Column(children: [
                      _buildInfoCards(),
                      const SizedBox(height: 28),
                      _buildSocialLinks(),
                      const SizedBox(height: 28),
                      _buildResumeDetails(),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── CV card mock ─────────────────────────────────────────────────────────────
  Widget _buildCVCard(bool isMobile) {
    return TiltCard(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.card,
              AppColors.primary.withOpacity(0.04),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 40,
            ),
          ],
        ),
        child: Column(children: [
          // ── CV preview mock
          Container(
            margin: const EdgeInsets.all(24),
            height: 380,
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                        ),
                        child: const Center(
                          child: Text('SN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shawaiz Niamat',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16, fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              )),
                          Text('Flutter Mobile App Developer',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11, color: AppColors.primary,
                              )),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _cvDivider(),
                    const SizedBox(height: 12),
                    _cvSection('EDUCATION'),
                    const SizedBox(height: 6),
                    Text('BS Computer Science — Superior University, Lahore',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 9, color: AppColors.textSecondary),
                    ),
                    Text('5th Semester · 2024 – 2028',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 9,
                          color: AppColors.textSecondary.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 12),
                    _cvSection('TECHNICAL SKILLS'),
                    const SizedBox(height: 6),
                    Wrap(spacing: 4, runSpacing: 4, children: [
                      _cvChip('Flutter', AppColors.primary),
                      _cvChip('Dart', AppColors.primary),
                      _cvChip('Firebase', AppColors.accent),
                      _cvChip('Git', AppColors.secondary),
                      _cvChip('SQL', AppColors.secondary),
                      _cvChip('C++', const Color(0xFFFF6B35)),
                    ]),
                    const SizedBox(height: 12),
                    _cvSection('PROJECTS'),
                    const SizedBox(height: 6),
                    _cvLine(0.9),
                    _cvLine(0.75),
                    _cvLine(0.82),
                    const SizedBox(height: 12),
                    _cvSection('CONTACT'),
                    const SizedBox(height: 6),
                    Text('shawaizengg454@gmail.com',
                      style: GoogleFonts.jetBrainsMono(
                          fontSize: 8, color: AppColors.primary),
                    ),
                    Text('+92 315 6434296  ·  Lahore, Pakistan',
                      style: GoogleFonts.jetBrainsMono(
                          fontSize: 8,
                          color: AppColors.textSecondary.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              // Blur overlay at bottom
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0A1628).withOpacity(0),
                        const Color(0xFF0A1628),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '— Download to view full resume —',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),

          // ── Download buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: _DownloadButton(
                    onTap: _downloadCV, isLoading: _downloading),
              ),
              const SizedBox(height: 12),
              // ── Preview Online button (opens in browser)
              GestureDetector(
                onTap: () => _launch(PortfolioData.cvPreviewUrl),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.open_in_browser_rounded,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text('Preview Online',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.05, curve: Curves.easeOutCubic);
  }

  // ── Stats cards ───────────────────────────────────────────────────────────────
  Widget _buildInfoCards() {
    final highlights = [
      {
        'icon': Icons.work_outline_rounded,   'color': AppColors.primary,
        'title': 'Experience',                'value': '2+ Yrs',
        'desc': 'Flutter & Web development in production apps',
      },
      {
        'icon': Icons.check_circle_outline_rounded, 'color': AppColors.accent,
        'title': 'Projects Done',             'value': '15+',
        'desc': 'Mobile apps, websites, and marketing campaigns',
      },
      {
        'icon': Icons.people_outline_rounded, 'color': AppColors.secondary,
        'title': 'Happy Clients',             'value': '10+',
        'desc': 'From startups to growing businesses',
      },
      {
        'icon': Icons.language_rounded,       'color': const Color(0xFFFF6B35),
        'title': 'Technologies',              'value': '12+',
        'desc': 'Flutter, Dart, HTML, CSS, JS, MySQL & more',
      },
    ];

    return Column(
      children: highlights.asMap().entries.map((e) {
        final i     = e.key;
        final h     = e.value;
        final color = h['color'] as Color;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: NeonCard(
            glowColor: color,
            padding: const EdgeInsets.all(22),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(h['icon'] as IconData, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(h['title'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary, letterSpacing: 0.5,
                        ),
                      ),
                      GradientText(
                        h['value'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22, fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                        colors: [color, color.withOpacity(0.5)],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(h['desc'] as String,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12, color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              )),
            ]),
          )
              .animate(delay: (i * 100).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.1, curve: Curves.easeOutCubic),
        );
      }).toList(),
    );
  }

  // ── Social / contact links ────────────────────────────────────────────────────
  Widget _buildSocialLinks() {
    final links = [
      {
        'icon': Icons.email_outlined,
        'label': 'Email',
        'value': 'shawaizengg454@gmail.com',
        'url':   'mailto:shawaizengg454@gmail.com',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.phone_rounded,
        'label': 'WhatsApp',
        'value': '+92 315 6434296',
        'url':   'https://wa.me/923156434296',
        'color': const Color(0xFF25D366),
      },
      {
        'icon': Icons.code_rounded,
        'label': 'GitHub',
        'value': 'SHAIVI153',
        'url':   'https://github.com/SHAIVI153',
        'color': AppColors.textPrimary,
      },
      {
        'icon': Icons.work_outline_rounded,
        'label': 'LinkedIn',
        'value': 'Shawaiz Niamat',
        'url':   'https://linkedin.com/in/shawaiz-niamat',
        'color': const Color(0xFF0077B5),
      },
      {
        'icon': Icons.camera_alt_outlined,
        'label': 'Instagram',
        'value': 'shawaiz._.niamat',
        'url':   'https://instagram.com/shawaiz._.niamat',
        'color': const Color(0xFFE1306C),
      },
      {
        'icon': Icons.facebook_rounded,
        'label': 'Facebook',
        'value': 'Shawaiz Niamat',
        'url':   'https://facebook.com/shawaiz.niamat',
        'color': const Color(0xFF1877F2),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
            color: AppColors.accent.withOpacity(0.07),
          ),
          child: Text('CONNECT WITH ME',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10, fontWeight: FontWeight.w700,
              letterSpacing: 2.5, color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 14),

        ...links.asMap().entries.map((e) {
          final i  = e.key;
          final lk = e.value;
          final c  = lk['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => _launch(lk['url'] as String),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: NeonCard(
                  glowColor: c,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(children: [
                    Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: c.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.withOpacity(0.3)),
                      ),
                      child: Icon(lk['icon'] as IconData,
                          color: c, size: 17),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lk['label'] as String,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10, fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary, letterSpacing: 0.8,
                          ),
                        ),
                        Text(lk['value'] as String,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13, fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: c.withOpacity(0.45), size: 12),
                  ]),
                ),
              ),
            )
                .animate(delay: (i * 60).ms)
                .fadeIn(duration: 350.ms)
                .slideX(begin: 0.05, curve: Curves.easeOutCubic),
          );
        }),
      ],
    );
  }

  // ── Resume highlights from actual CV ─────────────────────────────────────────
  Widget _buildResumeDetails() {
    final items = [
      {
        'icon': Icons.school_outlined,
        'color': AppColors.primary,
        'title': 'BS Computer Science',
        'sub':   'Superior University, Lahore',
        'detail':'5th Semester · 2024 – 2028',
      },
      {
        'icon': Icons.restaurant_menu_outlined,
        'color': AppColors.accent,
        'title': 'Restaurant Management System',
        'sub':   'Flutter · Dart · Firebase · SQL',
        'detail':'Orders, menu control, billing & real-time sync',
      },
      {
        'icon': Icons.school_rounded,
        'color': AppColors.secondary,
        'title': 'Student Portal App',
        'sub':   'Flutter · Dart · Firebase',
        'detail':'Course registration, grades & push notifications',
      },
      {
        'icon': Icons.task_alt_rounded,
        'color': const Color(0xFFFF6B35),
        'title': 'Task Management App',
        'sub':   'Flutter · Dart · SQLite',
        'detail':'Categories, priorities, deadlines, offline-first',
      },
      {
        'icon': Icons.location_on_outlined,
        'color': AppColors.primary,
        'title': 'Lahore, Gulberg, Pakistan',
        'sub':   'Available for remote & on-site',
        'detail':'+92 315 6434296',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
            color: AppColors.secondary.withOpacity(0.07),
          ),
          child: Text('RESUME HIGHLIGHTS',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10, fontWeight: FontWeight.w700,
              letterSpacing: 2.5, color: AppColors.secondary,
            ),
          ),
        ),
        const SizedBox(height: 14),

        ...items.asMap().entries.map((e) {
          final i    = e.key;
          final item = e.value;
          final c    = item['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NeonCard(
              glowColor: c,
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: c.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: c.withOpacity(0.3)),
                    ),
                    child: Icon(item['icon'] as IconData,
                        color: c, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13, fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(item['sub'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: c,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(item['detail'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11.5, color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            )
                .animate(delay: (i * 80).ms)
                .fadeIn(duration: 380.ms)
                .slideY(begin: 0.06, curve: Curves.easeOutCubic),
          );
        }),
      ],
    );
  }

  // ── CV mock helpers ────────────────────────────────────────────────────────────
  Widget _cvDivider() => Container(height: 1, color: AppColors.border);

  Widget _cvSection(String label) => Text(label,
    style: GoogleFonts.jetBrainsMono(
      fontSize: 9, fontWeight: FontWeight.w700,
      color: AppColors.primary, letterSpacing: 2,
    ),
  );

  Widget _cvLine(double width) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    height: 8,
    width: double.infinity,
    child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );

  Widget _cvChip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(label,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 9, color: color, fontWeight: FontWeight.w700,
      ),
    ),
  );
}

// ─── Animated download button ──────────────────────────────────────────────────
class _DownloadButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool         isLoading;
  const _DownloadButton({required this.onTap, required this.isLoading});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton>
    with SingleTickerProviderStateMixin {
  bool _hovering = false;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit:  (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (_, child) => Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(
                      _hovering ? 0.6 : 0.2 + _pulseCtrl.value * 0.2),
                  blurRadius:
                  _hovering ? 30 : 16 + _pulseCtrl.value * 10,
                  spreadRadius: _hovering ? 2 : 0,
                ),
              ],
            ),
            child: child,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              else
                const Icon(Icons.download_rounded,
                    color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                widget.isLoading ? 'Opening...' : 'Download CV  (.pdf)',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

