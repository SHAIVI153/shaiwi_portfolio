import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';
import 'responsive_screen.dart';

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
    final uri = Uri.parse('https://drive.google.com/uc?export=download&id=11XcX6NRmxBSaR-oaDD0LY8MCH7Unhrt9');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      final isMobile = r.isMobile;

      return Stack(
        children: [
          // Background glows
          Positioned(
            top: 0,
            right: -150,
            child: Container(
              width: 450,
              height: 450,
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
            bottom: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.06),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          Padding(
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
                    ? Column(
                  children: [
                    _buildCVCard(isMobile),
                    const SizedBox(height: 32),
                    _buildInfoCards(isMobile),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildCVCard(isMobile)),
                    const SizedBox(width: 32),
                    Expanded(flex: 5, child: _buildInfoCards(isMobile)),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }); // end ResponsiveBuilder
  }

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
        child: Column(
          children: [
            // ── CV Preview mock
            Container(
              margin: const EdgeInsets.all(24),
              height: isMobile ? 280 : 340,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1628),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  // CV mock content — scrollable inside fixed box
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
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
                                  Text(PortfolioData.name,
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      )),
                                  Text(PortfolioData.title,
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 11,
                                        color: AppColors.primary,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _cvDivider(),
                          const SizedBox(height: 12),
                          _cvSection('EXPERIENCE'),
                          const SizedBox(height: 6),
                          _cvLine(0.85),
                          _cvLine(0.65),
                          _cvLine(0.75),
                          const SizedBox(height: 12),
                          _cvSection('SKILLS'),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _cvChip('Flutter', AppColors.primary),
                              const SizedBox(width: 6),
                              _cvChip('Dart', AppColors.primary),
                              const SizedBox(width: 6),
                              _cvChip('SEO', AppColors.accent),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _cvChip('MySQL', AppColors.secondary),
                              const SizedBox(width: 6),
                              _cvChip('Bootstrap', AppColors.secondary),
                              const SizedBox(width: 6),
                              _cvChip('JS', AppColors.secondary),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _cvSection('EDUCATION'),
                          const SizedBox(height: 6),
                          _cvLine(0.7),
                          _cvLine(0.5),
                          const SizedBox(height: 12),
                          _cvSection('CONTACT'),
                          const SizedBox(height: 6),
                          _cvLine(0.6),
                          _cvLine(0.5),
                        ],
                      ),
                    ),
                  ),  // Positioned.fill
                  // Blur overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
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
                ],
              ),
            ),

            // ── Download button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  // Primary download
                  SizedBox(
                    width: double.infinity,
                    child: _DownloadButton(
                      onTap: _downloadCV,
                      isLoading: _downloading,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Secondary — view online
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.parse('https://drive.google.com/uc?export=download&id=11XcX6NRmxBSaR-oaDD0LY8MCH7Unhrt9');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
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
                              size: 16,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            'Preview Online',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
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
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.05, curve: Curves.easeOutCubic);
  }

  Widget _buildInfoCards(bool isMobile) {
    final highlights = [
      {
        'icon': Icons.work_outline_rounded,
        'color': AppColors.primary,
        'title': 'Work Experience',
        'value': '2+ Years',
        'desc': 'Flutter & Web development in production apps',
      },
      {
        'icon': Icons.check_circle_outline_rounded,
        'color': AppColors.accent,
        'title': 'Projects Completed',
        'value': '15+',
        'desc': 'Mobile apps, websites, and marketing campaigns',
      },
      {
        'icon': Icons.people_outline_rounded,
        'color': AppColors.secondary,
        'title': 'Happy Clients',
        'value': '10+',
        'desc': 'From startups to growing businesses',
      },
      {
        'icon': Icons.language_rounded,
        'color': const Color(0xFFFF6B35),
        'title': 'Technologies',
        'value': '12+',
        'desc': 'Flutter, Dart, HTML, CSS, JS, MySQL, Bootstrap & more',
      },
    ];

    return Column(
      children: highlights.asMap().entries.map((entry) {
        final i = entry.key;
        final h = entry.value;
        final color = h['color'] as Color;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: NeonCard(
            glowColor: color,
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(h['icon'] as IconData, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            h['title'] as String,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          GradientText(
                            h['value'] as String,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                            colors: [color, color.withOpacity(0.5)],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        h['desc'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate(delay: (i * 100).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.1, curve: Curves.easeOutCubic),
        );
      }).toList(),
    );
  }

  // ── CV mock helpers
  Widget _cvDivider() => Container(
    height: 1,
    color: AppColors.border,
  );

  Widget _cvSection(String label) => Text(
    label,
    style: GoogleFonts.jetBrainsMono(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
      letterSpacing: 2,
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
    child: Text(
      label,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 9,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

// ─── Animated download button ─────────────────────────────────────────────────
class _DownloadButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;

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
      vsync: this,
      duration: const Duration(seconds: 2),
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
      onExit: (_) => setState(() => _hovering = false),
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
                  blurRadius: _hovering ? 30 : 16 + _pulseCtrl.value * 10,
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
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                const Icon(Icons.download_rounded,
                    color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                widget.isLoading ? 'Opening...' : 'Download CV  (.pdf)',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}