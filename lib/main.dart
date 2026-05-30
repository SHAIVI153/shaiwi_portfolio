import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaiwi_portfolio/screens/responsive_screen.dart';
import 'package:shaiwi_portfolio/widgets/app_theme.dart';
import 'widgets/common_widgets.dart';
import 'screens/home_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/services_screen.dart';
import 'screens/cv_screen.dart';
import 'screens/contact_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Allow portrait + landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Status bar transparent
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
    );
  }
}

// ─── Nav data ─────────────────────────────────────────────────────────────────
class _N {
  final String label;
  final IconData icon;
  final IconData iconOn;
  const _N(this.label, this.icon, this.iconOn);
}
const _nav = [
  _N('Home',     Icons.home_outlined,           Icons.home_rounded),
  _N('Skills',   Icons.code_outlined,            Icons.code_rounded),
  _N('Projects', Icons.work_outline,             Icons.work_rounded),
  _N('Services', Icons.design_services_outlined, Icons.design_services_rounded),
  _N('CV',       Icons.download_outlined,        Icons.download_rounded),
  _N('Contact',  Icons.mail_outline,             Icons.mail_rounded),
];

// ─── Shell ────────────────────────────────────────────────────────────────────
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _i = 0;
  void _go(int i) => setState(() => _i = i);

  Widget _page() {
    switch (_i) {
      case 0: return HomeScreen(
          onContactTap: () => _go(5), onProjectsTap: () => _go(2));
      case 1: return const SkillsScreen();
      case 2: return const ProjectsScreen();
      case 3: return ServicesScreen(onHireTap: () => _go(5));
      case 4: return const CVScreen();
      case 5: return const ContactScreen();
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (ctx, r) {
      return Scaffold(
        backgroundColor: const Color(0xFF050A0F),
        body: Column(children: [
          // ── Top nav: tablet + desktop only
          if (!r.isMobile) _TopNav(idx: _i, go: _go, r: r),

          // ── Page
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.025),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: anim, curve: Curves.easeOutCubic)),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                  key: ValueKey(_i), child: _page()),
            ),
          ),

          // ── Bottom nav: mobile only
          if (r.isMobile) _BottomNav(idx: _i, go: _go, r: r),
        ]),
      );
    });
  }
}

// ─── Top Nav ──────────────────────────────────────────────────────────────────
class _TopNav extends StatelessWidget {
  final int idx;
  final void Function(int) go;
  final Rsp r;
  const _TopNav({required this.idx, required this.go, required this.r});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF050A0F).withOpacity(0.94),
      child: Container(
        height: 62,
        padding: EdgeInsets.symmetric(horizontal: r.hPad),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF1A2D45), width: 1),
          ),
        ),
        child: Row(children: [
          // Logo
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF7B2FFF)],
            ).createShader(b),
            child: Text('shaiwi_code',
              style: GoogleFonts.spaceGrotesk(
                fontSize: r.fs(21),
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Spacer(),
          // Links
          ..._nav.asMap().entries.map((e) {
            final active = idx == e.key;
            final c = active
                ? const Color(0xFF00D4FF)
                : const Color(0xFF8899BB);
            return GestureDetector(
              onTap: () => go(e.key),
              child: Container(
                margin: EdgeInsets.only(left: r.sp(26)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(e.value.label,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: r.fs(13),
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: c,
                      ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 2, width: active ? 16 : 0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4FF),
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [BoxShadow(
                            color: const Color(0xFF00D4FF).withOpacity(0.7),
                            blurRadius: 6)],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }
}

// ─── Bottom Nav (mobile) ──────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int idx;
  final void Function(int) go;
  final Rsp r;
  const _BottomNav({required this.idx, required this.go, required this.r});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0D1520),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF1A2D45), width: 1),
          ),
          boxShadow: [BoxShadow(
              color: Colors.black38, blurRadius: 20, offset: Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 58,
            child: Row(
              children: _nav.asMap().entries.map((e) {
                final i = e.key;
                final active = idx == i;
                final c = active
                    ? const Color(0xFF00D4FF)
                    : const Color(0xFF8899BB);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => go(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 5),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF00D4FF).withOpacity(0.1)
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