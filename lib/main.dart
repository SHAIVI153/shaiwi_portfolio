// ═══════════════════════════════════════════════════════════════════════════════
//  main.dart  — Professional Webflow-style Scroll Portfolio
//
//  Architecture:
//  • ONE continuous CustomScrollView — all 6 sections stacked vertically
//  • Parallax layers (SliverParallax via Transform + ScrollController)
//  • Scroll-driven nav highlight (detects which section is in viewport)
//  • Sticky navbar via SliverPersistentHeader
//  • Scroll-reveal animations per section (flutter_animate + visibility check)
//  • Smooth scrollTo() on nav tap
//  • Mouse-wheel / trackpad / touch on web+mobile
//  • Drawer on mobile, top sticky nav on tablet/desktop
//  • No pixel rendering (FilterQuality.high everywhere)
// ═══════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/app_theme.dart';
import 'widgets/common_widgets.dart';
import 'widgets/preloader.dart';
import 'widgets/about_section.dart';
import 'widgets/expertise_section.dart';
import 'widgets/certifications_section.dart';
import 'screens/responsive_screen.dart';
import 'screens/home_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/services_screen.dart';
import 'screens/cv_screen.dart';
import 'screens/contact_screen.dart';

// ─── Entry ────────────────────────────────────────────────────────────────────
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:                    Colors.transparent,
    statusBarIconBrightness:           Brightness.light,
    systemNavigationBarColor:          Color(0xFF050A0F),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                     'shaiwi_code | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme:                     AppTheme.dark,
      home:                      const AppPreloader(child: Shell()),
      scrollBehavior:            _AllDeviceScrollBehavior(),
    );
  }
}

/// Enables mouse + touch + trackpad scrolling on all platforms
class _AllDeviceScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}

// ─── Nav config ───────────────────────────────────────────────────────────────
class _N {
  final String  label;
  final IconData icon, iconOn;
  const _N(this.label, this.icon, this.iconOn);
}
const _nav = [
  _N('Home',      Icons.home_outlined,            Icons.home_rounded),
  _N('About',     Icons.person_outline,           Icons.person_rounded),
  _N('Expertise', Icons.auto_awesome_outlined,    Icons.auto_awesome_rounded),
  _N('Skills',    Icons.code_outlined,            Icons.code_rounded),
  _N('Projects',  Icons.work_outline,             Icons.work_rounded),
  _N('Services',  Icons.design_services_outlined, Icons.design_services_rounded),
  _N('CV',        Icons.download_outlined,        Icons.download_rounded),
  _N('Certs',     Icons.workspace_premium_outlined, Icons.workspace_premium_rounded),
  _N('Contact',   Icons.mail_outline,              Icons.mail_rounded),
];

// ─── Shell ─────────────────────────────────────────────────────────────────────
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  // Single scroll controller for the entire page
  final ScrollController _scroll = ScrollController();

  // One GlobalKey per section so we can measure offsets
  final List<GlobalKey> _keys = List.generate(9, (_) => GlobalKey());

  // Currently active nav index (updated by scroll listener)
  int _activeIdx = 0;

  // Navbar height (set after first build via ResponsiveBuilder)
  double _navH = 64;

  // Parallax offset (driven by _scroll)
  double _scrollY = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  // ── Scroll listener: update active nav + parallax value ────────────────────
  void _onScroll() {
    final offset = _scroll.offset;
    setState(() => _scrollY = offset);

    // Find which section occupies the centre of the viewport
    final viewH     = _scroll.position.viewportDimension;
    final centre    = offset + viewH * 0.38; // 38 % from top = natural focus

    for (int i = _keys.length - 1; i >= 0; i--) {
      final ctx = _keys[i].currentContext;
      if (ctx == null) continue;
      final box    = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final topAbs = box.localToGlobal(Offset.zero).dy + offset - _navH;
      if (centre >= topAbs) {
        if (_activeIdx != i) setState(() => _activeIdx = i);
        break;
      }
    }
  }

  // ── Scroll to section ───────────────────────────────────────────────────────
  void _scrollTo(int idx) {
    final ctx = _keys[idx].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration:  const Duration(milliseconds: 780),
      curve:     Curves.easeInOutCubic,
      alignment: 0.0,           // top-align (parallax header shows fully)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      _navH = r.isMobile ? 52 : 64;

      return Scaffold(
        backgroundColor: AppColors.background,
        drawer: r.isMobile
            ? _NavDrawer(idx: _activeIdx, go: _scrollTo)
            : null,
        body: SafeArea(
          bottom: false,
          child: Column(children: [

            // ── Sticky navbar
            r.isMobile
                ? _MobileTopBar(idx: _activeIdx, go: _scrollTo)
                : _StickyTopNav(idx: _activeIdx, go: _scrollTo, r: r),

            // ── Single scrollable canvas
            Expanded(
              child: _ScrollCanvas(
                scrollCtrl: _scroll,
                scrollY:    _scrollY,
                sectionKeys: _keys,
                activeIdx:  _activeIdx,
                onHireTap:  () => _scrollTo(8),
                onContactTap: () => _scrollTo(8),
                onProjectsTap: () => _scrollTo(4),
              ),
            ),

            // ── No bottom nav — use drawer on mobile (hamburger top-left)
          ]),
        ),
      );
    });
  }
}

