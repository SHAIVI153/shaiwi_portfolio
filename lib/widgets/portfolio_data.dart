class PortfolioData {
  static const String name = 'Shawaiz Niamat';
  static const String nickname = 'shaiwi_code';
  static const String title = 'Flutter & Web Developer';
  static const String tagline = 'Crafting pixel-perfect apps\nwith Flutter & Dart';
  static const String bio =
      'I\'m a passionate Flutter & Web Developer who turns ideas into beautiful, high-performance digital experiences. Specializing in cross-platform mobile apps, responsive web solutions, and SEO-driven digital marketing strategies.';

  static const String email = 'shawaizengg454@gmail.com';
  static const String github = 'https://github.com/SHAIVI153';
  static const String linkedin = 'https://linkedin.com/in/shawaiz-niamat';
  static const String instagram = 'https://instagram.com/shawaiz._.niamat';
  static const String facebook  = 'https://facebook.com/shawaiz.niamat';
  static const String whatsapp  = 'https://wa.me/923156434296';
  static const String phone     = '+92 315 6434296';

  static const String cvDownloadUrl =
      'https://drive.google.com/uc?export=download&id=11XcX6NRmxBSaR-oaDD0LY8MCH7Unhrt9';

  static const List<Map<String, dynamic>> skills = [
    {
      'category': 'Mobile Development',
      'icon': '📱',
      'color': 0xFF00D4FF,
      'proficiency': 0.90,
      'items': ['Flutter', 'Dart', 'State Management', 'Firebase', 'REST APIs', 'GetX / Riverpod'],
    },
    {
      'category': 'Web Development',
      'icon': '🌐',
      'color': 0xFF7B2FFF,
      'proficiency': 0.75,
      'items': ['HTML5', 'CSS3', 'JavaScript', 'Bootstrap', 'Responsive Design', 'WebFlow'],
    },
    {
      'category': 'Backend & Database',
      'icon': '🗄️',
      'color': 0xFF00FF88,
      'proficiency': 0.65,
      'items': ['MySQL', 'Firebase Firestore,'
          'Firebase Authentications'
          , 'REST API Integration', 'Node.js Basics'],
    },
    {
      'category': 'SEO & Marketing',
      'icon': '📈',
      'color': 0xFFFF6B35,
      'proficiency': 0.80,
      'items': ['On-Page SEO', 'Technical SEO', 'Digital Marketing', 'Analytics', 'Content Strategy'],
    },
  ];

  static const List<Map<String, dynamic>> projects = [
    {
      'title': 'denim-diverse',
      'description': 'Full-featured e-commerce Flutter app with real-time Firebase backend, GetX state management, and beautiful UI.',
      'tags': ['Flutter', 'Firebase', 'GetX'],
      'color': 0xFF00D4FF,
      'icon': '🛒',
      'githubUrl': 'https://github.com/SHAIVI153/denim_diverse',
      'liveUrl': '',
      'imagePath': 'assets/images/Header.jpeg',
      'screenshots': [
        'assets/images/products.jpeg',
        'assets/images/size.jpeg',
        'assets/images/order.jpeg',
      ],
      'comingSoon': false,
      'codeSnippet': '// denim-diverse — Product Card Widget\n'
          'class ProductCard extends StatelessWidget {\n'
          '  final Product product;\n'
          '  const ProductCard({super.key, required this.product});\n'
          '\n'
          '  @override\n'
          '  Widget build(BuildContext context) {\n'
          '    return GestureDetector(\n'
          '      onTap: () => Get.to(() => ProductDetail(product)),\n'
          '      child: Container(\n'
          '        decoration: BoxDecoration(\n'
          '          color: AppColors.card,\n'
          '          borderRadius: BorderRadius.circular(16),\n'
          '        ),\n'
          '        child: Column(\n'
          '          crossAxisAlignment: CrossAxisAlignment.start,\n'
          '          children: [\n'
          '            ClipRRect(\n'
          '              borderRadius: const BorderRadius.vertical(\n'
          '                top: Radius.circular(16),\n'
          '              ),\n'
          '              child: CachedNetworkImage(\n'
          '                imageUrl: product.imageUrl,\n'
          '                height: 160,\n'
          '                width: double.infinity,\n'
          '                fit: BoxFit.cover,\n'
          '              ),\n'
          '            ),\n'
          '          ],\n'
          '        ),\n'
          '      ),\n'
          '    );\n'
          '  }\n'
          '}',
    },
    {
      'title': 'shaiwi_portfolio',
      'description': 'A high-performance, ultra-modern developer portfolio built using Flutter. Features fully responsive layout, particle/glow effects, smooth animations, and syntax-highlighted code viewer.',
      'tags': ['Flutter', 'Dart', 'Responsive UI', 'SEO Optimized', 'Animations'],
      'color': 0xFF7B2FFF,
      'icon': '✅',
      'githubUrl': 'https://github.com/SHAIVI153/shaiwi_portfolio',
      'liveUrl': '',
      'imagePath': 'assets/images/flutter.jpeg',
      'screenshots': [
        'assets/images/services.jpeg',
        'assets/images/skills.jpeg',
        'assets/images/drawers.jpeg',
        'assets/images/cv.jpeg',
        'assets/images/connect.jpeg',
      ],
      'comingSoon': false,
      'codeSnippet': "import 'package:flutter/material.dart';\n"
          '\n'
          'class ResponsiveScreen extends StatelessWidget {\n'
          '  final Widget mobile;\n'
          '  final Widget desktop;\n'
          '\n'
          '  const ResponsiveScreen({super.key, required this.mobile, required this.desktop});\n'
          '\n'
          '  @override\n'
          '  Widget build(BuildContext context) {\n'
          '    return LayoutBuilder(\n'
          '      builder: (context, constraints) {\n'
          '        if (constraints.maxWidth < 768) {\n'
          '          return mobile;\n'
          '        } else {\n'
          '          return desktop;\n'
          '        }\n'
          '      },\n'
          '    );\n'
          '  }\n'
          '}',
    },

    {
      'title': 'FitVision AI (Comming Soon)',
      'description': 'AI-powered fitness & nutrition app that detects food from photos, calculates calories instantly, and builds personalized diet + workout plans based on your weight, height, and age.',
      'tags': ['Flutter', 'AI/ML', 'Firebase', 'Computer Vision', 'Diet Planning'],
      'color': 0xFF00FF88,
      'icon': '🤖',
      'githubUrl': '',
      'liveUrl': '',
      'imagePath': 'assets/images/comingsoon.jpg',
      'screenshots': [
        'assets/images/comingsoon.jpg',
      ],
      'comingSoon': true, // Yeh check true hai
      'codeSnippet': '// FitVision AI — Personalized Diet Plan Generator\n'
          'class DietPlanGenerator {\n'
          '  static Map<String, dynamic> generate({\n'
          '    required double weightKg,\n'
          '    required double heightCm,\n'
          '    required int age,\n'
          '    required String goal,\n'
          '  }) {\n'
          '    final bmi    = weightKg / math.pow(heightCm / 100, 2);\n'
          '    final bmr    = 10 * weightKg + 6.25 * heightCm - 5 * age;\n'
          '    final tdee   = bmr * 1.375;\n'
          '    final target = goal == "lose" ? tdee - 500\n'
          '                 : goal == "gain" ? tdee + 300 : tdee;\n'
          '    return {\n'
          '      "bmi":           bmi.toStringAsFixed(1),\n'
          '      "dailyCalories": target.round(),\n'
          '      "protein_g":     (weightKg * 2.2).round(),\n'
          '      "carbs_g":       ((target * 0.45) / 4).round(),\n'
          '      "fats_g":        ((target * 0.25) / 9).round(),\n'
          '      "keys": "shawiCode"\n'
          '    };\n'
          '  }\n'
          '}',
    },
  ];

  static const List<Map<String, String>> services = [
    {
      'icon': '📱',
      'title': 'Flutter App Development',
      'desc': 'Cross-platform iOS & Android apps with native performance and stunning UI using Flutter & Dart.',
    },
    {
      'icon': '🌐',
      'title': 'Web Development',
      'desc': 'Responsive, fast-loading websites using HTML, CSS, JavaScript, Bootstrap, and MySQL.',
    },
    {
      'icon': '🎨',
      'title': 'UI/UX Design',
      'desc': 'Pixel-perfect, user-centered designs inspired by Webflow aesthetics and modern design systems.',
    },
    {
      'icon': '📈',
      'title': 'SEO & Digital Marketing',
      'desc': 'Drive organic traffic with technical SEO, content strategy, and data-driven digital marketing.',
    },
  ];

  // ── Certifications ────────────────────────────────────────────────────────
  // Add your certificate image to assets/images/certifications/ and add an
  // entry below. 'image' should point to that asset path; 'credentialUrl'
  // is optional — leave it '' if you don't want a "Verify" link.
  // Set 'status' to 'pending' for an upcoming/in-progress certificate — it
  // will show as a "Coming Soon" placeholder card instead of an image.
  static const List<Map<String, String>> certifications = [
    {
      'title': 'SQL & Database Management',
      'issuer': 'Self-paced / Practical Projects',
      'date': '2025',
      'image': 'assets/images/certifications/cert_1.jpg',
      'credentialUrl': '',
      'status': 'done',
    },
    {
      'title': 'AI / ML',
      'issuer': 'Coming Soon',
      'date': 'Pending',
      'image': '',
      'credentialUrl': '',
      'status': 'pending',
    },
  ];
}