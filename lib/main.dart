import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/services_screen.dart';
import 'screens/contact_screen.dart';

// Note: Ensure your widgets/app_theme.dart has AppTheme.darkTheme, AppColors.background, AppColors.surface, AppColors.border, AppColors.primary, and AppColors.textSecondary configured properly.
import 'widgets/app_theme.dart';

void main() {
  runApp(const ShaiwiPortfolioApp());
}

class ShaiwiPortfolioApp extends StatefulWidget {
  const ShaiwiPortfolioApp({super.key});

  @override
  State<ShaiwiPortfolioApp> createState() => _ShaiwiPortfolioAppState();
}

class _ShaiwiPortfolioAppState extends State<ShaiwiPortfolioApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shaiwi_code | Flutter & Web Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PortfolioShell(),
    );
  }
}

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final _sections = ['Home', 'Skills', 'Projects', 'Services', 'Contact'];

  void _navigateTo(String section) {
    final idx = _sections.indexOf(section);
    if (idx != -1 && idx != _currentIndex) {
      setState(() => _currentIndex = idx);
    }
  }

  void _navigateToIndex(int idx) {
    setState(() => _currentIndex = idx);
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          onContactTap: () => _navigateToIndex(4),
          onProjectsTap: () => _navigateToIndex(2),
        );
      case 1:
        return const SkillsScreen();
      case 2:
        return const ProjectsScreen();
      case 3:
        return ServicesScreen(onHireTap: () => _navigateToIndex(4));
      case 4:
        return const ContactScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Nav Bar (Desktop)
          if (!isMobile)
            PortfolioNavBar(
              onNavTap: _navigateTo,
              activeSection: _sections[_currentIndex],
              sections: _sections,
            ),

          // ── Page content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: anim,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: _buildScreen(),
              ),
            ),
          ),

          // ── Bottom Nav (mobile)
          if (isMobile) _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final icons = [
      Icons.home_outlined,
      Icons.code_outlined,
      Icons.work_outline,
      Icons.design_services_outlined,
      Icons.mail_outline,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _sections.asMap().entries.map((entry) {
            final i = entry.key;
            final isActive = _currentIndex == i;
            return GestureDetector(
              onTap: () => _navigateToIndex(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[i],
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.value,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Desktop Navigation Bar Helper Widget ─────────────────────────────────────
class PortfolioNavBar extends StatelessWidget {
  final Function(String) onNavTap;
  final String activeSection;
  final List<String> sections;

  const PortfolioNavBar({
    super.key,
    required this.onNavTap,
    required this.activeSection,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'shaiwi_code',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          Row(
            children: sections.map((sec) {
              final isCurrent = activeSection == sec;
              return GestureDetector(
                onTap: () => onNavTap(sec),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    sec,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 15,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}