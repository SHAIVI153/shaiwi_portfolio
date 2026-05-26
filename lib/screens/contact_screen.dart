import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.isNotEmpty && _emailCtrl.text.isNotEmpty) {
      setState(() => _submitted = true);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
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
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 80,
            vertical: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                tag: 'GET IN TOUCH',
                title: 'Let\'s\nConnect',
                subtitle:
                'Have a project, a question, or just want to say hi? My inbox is always open.',
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOutCubic),

              const SizedBox(height: 56),

              isMobile
                  ? Column(
                children: [
                  _buildSocialLinks(),
                  const SizedBox(height: 40),
                  _buildContactForm(),
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: _buildSocialLinks()),
                  const SizedBox(width: 40),
                  Expanded(flex: 6, child: _buildContactForm()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinks() {
    final links = [
      {
        'icon': Icons.email_outlined,
        'label': 'Email',
        'value': PortfolioData.email,
        'color': AppColors.primary,
        'url': 'mailto:${PortfolioData.email}',
      },
      {
        'icon': Icons.code,
        'label': 'GitHub',
        'value': '@shaiwi_code',
        'color': AppColors.secondary,
        'url': PortfolioData.github,
      },
      {
        'icon': Icons.business_center_outlined,
        'label': 'LinkedIn',
        'value': 'Shawaiz Niamat',
        'color': AppColors.primary,
        'url': PortfolioData.linkedin,
      },
      {
        'icon': Icons.camera_alt_outlined,
        'label': 'Instagram',
        'value': '@shaiwi_code',
        'color': AppColors.accent,
        'url': PortfolioData.instagram,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: links.asMap().entries.map((entry) {
        final i = entry.key;
        final link = entry.value;
        final color = link['color'] as Color;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _launchUrl(link['url'] as String),
            child: NeonCard(
              glowColor: color,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Icon(
                      link['icon'] as IconData,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        link['label'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        link['value'] as String,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      color: color.withOpacity(0.5), size: 14),
                ],
              ),
            ),
          )
              .animate(delay: (i * 100).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, curve: Curves.easeOutCubic),
        );
      }).toList(),
    );
  }

  Widget _buildContactForm() {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.1),
              blurRadius: 30,
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.accent, size: 36),
            ),
            const SizedBox(height: 24),
            Text(
              'Message Sent!',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Thanks for reaching out. I'll get back to you within 24 hours.",
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).scale(
        begin: const Offset(0.9, 0.9),
        curve: Curves.easeOutBack,
      );
    }

    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send a Message',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 28),
          _buildTextField('Your Name', _nameCtrl, Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField('Email Address', _emailCtrl, Icons.email_outlined,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _buildTextField('Your Message', _msgCtrl, Icons.message_outlined,
              maxLines: 5),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: GlowButton(
              label: 'SEND MESSAGE',
              onTap: _submit,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.1, curve: Curves.easeOutCubic);
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller,
      IconData icon, {
        int maxLines = 1,
        TextInputType? keyboardType,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textSecondary.withOpacity(0.5),
          fontSize: 15,
        ),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppColors.textSecondary.withOpacity(0.5), size: 20)
            : null,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}