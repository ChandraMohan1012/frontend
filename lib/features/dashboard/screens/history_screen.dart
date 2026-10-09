import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/features/dashboard/screens/home_screen.dart';
import 'package:frontend/features/dashboard/screens/profile_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final int _currentNavTab = 1; // History is active

  final List<Map<String, dynamic>> _projects = [
    {
      'name': 'house_plan.pdf',
      'date': 'Today, 10:42 AM',
      'features': ['3D', 'Va', '₹', 'St'],
      'amount': '₹1,200',
    },
    {
      'name': 'villa_ground_floor.png',
      'date': 'Yesterday, 6:15 PM',
      'features': ['3D', 'Va'],
      'amount': '₹800',
    },
    {
      'name': 'site_30x40.jpg',
      'date': '2 Oct 2026',
      'features': ['₹', 'St'],
      'amount': '₹450',
    },
    {
      'name': 'duplex_plan.pdf',
      'date': '28 Sep 2026',
      'features': ['3D', 'Va', 'St'],
      'amount': '₹950',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'History',
                            style: GoogleFonts.syne(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              letterSpacing: -0.12,
                            ),
                          ),
                          Text(
                            '${_projects.length} Downloads',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Project List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 120), // Bottom padding for nav
                    itemCount: _projects.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _buildProjectCard(_projects[index]);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Gradient Fade Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 96,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.backgroundLight,
                      AppColors.backgroundLight.withValues(alpha: 0.8),
                      AppColors.backgroundLight.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // FLOATING BOTTOM NAV
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 280,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavTab(0, Icons.home_outlined, 'Home'),
                    _buildNavTab(1, Icons.history, 'History'),
                    _buildNavTab(2, Icons.person_outline, 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    List<String> features = List<String>.from(project['features'] ?? []);
    String amount = project['amount'] ?? '₹0';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thumbnail
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              painter: _BlueprintThumbPainter(),
            ),
          ),
          const SizedBox(width: 12),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['name'] ?? 'Unknown Project',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  project['date'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: features.map((f) => _buildFeatureBadge(f)).toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),

          // Amount Spent
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Spent',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(String label) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFFE1DFDF), // bg-secondary-container
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildNavTab(int index, IconData icon, String label) {
    bool isActive = _currentNavTab == index;
    return GestureDetector(
      onTap: () {
        if (_currentNavTab == index) return;
        Widget page;
        if (index == 0) {
          page = const HomeScreen();
        } else if (index == 1) {
          page = const HistoryScreen();
        } else {
          page = const ProfileScreen();
        }
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, _, _) => page,
            transitionDuration: Duration.zero,
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFFE1DFDF), // bg-secondary-container
                borderRadius: BorderRadius.circular(100),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for the thumbnail svgs
class _BlueprintThumbPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.scale(size.width / 40, size.height / 40); // viewbox 0 0 40 40

    // Common outer rect
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(3, 3, 34, 34), const Radius.circular(2)), paint..strokeWidth = 1.8);

    // Floor plan inner lines
    canvas.drawLine(const Offset(3, 20), const Offset(37, 20), paint);
    canvas.drawLine(const Offset(18, 3), const Offset(18, 20), paint);
    canvas.drawLine(const Offset(28, 20), const Offset(28, 37), paint);
    canvas.drawCircle(const Offset(8, 28), 1.5, Paint()..color = AppColors.primary);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