// ─── Single scroll canvas (all sections) ─────────────────────────────────────
class _ScrollCanvas extends StatelessWidget {
  final ScrollController scrollCtrl;
  final double           scrollY;
  final List<GlobalKey>  sectionKeys;
  final int              activeIdx;
  final VoidCallback     onHireTap;
  final VoidCallback     onContactTap;
  final VoidCallback     onProjectsTap;

  const _ScrollCanvas({
    required this.scrollCtrl,
    required this.scrollY,
    required this.sectionKeys,
    required this.activeIdx,
    required this.onHireTap,
    required this.onContactTap,
    required this.onProjectsTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()),
      slivers: [

        // ─ 0. HOME ─────────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[0],
          scrollY:    scrollY,
          parallaxDepth: 0.35,
          glowColor:  AppColors.primary,
          child: HomeScreen(
            onContactTap:  onContactTap,
            onProjectsTap: onProjectsTap,
          ),
        ),

        // ─ Divider
        _SectionDivider(color: AppColors.primary),

        // ─ 1. ABOUT ────────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[1],
          scrollY:    scrollY,
          parallaxDepth: 0.30,
          glowColor:  AppColors.secondary,
          child: const AboutSection(),
        ),

        _SectionDivider(color: AppColors.secondary),

        // ─ 2. EXPERTISE ────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[2],
          scrollY:    scrollY,
          parallaxDepth: 0.26,
          glowColor:  AppColors.accent,
          child: const ExpertiseSection(),
        ),

        _SectionDivider(color: AppColors.accent),

        // ─ 3. SKILLS ───────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[3],
          scrollY:    scrollY,
          parallaxDepth: 0.28,
          glowColor:  AppColors.secondary,
          child: const SkillsScreen(),
        ),

        _SectionDivider(color: AppColors.secondary),

        // ─ 4. PROJECTS ─────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[4],
          scrollY:    scrollY,
          parallaxDepth: 0.22,
          glowColor:  AppColors.accent,
          child: const ProjectsScreen(),
        ),

        _SectionDivider(color: AppColors.accent),

        // ─ 5. SERVICES ─────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[5],
          scrollY:    scrollY,
          parallaxDepth: 0.28,
          glowColor:  const Color(0xFFFF6B35),
          child: ServicesScreen(onHireTap: onHireTap),
        ),

        _SectionDivider(color: Color(0xFFFF6B35)),

        // ─ 6. CV ───────────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[6],
          scrollY:    scrollY,
          parallaxDepth: 0.22,
          glowColor:  AppColors.primary,
          child: const CVScreen(),
        ),

        _SectionDivider(color: AppColors.primary),

        // ─ 7. CERTIFICATIONS ───────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[7],
          scrollY:    scrollY,
          parallaxDepth: 0.24,
          glowColor:  AppColors.secondary,
          child: const CertificationsSection(),
        ),

        _SectionDivider(color: AppColors.secondary),

        // ─ 8. CONTACT ──────────────────────────────────────────────────────
        _SectionSliver(
          sectionKey: sectionKeys[8],
          scrollY:    scrollY,
          parallaxDepth: 0.18,
          glowColor:  AppColors.accent,
          child: const ContactScreen(),
        ),

        // ─ Footer
        SliverToBoxAdapter(child: _GlobalFooter()),
      ],
    );
  }
}

// ─── Section Sliver ───────────────────────────────────────────────────────────
/// Wraps each screen in a SliverToBoxAdapter.
/// Applies parallax to the background glow blob + scroll-reveal to content.
class _SectionSliver extends StatefulWidget {
  final GlobalKey   sectionKey;
  final Widget      child;
  final double      scrollY;
  final double      parallaxDepth;  // 0..1 — how much the bg moves
  final Color       glowColor;

  const _SectionSliver({
    required this.sectionKey,
    required this.child,
    required this.scrollY,
    required this.parallaxDepth,
    required this.glowColor,
  });

  @override
  State<_SectionSliver> createState() => _SectionSliverState();
}

