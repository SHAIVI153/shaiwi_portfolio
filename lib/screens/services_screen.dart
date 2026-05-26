import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';

class ServicesScreen extends StatelessWidget {
  final VoidCallback onHireTap;
  const ServicesScreen({super.key, required this.onHireTap});

  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    Color(0xFFFF6B35),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            tag: 'WHAT I DO',
            title: 'Services\nI Offer',
            subtitle:
            'End-to-end digital solutions — from mobile apps to marketing strategies.',
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.3, curve: Curves.easeOutCubic),

          const SizedBox(height: 56),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 1.6 : 1.4,
            ),
            itemCount: PortfolioData.services.length,
            itemBuilder: (context, i) {
              final service = PortfolioData.services[i];
              final color = _colors[i];
              return TiltCard(
                child: NeonCard(
                  glowColor: color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Number + icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0${i + 1}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: color.withOpacity(0.5),
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                service['icon']!,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            service['title']!,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            service['desc']!,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                      // Bottom line accent
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, Colors.transparent],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: (i * 100).ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOutCubic);
            },
          ),

          const SizedBox(height: 72),

          // CTA Banner
          TiltCard(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  GradientText(
                    "Let's Build\nSomething Great",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: isMobile ? 32 : 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      height: 1.1,
                    ),
                    colors: const [AppColors.primary, AppColors.secondary],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Have a project in mind? Let\'s talk about how I can\nhelp you turn your vision into reality.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GlowButton(
                    label: "LET'S WORK TOGETHER",
                    onTap: onHireTap,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          )
              .animate(delay: 500.ms)
              .fadeIn(duration: 500.ms)
              .scale(
            begin: const Offset(0.95, 0.95),
            curve: Curves.easeOutBack,
          ),
        ],
      ),
    );
  }
}