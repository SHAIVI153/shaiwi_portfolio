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

  // ── CV download URL (put your Google Drive / Dropbox direct link here)
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
      'items': ['MySQL', 'Firebase Firestore', 'REST API Integration', 'Node.js Basics'],
    },
    {
      'category': 'SEO & Marketing',
      'icon': '📈',
      'color': 0xFFFF6B35,
      'proficiency': 0.80,
      'items': ['On-Page SEO', 'Technical SEO', 'Digital Marketing', 'Analytics', 'Content Strategy'],
    },
  ];

  // ── Projects now include image paths + github/live links + codeSnippet
  static const List<Map<String, dynamic>> projects = [
    {
      'title': 'denim-diverse',
      'description': 'Full-featured e-commerce Flutter app with real-time Firebase backend, GetX state management, and beautiful UI.',
      'tags': ['Flutter', 'Firebase', 'GetX'],
      'color': 0xFF00D4FF,
      'icon': '🛒',
      'githubUrl': 'https://github.com/SHAIVI153/denim_diverse',
      'liveUrl': '',
      // Place your screenshot at: assets/images/project1.png
      'imagePath': 'assets/images/Header.jpeg',
      'screenshots': [
        'assets/images/Header.jpeg',
        'assets/images/products.jpeg',
        'assets/images/size.jpeg',
        'assets/images/order.jpeg',
        'assets/images/checkout.jpeg',
        'assets/images/deals.jpeg',
        'assets/images/featured.jpeg',
        'assets/images/drawer.jpeg',
      ],
      'codeSnippet': '''// denim-diverse — Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetail(product)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    )),
                  const SizedBox(height: 4),
                  Text('\${product.price}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}''',
    },
    {
      'title': 'shaiwi_portfolio',
      'description': 'A high-performance, ultra-modern developer portfolio application built using Flutter. Features a fully responsive interface layout, beautiful particle/glow visual effects, fluid smooth animations using flutter_animate, syntax-highlighted code viewer tabs, and direct asset-based resume extraction workflows.',
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
      'codeSnippet': '''import 'package:flutter/material.dart';

class ResponsiveScreen extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveScreen({super.key, required this.mobile, required this.desktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return mobile;
        } else {
          return desktop;
        }
      },
    );
  }
}''',
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
}