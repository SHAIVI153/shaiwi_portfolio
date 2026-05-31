import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaiwi_portfolio/screens/responsive_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/anime_character.dart';

class ContactScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const ContactScreen({super.key, this.scrollController});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _name  = TextEditingController();
  final _email = TextEditingController();
  final _msg   = TextEditingController();
  bool _sent   = false;

  @override
  void dispose() {
    _name.dispose(); _email.dispose(); _msg.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _submit() {
    if (_name.text.isNotEmpty && _email.text.isNotEmpty) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      return CustomScrollView(
        controller: widget.scrollController,
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

                // ── Content
                r.sideBySide
                    ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4,
                          child: _SocialLinks(r: r, launch: _launch)),
                      SizedBox(width: r.sp(32)),
                      Expanded(flex: 6,
                          child: _sent
                              ? _Thanks(r: r)
                              : _Form(r: r,
                              name: _name, email: _email,
                              msg: _msg, onSubmit: _submit)),
                    ])
                    : Column(children: [
                  _SocialLinks(r: r, launch: _launch),
                  SizedBox(height: r.sp(28)),
                  _sent
                      ? _Thanks(r: r)
                      : _Form(r: r,
                      name: _name, email: _email,
                      msg: _msg, onSubmit: _submit),
                ]),

                // ── Footer spacer
                SizedBox(height: r.sp(80)),
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
        tag: 'GET IN TOUCH',
        title: "Let's\nConnect",
        subtitle: 'Open to new projects and collaborations.',
        titleFs: r.sectionTitleFs,
      )),
      AnimeCharacter(section: 'contact', size: r.sp(190)),
    ])
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: SectionHeader(
        tag: 'GET IN TOUCH',
        title: "Let's\nConnect",
        subtitle: 'Open to new projects.',
        titleFs: r.sectionTitleFs,
      )),
      SizedBox(width: r.sp(12)),
      AnimeCharacter(section: 'contact', size: r.sp(110)),
    ]);
  }
}

// ── Social Links ──────────────────────────────────────────────────────────────
class _SocialLinks extends StatelessWidget {
  final Rsp r;
  final Future<void> Function(String) launch;
  const _SocialLinks({required this.r, required this.launch});

  @override
  Widget build(BuildContext context) {
    final links = [
      {'icon': Icons.email_outlined,        'label': 'Email',
        'val': PortfolioData.email,          'c': AppColors.primary,
        'url': 'mailto:${PortfolioData.email}'},
      {'icon': Icons.code,                  'label': 'GitHub',
        'val': 'SHAIVI153',                  'c': AppColors.textPrimary,
        'url': PortfolioData.github},
      {'icon': Icons.camera_alt_outlined,   'label': 'Instagram',
        'val': 'shawaiz._.niamat',           'c': const Color(0xFFE1306C),
        'url': PortfolioData.instagram},
      {'icon': Icons.business_center_outlined, 'label': 'LinkedIn',
        'val': 'Shawaiz Niamat',             'c': const Color(0xFF0077B5),
        'url': PortfolioData.linkedin},
    ];

    return Column(
      children: links.asMap().entries.map((e) {
        final i = e.key;
        final lk = e.value;
        final c = lk['c'] as Color;
        return Padding(
          padding: EdgeInsets.only(bottom: r.sp(12)),
          child: GestureDetector(
            onTap: () => launch(lk['url'] as String),
            child: NeonCard(
              glowColor: c,
              padding: EdgeInsets.all(r.sp(16)),
              child: Row(children: [
                Container(
                  width: r.sp(42), height: r.sp(42),
                  decoration: BoxDecoration(
                    color: c.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.withOpacity(0.3)),
                  ),
                  child: Icon(lk['icon'] as IconData,
                      color: c, size: r.sp(18)),
                ),
                SizedBox(width: r.sp(14)),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lk['label'] as String,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: r.fs(10.5), fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary, letterSpacing: 0.8,
                      ),
                    ),
                    Text(lk['val'] as String,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: r.fs(13.5), fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: c.withOpacity(0.4), size: r.sp(12)),
              ]),
            ),
          )
              .animate(delay: (i * 90).ms)
              .fadeIn(duration: 380.ms)
              .slideX(begin: -0.08, curve: Curves.easeOutCubic),
        );
      }).toList(),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────
class _Form extends StatelessWidget {
  final Rsp r;
  final TextEditingController name, email, msg;
  final VoidCallback onSubmit;
  const _Form({required this.r, required this.name,
    required this.email, required this.msg, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.sp(28)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Send a Message',
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(18), fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: r.sp(22)),
        _field('Your Name',      name,  Icons.person_outline,   r),
        SizedBox(height: r.sp(14)),
        _field('Email Address',  email, Icons.email_outlined,   r,
            type: TextInputType.emailAddress),
        SizedBox(height: r.sp(14)),
        _field('Your Message',   msg,   Icons.message_outlined, r,
            maxLines: 4),
        SizedBox(height: r.sp(20)),
        SizedBox(
          width: double.infinity,
          child: GlowButton(
            label: 'SEND MESSAGE', onTap: onSubmit,
            color: AppColors.primary, fontSize: r.fs(12),
          ),
        ),
      ]),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.06, curve: Curves.easeOutCubic);
  }

  Widget _field(String hint, TextEditingController ctrl, IconData icon, Rsp r,
      {int maxLines = 1, TextInputType? type}) {
    return TextField(
      controller: ctrl, maxLines: maxLines, keyboardType: type,
      style: GoogleFonts.spaceGrotesk(
          fontSize: r.fs(13.5), color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.spaceGrotesk(
            color: AppColors.textSecondary.withOpacity(0.45),
            fontSize: r.fs(13.5)),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppColors.textSecondary.withOpacity(0.45),
            size: r.sp(18))
            : null,
        filled: true, fillColor: AppColors.surface,
        contentPadding: EdgeInsets.all(r.sp(14)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: AppColors.primary, width: 1.5)),
      ),
    );
  }
}

// ── Thanks ────────────────────────────────────────────────────────────────────
class _Thanks extends StatelessWidget {
  final Rsp r;
  const _Thanks({required this.r});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.sp(40)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        boxShadow: [BoxShadow(
            color: AppColors.accent.withOpacity(0.08), blurRadius: 28)],
      ),
      child: Column(children: [
        Container(
          width: r.sp(64), height: r.sp(64),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent.withOpacity(0.4)),
          ),
          child: Icon(Icons.check_rounded,
              color: AppColors.accent, size: r.sp(30)),
        ),
        SizedBox(height: r.sp(20)),
        Text('Message Sent!',
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(22), fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: r.sp(8)),
        Text("I'll get back to you within 24 hours.",
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: r.fs(13.5),
            color: AppColors.textSecondary, height: 1.65,
          ),
        ),
      ]),
    )
        .animate().fadeIn(duration: 450.ms)
        .scale(begin: const Offset(0.92, 0.92),
        curve: Curves.easeOutBack);
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────
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