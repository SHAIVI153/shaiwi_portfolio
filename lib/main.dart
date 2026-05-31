import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaiwi_portfolio/screens/contact_screen.dart';
import 'package:shaiwi_portfolio/screens/cv_screen.dart';
import 'package:shaiwi_portfolio/screens/home_screen.dart';
import 'package:shaiwi_portfolio/screens/projects_screen.dart';
import 'package:shaiwi_portfolio/screens/responsive_screen.dart';
import 'package:shaiwi_portfolio/screens/services_screen.dart';
import 'package:shaiwi_portfolio/screens/skills_screen.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF050A0F),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shaiwi_code | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const Shell(),
      scrollBehavior: const _WebScrollBehavior(),
    );
  }
}

// Enable mouse + touch + trackpad scroll on web
class _WebScrollBehavior extends ScrollBehavior {
  const _WebScrollBehavior();
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

// ─── Nav data ──────────────────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final IconData icon;
  final IconData iconOn;
  const _NavItem(this.label, this.icon, this.iconOn);
}

const _navItems = [
  _NavItem('Home',     Icons.home_outlined,           Icons.home_rounded),
  _NavItem('Skills',   Icons.code_outlined,            Icons.code_rounded),
  _NavItem('Projects', Icons.work_outline,             Icons.work_rounded),
  _NavItem('Services', Icons.design_services_outlined, Icons.design_services_rounded),
  _NavItem('CV',       Icons.download_outlined,        Icons.download_rounded),
  _NavItem('Contact',  Icons.mail_outline,             Icons.mail_rounded),
];

// ─── Shell ─────────────────────────────────────────────────────────────────────
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _idx = 0;
  final List<ScrollController> _scrollCtrls =
  List.generate(6, (_) => ScrollController());

  @override
  void dispose() {
    for (final c in _scrollCtrls) c.dispose();
    super.dispose();
  }

  void _go(int i) {
    // Close drawer if open
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();

    if (_idx == i) {
      final ctrl = _scrollCtrls[i];
      if (ctrl.hasClients && ctrl.offset > 0) {
        ctrl.animateTo(0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic);
      }
    } else {
      setState(() => _idx = i);
    }
  }

  Widget _buildPage(int i) {
    final sc = _scrollCtrls[i];
    switch (i) {
      case 0: return HomeScreen(
          scrollController: sc,
          onContactTap: () => _go(5),
          onProjectsTap: () => _go(2));
      case 1: return SkillsScreen(scrollController: sc);
      case 2: return ProjectsScreen(scrollController: sc);
      case 3: return ServicesScreen(scrollController: sc, onHireTap: () => _go(5));
      case 4: return CVScreen(scrollController: sc);
      case 5: return ContactScreen(scrollController: sc);
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      return Scaffold(
        backgroundColor: AppColors.background,
        drawer: r.isMobile ? _NavDrawer(idx: _idx, go: _go) : null,
        body: SafeArea(
          bottom: false,
          child: Column(children: [
            // Top bar
            r.isMobile
                ? _MobileTopBar(idx: _idx)
                : _TopNav(idx: _idx, go: _go, r: r),

            // Page
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: CurvedAnimation(
                      parent: anim, curve: Curves.easeOut),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.02),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: anim, curve: Curves.easeOutCubic)),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                    key: ValueKey(_idx), child: _buildPage(_idx)),
              ),
            ),

            // Bottom nav (mobile)
            if (r.isMobile) _BottomNav(idx: _idx, go: _go),
          ]),
        ),
      );
    });
  }
}

// ─── Mobile top bar ────────────────────────────────────────────────────────────
class _MobileTopBar extends StatelessWidget {
  final int idx;
  const _MobileTopBar({required this.idx});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(children: [
          // Hamburger
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
          // Logo
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ).createShader(b),
            child: Text('shaiwi_code',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 17, fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Spacer(),
          // Active pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Text(_navItems[idx].label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10, fontWeight: FontWeight.w700,
                color: AppColors.primary, letterSpacing: 0.5,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Drawer ────────────────────────────────────────────────────────────────────
class _NavDrawer extends StatelessWidget {
  final int idx;
  final void Function(int) go;
  const _NavDrawer({required this.idx, required this.go});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      width: 272,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 52, 22, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ).createShader(b),
                  child: Text('shaiwi_code',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22, fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
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
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                        color: AppColors.accent, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text('Available for work',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11, color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Divider(color: AppColors.border, height: 1),
          ),
          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: _navItems.asMap().entries.map((e) {
                final active = idx == e.key;
                return GestureDetector(
                  onTap: () => go(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
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
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(children: [
                      Icon(
                        active ? e.value.iconOn : e.value.icon,
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 19,
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(e.value.label,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: active
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
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
        ],
      ),
    );
  }
}

// ─── Top Nav (tablet + desktop) ────────────────────────────────────────────────
class _TopNav extends StatelessWidget {
  final int idx;
  final void Function(int) go;
  final Rsp r;
  const _TopNav({required this.idx, required this.go, required this.r});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background.withOpacity(0.96),
      child: Container(
        height: 64,
        padding: EdgeInsets.symmetric(horizontal: r.hPad),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ).createShader(b),
            child: Text('shaiwi_code',
              style: GoogleFonts.spaceGrotesk(
                fontSize: r.fs(21), fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Spacer(),
          ..._navItems.asMap().entries.map((e) {
            final active = idx == e.key;
            final c = active ? AppColors.primary : AppColors.textSecondary;
            return GestureDetector(
              onTap: () => go(e.key),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  margin: EdgeInsets.only(left: r.sp(28)),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.value.label,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: r.fs(13),
                          fontWeight:
                          active ? FontWeight.w700 : FontWeight.w500,
                          color: c,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2, width: active ? 18 : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: active
                              ? [BoxShadow(
                              color: AppColors.primary.withOpacity(0.8),
                              blurRadius: 8)]
                              : [],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }
}

// ─── Bottom Nav ────────────────────────────────────────────────────────────────
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
          border: Border(
              top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [BoxShadow(
              color: Colors.black54, blurRadius: 24,
              offset: Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: _navItems.asMap().entries.map((e) {
                final i = e.key;
                final active = idx == i;
                final c = active
                    ? AppColors.primary
                    : AppColors.textSecondary;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => go(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
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
                          Icon(
                            active ? e.value.iconOn : e.value.icon,
                            size: 20, color: c,
                          ),
                          const SizedBox(height: 2),
                          Text(e.value.label,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: c,
                            ),
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