class _SectionSliverState extends State<_SectionSliver>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;
  late AnimationController _revealCtrl;

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    // Check visibility on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didUpdateWidget(_SectionSliver old) {
    super.didUpdateWidget(old);
    if (!_revealed) _checkVisibility();
  }

  void _checkVisibility() {
    final ctx = widget.sectionKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final pos    = box.localToGlobal(Offset.zero);
    final screen = MediaQuery.of(context).size.height;
    if (pos.dy < screen * 1.1) {
      // Section is in or near viewport
      setState(() => _revealed = true);
      _revealCtrl.forward();
    }
  }

  // Parallax: the glow blob moves at parallaxDepth of the scroll speed
  double get _parallaxOffset => widget.scrollY * widget.parallaxDepth * 0.3;

  @override
  void dispose() {
    _revealCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        key: widget.sectionKey,
        constraints: const BoxConstraints(minHeight: 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Parallax background glow ──────────────────────────────────
            Positioned(
              top:  -120 + _parallaxOffset,
              right: -80,
              child: IgnorePointer(
                child: Container(
                  width: 500, height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      widget.glowColor.withOpacity(0.065),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
            ),
            // Parallax secondary glow (bottom-left)
            Positioned(
              bottom: -80 - _parallaxOffset * 0.5,
              left:   -60,
              child: IgnorePointer(
                child: Container(
                  width: 350, height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      widget.glowColor.withOpacity(0.04),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
            ),

            // ── Scroll-reveal content ─────────────────────────────────────
            _revealed
                ? widget.child
                .animate(controller: _revealCtrl)
                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                .slideY(
              begin: 0.06, end: 0,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            )
                : Opacity(opacity: 0, child: widget.child),
          ],
        ),
      ),
    );
  }
}

// ─── Section divider with gradient line ───────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  final Color color;
  const _SectionDivider({required this.color});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.transparent,
            color.withOpacity(0.35),
            color.withOpacity(0.35),
            Colors.transparent,
          ]),
        ),
      ),
    );
  }
}

// ─── Global footer ─────────────────────────────────────────────────────────────
class _GlobalFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(children: [
        const SizedBox(height: 36),
        // Logo
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary])
              .createShader(b),
          child: Text('shaiwi_code',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 26, fontWeight: FontWeight.w900,
                letterSpacing: -1),
          ),
        ),
        const SizedBox(height: 6),
        Text('Flutter & Web Developer',
          style: GoogleFonts.spaceGrotesk(
              fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),

        // WhatsApp contact row
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse('https://wa.me/923156434296');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF25D366).withOpacity(0.35)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.phone_rounded,
                    color: Color(0xFF25D366), size: 16),
                const SizedBox(width: 8),
                Text('+92 315 643 4296',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: Color(0xFF25D366),
                  ),
                ),
                const SizedBox(width: 6),
                Text('WhatsApp',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: Color(0xFF25D366).withOpacity(0.7),
                  ),
                ),
              ]),
            ),
          ),
        ),

        const SizedBox(height: 24),

        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(height: 1, color: AppColors.border),
        ),
        const SizedBox(height: 16),

        // Copyright
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text('© 2026 shaiwi_code · Made with ❤️ using Flutter',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                color: AppColors.textSecondary.withOpacity(0.6)),
          ),
        ),
        const SizedBox(height: 30),
      ]),
    );
  }
}

