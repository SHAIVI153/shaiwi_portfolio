class PortfolioData {
  static const String name = 'Shawaiz Niamat';
  static const String nickname = 'shaiwi_code';
  static const String title = 'Flutter & Web Developer';
  static const String tagline = 'Crafting pixel-perfect apps\nwith Flutter & Dart';
  static const String bio =
      'I\'m a passionate Flutter & Web Developer who turns ideas into beautiful, high-performance digital experiences. Specializing in cross-platform mobile apps, responsive web solutions, and SEO-driven digital marketing strategies.';

  static const String email     = 'shawaizengg454@gmail.com';
  static const String github    = 'https://github.com/SHAIVI153';
  static const String linkedin  = 'https://linkedin.com/in/shawaiz-niamat';
  static const String instagram = 'https://instagram.com/shawaiz._.niamat';
  static const String facebook  = 'https://facebook.com/shawaiz.niamat';
  static const String whatsapp  = 'https://wa.me/923156434296';

  // ── CV URLs
  static const String cvDownloadUrl =
      'https://drive.google.com/uc?export=download&id=11XcX6NRmxBSaR-oaDD0LY8MCH7Unhrt9';

  static const String cvPreviewUrl =
      'https://drive.google.com/file/d/11XcX6NRmxBSaR-oaDD0LY8MCH7Unhrt9/view';

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
      'proficiency': 0.70,
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
      'title': 'ShaiwiShop',
      'description': 'Full-featured e-commerce Flutter app with real-time Firebase backend, GetX state management, and beautiful UI.',
      'tags': ['Flutter', 'Firebase', 'GetX'],
      'color': 0xFF00D4FF,
      'icon': '🛒',
      'githubUrl': 'https://github.com/shaiwi_code/shaiwishop',
      'liveUrl': '',
      'imagePath': 'assets/images/project1.png',
      'screenshots': [
        'assets/images/project1.png',
        'assets/images/project1b.png',
        'assets/images/project1c.png',
      ],
      'codeSnippet': '''// ShaiwiShop — Product Card Widget
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
      'title': 'TaskFlow Pro',
      'description': 'Productivity app with Kanban boards, local notifications, and Hive database for offline-first experience.',
      'tags': ['Flutter', 'Dart', 'Hive'],
      'color': 0xFF7B2FFF,
      'icon': '✅',
      'githubUrl': 'https://github.com/shaiwi_code/taskflow',
      'liveUrl': '',
      'imagePath': 'assets/images/project2.png',
      'screenshots': [
        'assets/images/project2.png',
        'assets/images/project2b.png',
      ],
      'codeSnippet': '''// TaskFlow — Kanban Task Model (Hive)
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String status; // todo | doing | done

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  bool isCompleted = false;

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
  });

  void complete() {
    isCompleted = true;
    status = 'done';
    save(); // Hive auto-persist
  }
}

// Riverpod provider
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>(
  (ref) => TaskNotifier(),
);''',
    },
    {
      'title': 'SEO Dashboard',
      'description': 'Web-based SEO analytics dashboard with keyword tracking, competitor analysis, and performance reporting.',
      'tags': ['HTML', 'CSS', 'JS', 'MySQL'],
      'color': 0xFF00FF88,
      'icon': '📊',
      'githubUrl': 'https://github.com/shaiwi_code/seo-dashboard',
      'liveUrl': 'https://shaiwi-seo.netlify.app',
      'imagePath': 'assets/images/project3.png',
      'screenshots': [
        'assets/images/project3.png',
        'assets/images/project3b.png',
      ],
      'codeSnippet': '''// SEO Dashboard — Keyword Rank Tracker
async function fetchKeywordRanks(keywords) {
  const results = await Promise.all(
    keywords.map(async (kw) => {
      const res = await fetch(\`/api/rank?q=\${encodeURIComponent(kw)}\`);
      const data = await res.json();
      return {
        keyword: kw,
        rank: data.rank,
        change: data.change,
        volume: data.searchVolume,
        url: data.topUrl,
      };
    })
  );

  renderTable(results);
  updateChart(results);
}

function renderTable(data) {
  const tbody = document.querySelector('#rank-table tbody');
  tbody.innerHTML = data.map(row => \`
    <tr class="rank-row \${row.change > 0 ? 'up' : 'down'}">
      <td>\${row.keyword}</td>
      <td>#\${row.rank}</td>
      <td>\${row.change > 0 ? '▲' : '▼'} \${Math.abs(row.change)}</td>
      <td>\${row.volume.toLocaleString()}</td>
    </tr>
  \`).join('');
}''',
    },
    {
      'title': 'Portfolio UI Kit',
      'description': 'A reusable Flutter UI kit with 30+ custom widgets, dark/light theme, and smooth animations.',
      'tags': ['Flutter', 'Dart', 'Animations'],
      'color': 0xFFFF6B35,
      'icon': '🎨',
      'githubUrl': 'https://github.com/shaiwi_code/flutter-ui-kit',
      'liveUrl': '',
      'imagePath': 'assets/images/project4.png',
      'screenshots': [
        'assets/images/project4.png',
        'assets/images/project4b.png',
      ],
      'codeSnippet': '''// Flutter UI Kit — Animated Gradient Button
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final List<Color> colors;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.colors = const [Color(0xFF00D4FF), Color(0xFF7B2FFF)],
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.colors),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: widget.colors.first.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            )),
        ),
      ),
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

