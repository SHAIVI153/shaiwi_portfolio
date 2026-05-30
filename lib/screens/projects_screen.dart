import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/portfolio_data.dart';
import '../widgets/tilt_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
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
          bottom: 0,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.accent.withOpacity(0.06),
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
                tag: 'PORTFOLIO',
                title: 'Featured\nProjects',
                subtitle:
                'Real-world apps and websites — tap any card to view code & screenshots.',
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOutCubic),

              const SizedBox(height: 56),

              ...PortfolioData.projects.asMap().entries.map((entry) {
                final i = entry.key;
                final project = entry.value;
                final color = Color(project['color'] as int);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: _ProjectCard(
                    project: project,
                    color: color,
                    isMobile: isMobile,
                    onLaunch: _launchUrl,
                  )
                      .animate(delay: (i * 150).ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.15, curve: Curves.easeOutCubic),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Project Card with expandable Code View + Image Gallery ──────────────────
class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final Color color;
  final bool isMobile;
  final Future<void> Function(String) onLaunch;

  const _ProjectCard({
    required this.project,
    required this.color,
    required this.isMobile,
    required this.onLaunch,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _showCode = false;
  bool _showImages = false;
  late AnimationController _expandCtrl;
  late Animation<double> _expandAnim;
  int _activeTab = 0; // 0=overview, 1=code, 2=images
  int _selectedImage = 0;
  bool _codeCopied = false;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  void _setTab(int tab) {
    setState(() => _activeTab = tab);
    if (tab == 0) {
      _expandCtrl.reverse();
    } else {
      _expandCtrl.forward();
    }
  }

  void _copyCode() {
    final code = widget.project['codeSnippet'] as String? ?? '';
    Clipboard.setData(ClipboardData(text: code));
    setState(() => _codeCopied = true);
    Future.delayed(const Duration(seconds: 2),
            () => mounted ? setState(() => _codeCopied = false) : null);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final project = widget.project;
    final screenshots = (project['screenshots'] as List<dynamic>?)
        ?.cast<String>() ??
        [project['imagePath'] as String? ?? ''];

    return TiltCard(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _activeTab != 0
                ? color.withOpacity(0.4)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: _activeTab != 0
              ? [BoxShadow(color: color.withOpacity(0.1), blurRadius: 30)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(color: color.withOpacity(0.2), blurRadius: 14)
                          ],
                        ),
                        child: Center(
                          child: Text(project['icon'] as String,
                              style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title + tags
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children: (project['tags'] as List<String>)
                                  .map((t) => SkillTag(
                                label: t,
                                color: color.value,
                                fontSize: 10,
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // GitHub + Live buttons — stacked vertically to avoid overflow
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if ((project['githubUrl'] as String).isNotEmpty)
                            _IconBtn(
                              icon: Icons.code_rounded,
                              label: 'GitHub',
                              color: color,
                              onTap: () => widget.onLaunch(
                                  project['githubUrl'] as String),
                            ),
                          if ((project['liveUrl'] as String).isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _IconBtn(
                              icon: Icons.open_in_new_rounded,
                              label: 'Live',
                              color: AppColors.accent,
                              onTap: () => widget.onLaunch(
                                  project['liveUrl'] as String),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                project['description'] as String,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _Tab(
                      label: 'Overview',
                      icon: Icons.info_outline,
                      active: _activeTab == 0,
                      color: color,
                      onTap: () => _setTab(0),
                    ),
                    const SizedBox(width: 8),
                    _Tab(
                      label: 'Code View',
                      icon: Icons.terminal_rounded,
                      active: _activeTab == 1,
                      color: color,
                      onTap: () => _setTab(1),
                    ),
                    const SizedBox(width: 8),
                    _Tab(
                      label: 'Screenshots',
                      icon: Icons.image_outlined,
                      active: _activeTab == 2,
                      color: color,
                      onTap: () => _setTab(2),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Expandable content
            SizeTransition(
              sizeFactor: _expandAnim,
              child: _activeTab == 1
                  ? _buildCodeView(color)
                  : _activeTab == 2
                  ? _buildImageGallery(screenshots, color)
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeView(Color color) {
    final code = widget.project['codeSnippet'] as String? ?? '// No code snippet available';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF060D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                  bottom: BorderSide(color: color.withOpacity(0.15))),
            ),
            child: Row(
              children: [
                // Traffic lights
                ...['#FF5F56', '#FFBD2E', '#27C93F'].map((c) => Container(
                  width: 11,
                  height: 11,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: Color(int.parse(c.replaceFirst('#', 'FF'), radix: 16)),
                    shape: BoxShape.circle,
                  ),
                )),
                const SizedBox(width: 8),
                Text(
                  'main.dart',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: color.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                // Copy button
                GestureDetector(
                  onTap: _copyCode,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _codeCopied
                        ? Row(
                      key: const ValueKey('copied'),
                      children: [
                        Icon(Icons.check_rounded,
                            size: 14, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text('Copied!',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: AppColors.accent)),
                      ],
                    )
                        : Row(
                      key: const ValueKey('copy'),
                      children: [
                        Icon(Icons.copy_rounded,
                            size: 14,
                            color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('Copy',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(20),
            child: _SyntaxHighlightedCode(code: code, accentColor: color),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(List<String> screenshots, Color color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main image
          GestureDetector(
            onTap: () => _openFullscreen(context, screenshots, _selectedImage),
            child: Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      screenshots[_selectedImage],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 48, color: color.withOpacity(0.3)),
                            const SizedBox(height: 8),
                            Text(
                              'Add screenshot to\nassets/images/',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expand icon
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.fullscreen_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (screenshots.length > 1) ...[
            const SizedBox(height: 12),
            // Thumbnail strip
            SizedBox(
              height: 64,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: screenshots.length,
                itemBuilder: (context, i) {
                  final isSelected = i == _selectedImage;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImage = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72,
                      height: 64,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)]
                            : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.asset(
                          screenshots[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surface,
                            child: Center(
                              child: Text('${i + 1}',
                                  style: TextStyle(color: color)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openFullscreen(
      BuildContext context, List<String> images, int initial) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenGallery(
          images: images,
          initialIndex: initial,
          color: widget.color,
        ),
      ),
    );
  }
}

// ─── Syntax-highlighted code (Dart keywords coloured) ────────────────────────
class _SyntaxHighlightedCode extends StatelessWidget {
  final String code;
  final Color accentColor;

  const _SyntaxHighlightedCode({required this.code, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final spans = _tokenize(code);
    return RichText(
      text: TextSpan(
        style: GoogleFonts.jetBrainsMono(
          fontSize: 13,
          height: 1.7,
          color: const Color(0xFFCDD9E5),
        ),
        children: spans,
      ),
    );
  }

  List<TextSpan> _tokenize(String src) {
    // Simple Dart/JS keyword colouring
    final dartKeywords = {
      'class', 'extends', 'implements', 'override', 'return', 'final',
      'const', 'late', 'required', 'super', 'this', 'void', 'bool',
      'int', 'double', 'String', 'List', 'Map', 'Widget', 'BuildContext',
      'StatelessWidget', 'StatefulWidget', 'State', 'Column', 'Row', 'Text',
      'Container', 'Padding', 'Center', 'Expanded', 'SizedBox', 'Wrap',
      'EdgeInsets', 'BorderRadius', 'BoxDecoration', 'Color', 'Colors',
      'import', 'package', 'dart', 'async', 'await', 'for', 'if', 'else',
      'true', 'false', 'null', 'new', 'var', 'dynamic',
      // JS
      'function', 'const', 'let', 'async', 'await', 'return',
      'Promise', 'fetch', 'map', 'join', 'document',
    };

    final spans = <TextSpan>[];
    final lines = src.split('\n');

    for (int li = 0; li < lines.length; li++) {
      final line = lines[li];
      // Line number
      spans.add(TextSpan(
        text: '${(li + 1).toString().padLeft(3)}  ',
        style: TextStyle(color: AppColors.textSecondary.withOpacity(0.3)),
      ));

      // Comment line
      if (line.trimLeft().startsWith('//')) {
        spans.add(TextSpan(
          text: '$line\n',
          style: const TextStyle(color: Color(0xFF6A737D)),
        ));
        continue;
      }

      // Tokenise by word boundaries
      // Tokenise by word boundaries
      final pattern = RegExp(r"('[^']*'|""[^""]*""|//[^\n]*|\w+|[^\w])", unicode: true);
      final matches = pattern.allMatches(line);
      for (final m in matches) {
        final tok = m.group(0)!;
        Color? c;
        if (tok.startsWith("'") || tok.startsWith('"')) {
          c = const Color(0xFF9ECE6A); // strings — green
        } else if (dartKeywords.contains(tok)) {
          c = accentColor; // keywords — accent colour
        } else if (RegExp(r'^\d+').hasMatch(tok)) {
          c = const Color(0xFFE8973A); // numbers — orange
        } else if (tok == '@' || tok.startsWith('@')) {
          c = const Color(0xFFBB9AF7); // annotations — purple
        }
        spans.add(TextSpan(
          text: tok,
          style: c != null ? TextStyle(color: c) : null,
        ));
      }
      spans.add(const TextSpan(text: '\n'));
    }
    return spans;
  }
}

// ─── Fullscreen Image Gallery ─────────────────────────────────────────────────
class _FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final Color color;

  const _FullscreenGallery({
    required this.images,
    required this.initialIndex,
    required this.color,
  });

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late int _current;
  late PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageCtrl = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_current + 1} / ${widget.images.length}',
          style: GoogleFonts.jetBrainsMono(fontSize: 14),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, i) => InteractiveViewer(
          child: Center(
            child: Image.asset(
              widget.images[i],
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image_outlined,
                        size: 64, color: widget.color.withOpacity(0.4)),
                    const SizedBox(height: 16),
                    Text(
                      'Add image to:\nassets/images/',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jetBrainsMono(
                          color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Dot indicator
      bottomNavigationBar: widget.images.length > 1
          ? Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _current == i ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _current == i ? widget.color : Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }
}

// ─── Small helper widgets ─────────────────────────────────────────────────────
class _Tab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.icon,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? color.withOpacity(0.4) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 14,
                color: active ? color : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                )),
          ],
        ),
      ),
    );
  }
}