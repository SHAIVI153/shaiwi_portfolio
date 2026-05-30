import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaiwi_portfolio/screens/responsive_screen.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';
import '../widgets/anime_character.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});
  @override State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  int _sel = 0;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override void dispose() { _focus.dispose(); super.dispose(); }

  void _onKey(KeyEvent e) {
    if (e is! KeyDownEvent) return;
    final n = PortfolioData.skills.length;
    if (e.logicalKey == LogicalKeyboardKey.arrowRight ||
        e.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() => _sel = (_sel + 1) % n);
    } else if (e.logicalKey == LogicalKeyboardKey.arrowLeft ||
        e.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() => _sel = (_sel - 1 + n) % n);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focus,
      onKeyEvent: _onKey,
      child: ResponsiveBuilder(builder: (ctx, r) {
        return Stack(children: [
          Positioned(top: 60, right: -160,
              child: Container(width: 420, height: 420,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.secondary.withOpacity(0.06),
                        Colors.transparent])))),

          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: r.hPad, vertical: r.vPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row: title + anime char
                  _buildHeader(r),
                  SizedBox(height: r.sp(36)),

                  // ── Keyboard hint
                  _KeyHint(r: r),
                  SizedBox(height: r.sp(20)),

                  // ── Category tabs
                  _buildTabs(r),
                  SizedBox(height: r.sp(24)),

                  // ── Detail card (animated switch)
                  _DetailCard(skill: PortfolioData.skills[_sel], idx: _sel, r: r),
                  SizedBox(height: r.sp(36)),

                  // ── Grid of all skills
                  _buildGrid(r),
                  SizedBox(height: r.sp(20)),
                ],
              ),
            ),
          ),
        ]);
      }),
    );
  }

  Widget _buildHeader(Rsp r) {
    return r.sideBySide
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: SectionHeader(
        tag: 'EXPERTISE',
        title: 'Skills &\nTechnologies',
        subtitle: 'Flutter-first. Arrow keys ← → to navigate skills.',
        titleFs: r.sectionTitleFs,
      )),
      const SizedBox(width: 24),
      AnimeCharacter(section: 'skills', size: r.sp(180)),
    ])
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: AnimeCharacter(section: 'skills', size: r.sp(150))),
      SizedBox(height: r.sp(20)),
      SectionHeader(
        tag: 'EXPERTISE',
        title: 'Skills &\nTech',
        subtitle: 'Flutter-first. Tap a card to explore.',
        titleFs: r.sectionTitleFs,
      ),
    ]);
  }

  Widget _buildTabs(Rsp r) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: PortfolioData.skills.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final sk = PortfolioData.skills[i];
          final c = Color(sk['color'] as int);
          final active = i == _sel;
          return GestureDetector(
            onTap: () => setState(() => _sel = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(
                  horizontal: r.sp(16), vertical: 10),
              decoration: BoxDecoration(
                color: active ? c.withOpacity(0.14) : AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: active ? c : AppColors.border,
                    width: active ? 1.5 : 1),
                boxShadow: active ? [BoxShadow(
                    color: c.withOpacity(0.22), blurRadius: 14)] : [],
              ),
              child: Row(children: [
                Text(sk['icon'] as String,
                    style: TextStyle(fontSize: r.fs(15))),
                const SizedBox(width: 8),
                Text(
                  (sk['category'] as String).split(' ').first,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: r.fs(12.5),
                    fontWeight: FontWeight.w700,
                    color: active ? c : AppColors.textSecondary,
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(Rsp r) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: r.grid2(),
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: r.isMobile ? 1.45 : 1.25,
      ),
      itemCount: PortfolioData.skills.length,
      itemBuilder: (_, i) {
        final sk = PortfolioData.skills[i];
        final c = Color(sk['color'] as int);
        final active = i == _sel;
        return GestureDetector(
          onTap: () => setState(() => _sel = i),
          child: TiltCard(
            maxTilt: r.isMobile ? 3 : 7,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.all(r.sp(20)),
              decoration: BoxDecoration(
                color: active ? c.withOpacity(0.06) : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: active ? c.withOpacity(0.5) : AppColors.border,
                    width: active ? 1.5 : 1),
                boxShadow: active ? [BoxShadow(
                    color: c.withOpacity(0.14), blurRadius: 22)] : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: r.sp(40), height: r.sp(40),
                      decoration: BoxDecoration(
                        color: c.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.withOpacity(0.28)),
                      ),
                      child: Center(child: Text(sk['icon'] as String,
                          style: TextStyle(fontSize: r.fs(18)))),
                    ),
                    SizedBox(width: r.sp(12)),
                    Expanded(child: Text(sk['category'] as String,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: r.fs(13.5),
                        fontWeight: FontWeight.w700,
                        color: active ? c : AppColors.textPrimary,
                      ),
                    )),
                    if (active) Container(width: 7, height: 7,
                        decoration: BoxDecoration(color: c,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                                color: c.withOpacity(0.6), blurRadius: 6)])),
                  ]),
                  SizedBox(height: r.sp(12)),
                  _Bar(v: (sk['proficiency'] as double? ?? 0.8), c: c, h: 4.5),
                  SizedBox(height: r.sp(12)),
                  Wrap(spacing: 5, runSpacing: 5,
                    children: (sk['items'] as List<String>)
                        .take(r.isMobile ? 3 : 4)
                        .map((item) => SkillTag(
                        label: item, color: c.value,
                        fontSize: r.fs(11)))
                        .toList(),
                  ),
                ],
              ),
            ),
          )
              .animate(delay: (i * 90).ms)
              .fadeIn(duration: 380.ms)
              .slideY(begin: 0.12, curve: Curves.easeOutCubic),
        );
      },
    );
  }
}

