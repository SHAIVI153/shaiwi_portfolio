import 'package:flutter/material.dart';

/// Responsive utility — used via LayoutBuilder everywhere.
/// Never uses MediaQuery.of(context).size directly in screens.
class Rsp {
  final double width;
  final double height;

  const Rsp({required this.width, required this.height});

  // ── Breakpoints
  bool get isMobile  => width < 600;
  bool get isTablet  => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  // ── Horizontal padding — scales with screen
  double get hPad {
    if (isDesktop) return (width * 0.09).clamp(60, 140);
    if (isTablet)  return 36;
    return 18;
  }

  double get vPad {
    if (isDesktop) return 60;
    if (isTablet)  return 44;
    return 32;
  }

  // ── Font sizes — fluid scaling
  double fs(double d) {
    if (isDesktop) return d;
    if (isTablet)  return d * 0.88;
    // Mobile: fluid based on actual width
    final scale = (width / 390).clamp(0.72, 1.0);
    return d * scale * 0.82;
  }

  // ── Spacing
  double sp(double d) {
    if (isDesktop) return d;
    if (isTablet)  return d * 0.85;
    return d * 0.65;
  }

  // ── Card dimensions
  double get profileCardWidth {
    if (isDesktop) return 310;
    if (isTablet)  return 270;
    return (width - hPad * 2).clamp(240, 340);
  }

  // ── Grid columns
  int grid2() => isDesktop ? 2 : 1;
  int grid3() {
    if (isDesktop) return 3;
    if (isTablet)  return 2;
    return 1;
  }

  // ── Section title font
  double get sectionTitleFs => fs(42);

  // ── Whether to show side-by-side or stacked
  bool get sideBySide => !isMobile;
}

/// Widget builder that provides Rsp
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Rsp r) builder;
  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final r = Rsp(
        width: constraints.maxWidth,
        height: MediaQuery.of(ctx).size.height,
      );
      return builder(ctx, r);
    });
  }
}