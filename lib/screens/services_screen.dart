import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaiwi_portfolio/screens/responsive_screen.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';
import '../widgets/anime_character.dart';

class ServicesScreen extends StatelessWidget {
  final VoidCallback onHireTap;
  final ScrollController? scrollController;
  const ServicesScreen({
    super.key,
    required this.onHireTap,
    this.scrollController,
  });

  static const _colors = [
    AppColors.primary, AppColors.secondary,
    AppColors.accent, Color(0xFFFF6B35),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      return CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: r.hPad, vertical: r.vPad),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Header
                _buildHeader(r),
                SizedBox(height: r.sp(44)),

                // ── Services grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: r.grid2(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: r.isMobile ? 1.45 : 1.35,
                  ),
                  itemCount: PortfolioData.services.length,
                  itemBuilder: (_, i) {
                    final sv = PortfolioData.services[i];
                    final c = _colors[i];
                    return TiltCard(
                      maxTilt: r.isMobile ? 3 : 7,
                      child: NeonCard(
                        glowColor: c,
                        padding: EdgeInsets.all(r.sp(22)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('0${i + 1}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: r.fs(11),
                                        fontWeight: FontWeight.w700,
                                        color: c.withOpacity(0.45),
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Text(sv['icon']!,
                                        style: TextStyle(fontSize: r.fs(26))),
                                  ],
                                ),
                                SizedBox(height: r.sp(12)),
                                Text(sv['title']!,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: r.fs(17),
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                SizedBox(height: r.sp(8)),
                                Text(sv['desc']!,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: r.fs(12.5),
                                    color: AppColors.textSecondary,
                                    height: 1.65,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [c, Colors.transparent]),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: (i * 100).ms)
                        .fadeIn(duration: 420.ms)
                        .slideY(begin: 0.14, curve: Curves.easeOutCubic);
                  },
                ),

                SizedBox(height: r.sp(60)),

                // ── CTA banner
                TiltCard(
                  maxTilt: r.isMobile ? 2 : 5,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(r.sp(40)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.09),
                          AppColors.secondary.withOpacity(0.09),
                        ],
                      ),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Column(children: [
                      GradientText(
                        "Let's Build\nSomething Great",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: r.fs(38),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.3, height: 1.1,
                        ),
                        colors: const [AppColors.primary, AppColors.secondary],
                      ),
                      SizedBox(height: r.sp(14)),
                      Text(
                        "Have a project in mind? Let's talk.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: r.fs(14),
                          color: AppColors.textSecondary, height: 1.7,
                        ),
                      ),
                      SizedBox(height: r.sp(28)),
                      GlowButton(
                        label: "LET'S WORK TOGETHER",
                        onTap: onHireTap,
                        color: AppColors.primary,
                        fontSize: r.fs(12),
                      ),
                    ]),
                  ),
                )
                    .animate(delay: 500.ms)
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.96, 0.96),
                    curve: Curves.easeOutBack),

                // ── Footer
                SizedBox(height: r.sp(60)),
                _Footer(r: r),
                SizedBox(height: r.sp(32)),
              ]),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHeader(Rsp r) {
    return r.sideBySide
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: SectionHeader(
        tag: 'WHAT I DO',
        title: 'Services\nI Offer',
        subtitle: 'End-to-end mobile & digital solutions.',
        titleFs: r.sectionTitleFs,
      )),
      AnimeCharacter(section: 'services', size: r.sp(190)),
    ])
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: SectionHeader(
        tag: 'WHAT I DO',
        title: 'Services\nI Offer',
        subtitle: 'End-to-end solutions.',
        titleFs: r.sectionTitleFs,
      )),
      SizedBox(width: r.sp(12)),
      AnimeCharacter(section: 'services', size: r.sp(110)),
    ]);
  }
}

class _Footer extends StatelessWidget {
  final Rsp r;
  const _Footer({required this.r});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: r.sp(24)),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GradientText('shaiwi_code',
            style: GoogleFonts.spaceGrotesk(
                fontSize: r.fs(14), fontWeight: FontWeight.w900),
            colors: const [AppColors.primary, AppColors.secondary],
          ),
          Text('© 2025 Shawaiz Niamat',
            style: GoogleFonts.spaceGrotesk(
                fontSize: r.fs(11), color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}