// ─── Detail card with animated switcher ──────────────────────────────────────
class _DetailCard extends StatelessWidget {
  final Map<String, dynamic> skill;
  final int idx;
  final Rsp r;
  const _DetailCard({required this.skill, required this.idx, required this.r});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
              begin: const Offset(0.04, 0), end: Offset.zero)
              .animate(CurvedAnimation(
              parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(idx),
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    final c = Color(skill['color'] as int);
    final items = skill['items'] as List<String>;
    final prof = skill['proficiency'] as double? ?? 0.8;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.sp(28)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.withOpacity(0.35), width: 1.5),
        boxShadow: [BoxShadow(color: c.withOpacity(0.11), blurRadius: 28)],
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [c.withOpacity(0.05), AppColors.card]),
      ),
      child: r.sideBySide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _leftCol(c, items, prof, r)),
        SizedBox(width: r.sp(24)),
        _CircleProfi(v: prof, c: c, size: r.sp(80)),
      ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _titleSection(c, prof, r),
              _CircleProfi(v: prof, c: c, size: r.sp(64)),
            ]),
        SizedBox(height: r.sp(14)),
        _Bar(v: prof, c: c, h: 6),
        SizedBox(height: r.sp(16)),
        Wrap(spacing: 8, runSpacing: 8,
            children: items.map((it) =>
                SkillTag(label: it, color: c.value,
                    fontSize: r.fs(12))).toList()),
      ]),
    );
  }

  Widget _leftCol(Color c, List<String> items, double prof, Rsp r) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _titleSection(c, prof, r),
      SizedBox(height: r.sp(14)),
      _Bar(v: prof, c: c, h: 6),
      SizedBox(height: r.sp(18)),
      Wrap(spacing: 8, runSpacing: 8,
          children: items.map((it) =>
              SkillTag(label: it, color: c.value,
                  fontSize: r.fs(12))).toList()),
    ]);
  }

  Widget _titleSection(Color c, double prof, Rsp r) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(skill['icon'] as String,
          style: TextStyle(fontSize: r.fs(32))),
      SizedBox(height: r.sp(8)),
      Text(skill['category'] as String,
        style: GoogleFonts.spaceGrotesk(
          fontSize: r.fs(20),
          fontWeight: FontWeight.w800,
          color: c, letterSpacing: -0.4,
        ),
      ),
      SizedBox(height: r.sp(3)),
      Text('${(prof * 100).toInt()}% proficiency',
          style: GoogleFonts.jetBrainsMono(
              fontSize: r.fs(11), color: AppColors.textSecondary)),
    ]);
  }
}

// ─── Animated progress bar ────────────────────────────────────────────────────
class _Bar extends StatefulWidget {
  final double v;
  final Color c;
  final double h;
  const _Bar({required this.v, required this.c, required this.h});
  @override State<_Bar> createState() => _BarState();
}
class _BarState extends State<_Bar> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }
  @override void didUpdateWidget(_Bar old) {
    super.didUpdateWidget(old);
    if (old.v != widget.v) _ctrl.forward(from: 0);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.h,
      decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(widget.h / 2)),
      child: AnimatedBuilder(animation: _anim,
        builder: (_, __) => FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: _anim.value * widget.v,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.h / 2),
              gradient: LinearGradient(colors: [
                widget.c, widget.c.withOpacity(0.5)]),
              boxShadow: [BoxShadow(
                  color: widget.c.withOpacity(0.5), blurRadius: 7)],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleProfi extends StatelessWidget {
  final double v;
  final Color c;
  final double size;
  const _CircleProfi({required this.v, required this.c, required this.size});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size,
      child: Stack(alignment: Alignment.center, children: [
        CircularProgressIndicator(value: v,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(c),
            strokeWidth: 4),
        Text('${(v * 100).toInt()}%',
            style: GoogleFonts.jetBrainsMono(
                fontSize: size * 0.16, fontWeight: FontWeight.w700, color: c)),
      ]),
    );
  }
}

class _KeyHint extends StatelessWidget {
  final Rsp r;
  const _KeyHint({required this.r});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _Key('←', r), const SizedBox(width: 6),
      _Key('→', r), const SizedBox(width: 10),
      Text('Arrow keys to navigate',
          style: GoogleFonts.spaceGrotesk(
              fontSize: r.fs(12), color: AppColors.textSecondary)),
    ]);
  }
}

class _Key extends StatelessWidget {
  final String l;
  final Rsp r;
  const _Key(this.l, this.r);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(
            color: Colors.black26, offset: Offset(0, 2), blurRadius: 2)],
      ),
      child: Text(l,
          style: GoogleFonts.jetBrainsMono(
              fontSize: r.fs(12), color: AppColors.textPrimary,
              fontWeight: FontWeight.w700)),
    );
  }
}