// ─── Sticky top nav (tablet + desktop) ────────────────────────────────────────
class _StickyTopNav extends StatelessWidget {
  final int  idx;
  final void Function(int) go;
  final Rsp  r;
  const _StickyTopNav({required this.idx, required this.go, required this.r});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background.withOpacity(0.94),
      child: Container(
        height: 64,
        padding: EdgeInsets.symmetric(horizontal: r.hPad),
        decoration: BoxDecoration(
          border: const Border(
              bottom: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          // Logo (wordmark) — fixed on the left
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (b) => const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary])
                .createShader(b),
            child: Text('shaiwi_code',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: r.fs(21), fontWeight: FontWeight.w900,
                  letterSpacing: -0.5),
            ),
          ),

          // Everything else (nav links + Hire Me + logo mark) lives in a
          // flexible, horizontally-scrollable region so it can NEVER overflow
          // the navbar — on narrower desktop/tablet widths it scrolls
          // instead of throwing a RenderFlex overflow error.
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              reverse: true, // keeps the right edge (Hire Me/icon) visible by default
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._nav.asMap().entries.map((e) {
                    final active = idx == e.key;
                    final c = active ? AppColors.primary : AppColors.textSecondary;
                    return GestureDetector(
                      onTap: () => go(e.key),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          margin: EdgeInsets.only(left: r.sp(22)),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(e.value.label,
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: r.fs(13),
                                  fontWeight: active
                                      ? FontWeight.w700 : FontWeight.w500,
                                  color: c),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: 220.ms,
                              height: 2, width: active ? 20 : 0,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(1),
                                boxShadow: active ? [BoxShadow(
                                    color: AppColors.primary.withOpacity(0.85),
                                    blurRadius: 10)] : [],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }),
                  SizedBox(width: r.sp(24)),
                  GlowButton(
                    label: 'HIRE ME',
                    onTap: () => go(8),
                    color: AppColors.primary,
                    fontSize: r.fs(11),
                  ),
                  SizedBox(width: r.sp(14)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset('assets/images/logo_mark.png',
                        width: r.fs(32), height: r.fs(32),
                        filterQuality: FilterQuality.high,
                        errorBuilder: (_, __, ___) => Container(
                          width: r.fs(32), height: r.fs(32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary]),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Mobile top bar ────────────────────────────────────────────────────────────
class _MobileTopBar extends StatelessWidget {
  final int idx;
  final void Function(int) go;
  const _MobileTopBar({required this.idx, required this.go});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: const Border(
              bottom: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4),
                blurRadius: 16, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          Builder(builder: (ctx) => GestureDetector(
            onTap: () => Scaffold.of(ctx).openDrawer(),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.menu_rounded,
                  color: AppColors.textPrimary, size: 19),
            ),
          )),
          const SizedBox(width: 10),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (b) => const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary])
                .createShader(b),
            child: Text('shaiwi_code',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 17, fontWeight: FontWeight.w900,
                  letterSpacing: -0.5),
            ),
          ),

          // Right-side cluster (active pill + Hire + SN icon) — wrapped in a
          // flexible, horizontally-scrollable region so it can NEVER overflow
          // on narrow phones, no matter how long the active section label is.
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated active section pill
                    AnimatedSwitcher(
                      duration: 200.ms,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(scale: anim, child: child),
                      ),
                      child: Container(
                        key: ValueKey(idx),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Text(_nav[idx].label,
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 10, fontWeight: FontWeight.w700,
                              color: AppColors.primary, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Compact Hire Me CTA (jumps straight to Contact section)
                    GestureDetector(
                      onTap: () => go(8),
                      child: Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary]),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 12)],
                        ),
                        child: const Icon(Icons.mail_rounded,
                            color: AppColors.background, size: 17),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset('assets/images/logo_mark.png',
                          width: 30, height: 30,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) => Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.secondary]),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Slide Drawer ──────────────────────────────────────────────────────────────
class _NavDrawer extends StatelessWidget {
  final int idx;
  final void Function(int) go;
  const _NavDrawer({required this.idx, required this.go});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      width: 272,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 52, 22, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary])
                      .createShader(b),
                  child: Text('shaiwi_code',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 22, fontWeight: FontWeight.w900,
                        letterSpacing: -0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text('Flutter & Web Developer',
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(
                        color: AppColors.accent, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text('Available for work',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 11, color: AppColors.accent,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
              ]),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Divider(color: AppColors.border, height: 1),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: _nav.asMap().entries.map((e) {
              final active = idx == e.key;
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  go(e.key);
                },
                child: AnimatedContainer(
                  duration: 180.ms,
                  margin: const EdgeInsets.only(bottom: 3),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: active
                            ? AppColors.primary.withOpacity(0.25)
                            : Colors.transparent),
                  ),
                  child: Row(children: [
                    Icon(active ? e.value.iconOn : e.value.icon,
                        color: active
                            ? AppColors.primary : AppColors.textSecondary,
                        size: 19),
                    const SizedBox(width: 13),
                    Expanded(child: Text(e.value.label,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: active
                              ? FontWeight.w700 : FontWeight.w500,
                          color: active
                              ? AppColors.primary : AppColors.textPrimary),
                    )),
                    if (active)
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle),
                      ),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text('© 2025 Shawaiz Niamat',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 11, color: AppColors.textSecondary),
          ),
        ),
      ]),
    );
  }
}

// ─── Bottom Nav (mobile) ───────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int idx;
  final void Function(int) go;
  const _BottomNav({required this.idx, required this.go});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [BoxShadow(
              color: Colors.black54, blurRadius: 24,
              offset: Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: _nav.asMap().entries.map((e) {
                final i = e.key;
                final active = idx == i;
                final c = active
                    ? AppColors.primary : AppColors.textSecondary;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => go(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: 200.ms,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 5),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(active ? e.value.iconOn : e.value.icon,
                              size: 20, color: c),
                          const SizedBox(height: 2),
                          Text(e.value.label,
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 9,
                                fontWeight: active
                                    ? FontWeight.w700 : FontWeight.w500,
                                color: c),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}