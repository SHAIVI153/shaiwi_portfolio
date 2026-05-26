import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final crossAxisCount = isMobile ? 1 : 2;

    return Stack(
      children: [
        // Background glow
        Positioned(
          top: 100,
          right: -200,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.secondary.withOpacity(0.06),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 80,
            vertical: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                tag: 'EXPERTISE',
                title: 'Skills &\nTechnologies',
                subtitle:
                'A full-stack toolkit — from pixel-perfect Flutter UIs to SEO-optimized web solutions.',
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOutCubic),

              const SizedBox(height: 56),

              // Skills grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: isMobile ? 1.3 : 1.1,
                ),
                itemCount: PortfolioData.skills.length,
                itemBuilder: (context, i) {
                  final skill = PortfolioData.skills[i];
                  final color = Color(skill['color'] as int);
                  return TiltCard(
                    child: NeonCard(
                      glowColor: color,
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: color.withOpacity(0.3)),
                                ),
                                child: Center(
                                  child: Text(
                                    skill['icon'] as String,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  skill['category'] as String,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (skill['items'] as List<String>)
                                .map((item) => SkillTag(
                              label: item,
                              color: color,
                            ))
                                .toList(),
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

              const SizedBox(height: 60),

              // Proficiency bars
              const SectionTitle(
                tag: 'PROFICIENCY',
                title: 'Core\nStack',
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 32),

              ...[
                {'label': 'Flutter & Dart', 'value': 0.88, 'color': AppColors.primary},
                {'label': 'HTML / CSS / JS', 'value': 0.85, 'color': AppColors.secondary},
                {'label': 'Bootstrap', 'value': 0.80, 'color': AppColors.accent},
                {'label': 'MySQL', 'value': 0.72, 'color': const Color(0xFFFF6B35)},
                {'label': 'SEO & Digital Marketing', 'value': 0.78, 'color': const Color(0xFFFFD60A)},
              ].asMap().entries.map((entry) {
                final i = entry.key;
                final bar = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _SkillBar(
                    label: bar['label'] as String,
                    value: bar['value'] as double,
                    color: bar['color'] as Color,
                  ).animate(delay: (500 + i * 80).ms).fadeIn(duration: 400.ms),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkillBar extends StatefulWidget {
  final String label;
  final double value;
  final Color color;

  const _SkillBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${(widget.value * 100).toInt()}%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                color: widget.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(3),
          ),
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _anim.value * widget.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: LinearGradient(
                    colors: [widget.color, widget.color.withOpacity(0.5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.5),
                      blurRadius: 8,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}