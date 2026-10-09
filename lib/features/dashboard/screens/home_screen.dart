import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/providers/app_config_provider.dart';
import 'package:frontend/core/providers/project_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/dashboard/screens/history_screen.dart';
import 'package:frontend/features/dashboard/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _WorkflowStepItem {
  final String titleEn;
  final String titleTa;
  final String subtitleEn;
  final String subtitleTa;
  final IconData icon;
  final String image;
  final int step;

  const _WorkflowStepItem({
    required this.titleEn,
    required this.titleTa,
    required this.subtitleEn,
    required this.subtitleTa,
    required this.icon,
    required this.image,
    required this.step,
  });
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  static const int _initialVirtualPage = 1000; // 1000 % 4 == 0 (Step 1: Upload)
  int _virtualPage = _initialVirtualPage;
  final int _currentNavTab = 0;
  late PageController _pageController;
  Timer? _autoPlayTimer;
  late AnimationController _houseBuildController;

  static const List<_WorkflowStepItem> _workflowSteps = [
    _WorkflowStepItem(
      titleEn: 'Upload',
      titleTa: 'பதிவேற்றம்',
      subtitleEn: 'Add your 2D plan',
      subtitleTa: 'உங்கள் 2D வரைபடத்தைச் சேர்க்கவும்',
      icon: Icons.cloud_upload_outlined,
      image: 'https://lh3.googleusercontent.com/aida/AEtjO1WYGjukOPEQxqtFhkC5Xfc-Eg30vHHUYMINIpN63AjZbfsXww0X4nASqL7eEc_UttXAr3LEIRTtWrqZBApLpmpY14pcjo4VLww5d1kjolUfXZZ1Ax2u75K28HB-aQMvS572UXM6L-6Etq-WG_N8yIaP4VItn-4cGr2CrZMQMa3vXZG3B6UzZ4FXbMh7S-yKW_ghohWFIemD9yWijKxmwVdKx-myJxZj_RAgwlJSpeNIw25e62WCTt08Oyi0',
      step: 1,
    ),
    _WorkflowStepItem(
      titleEn: 'Pay',
      titleTa: 'கட்டணம்',
      subtitleEn: 'Secure UPI or card',
      subtitleTa: 'பாதுகாப்பான UPI அல்லது அட்டை',
      icon: Icons.payments_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDfXeQxxzTIZ8DFO2EYUVVqVwVuTbPnEQ-DzDUJaLl4PgXIXLBveyUABMuoj3LXQTftZLdLuSxn6gkgo-lYhfXrWDUie62H0m1epsZXqUgAABQeieDZ3yCso9x11zInyv6yseg7NDr2e0hDvl6QXa2wnkfu3g7nHMx_xiUVcgWncO2jc_9Ikmi0Vkqy9XuyaE4GK8HauWsqBIhT45GRn9u3_Zsky53lO-fYg-aNS-UTLNxva_qs_JVHjA',
      step: 2,
    ),
    _WorkflowStepItem(
      titleEn: 'Reports',
      titleTa: 'அறிக்கைகள்',
      subtitleEn: '3D, Vastu, Cost',
      subtitleTa: '3D, வாஸ்து, மதிப்பீடு',
      icon: Icons.view_in_ar_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDLZOt4b6n3vSFu-cqlLntqLK8xMzSSMNhif3OdN5cjhMmHuBMmzbjZ6Gjk2F_Y0MbeDU4mL2wH8uehp4QZmNaL51l1dBFD-FDtHoEqPWH1MC6ai18SDw-5B_YG5BCPfn0x2IRDr96w_GiJ1VVQe4Z8rn_4quax_DSq01r9nuChe0U0MK3ir-ZDzvKt9SUrGnQHEEJYox_E9stG68cACMvErpg8E5iPKU-VaqyNAfYW6aHQcXci8gDhDA',
      step: 3,
    ),
    _WorkflowStepItem(
      titleEn: 'Download',
      titleTa: 'பதிவிறக்கு',
      subtitleEn: 'One PDF report',
      subtitleTa: 'முழு PDF அறிக்கை',
      icon: Icons.file_download_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA0JpbkGD46RLWXoDmuaUXe91EE0-TXpT83W2ffvQhIZg-7FL7TGdfhS4bP0x_vLWPziR0nm7jDPdMzYoO_TlO3FgimeO9OJ0NI1HKFuRrmTngM2vxjHInQFACJpnajt-r-QfnJJjxDJtgis03eg6Qdm41CywLOtyWDt08w29mGw5fI56e1xq64LQsQTkDzJqGjABPJ64W11X4NAiHG7lLHa-BF8PxAByiweWfig65fhrgtvGmaMis6PA',
      step: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82, initialPage: _initialVirtualPage);
    _startAutoPlay();

    _houseBuildController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _houseBuildController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) {
            _houseBuildController.forward(from: 0.0);
          }
        });
      }
    });

    _houseBuildController.forward();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final current = _pageController.page?.round() ?? _virtualPage;
        _pageController.animateToPage(
          current + 1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _houseBuildController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>();
    final isDark = config.isDarkMode;
    final bgColor = config.bgColor;
    final cardColor = config.cardColor;
    final primaryTextColor = config.primaryTextColor;
    final secondaryTextColor = config.secondaryTextColor;
    final borderColor = config.borderColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background Art (Ambient glow and compass)
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      isDark ? Colors.white10 : Colors.white,
                      isDark ? Colors.transparent : Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.08 : 0.05,
              child: CustomPaint(
                painter: _CompassPainter(color: primaryTextColor),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 28.0, bottom: 92.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BRAND BLOCK
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 88,
                        height: 88,
                        child: CustomPaint(
                          painter: _LargeLogoPainter(color: primaryTextColor),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kanavu Illam',
                        style: GoogleFonts.syne(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          color: primaryTextColor,
                          letterSpacing: -0.34,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  
                  // WORKFLOW TRAIN CAROUSEL (Touch, Mouse, Trackpad & Auto-Scroll Enabled)
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 168,
                    child: ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.touch,
                          PointerDeviceKind.stylus,
                          PointerDeviceKind.trackpad,
                        },
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            _virtualPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final stepIndex = index % _workflowSteps.length;
                          final item = _workflowSteps[stepIndex];
                          return _buildCarouselCard(
                            title: config.tr(item.titleEn, item.titleTa),
                            subtitle: config.tr(item.subtitleEn, item.subtitleTa),
                            icon: item.icon,
                            image: item.image,
                            step: item.step,
                            pageIndex: index,
                            config: config,
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // DOT INDICATORS (Interactive & Clickable)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final currentStep = _virtualPage % 4;
                        bool isActive = currentStep == index;
                        return GestureDetector(
                          onTap: () {
                            final current = _pageController.page?.round() ?? _virtualPage;
                            final activeStep = current % 4;
                            int diff = index - activeStep;
                            if (diff > 2) diff -= 4;
                            if (diff < -2) diff += 4;
                            _pageController.animateToPage(
                              current + diff,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              height: 8.0,
                              width: isActive ? 24.0 : 8.0,
                              decoration: BoxDecoration(
                                color: isActive ? primaryTextColor : borderColor,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  
                  // HERO CARD
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Architectural CAD Blueprint Grid in Background
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Opacity(
                                opacity: isDark ? 0.05 : 0.035,
                                child: CustomPaint(
                                  painter: _BlueprintCardGridPainter(color: primaryTextColor),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Isometric House with Live Building Animation
                              Expanded(
                                child: Center(
                                  child: _buildHouseBuildingAnimation(
                                    config: config,
                                    isDark: isDark,
                                    primaryTextColor: primaryTextColor,
                                  ),
                                ),
                              ),
                          // Text and Button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    config.tr('Your Plan', 'உங்கள் திட்டம்'),
                                    style: GoogleFonts.syne(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: primaryTextColor,
                                      letterSpacing: -0.22,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'JPG, PNG, PDF',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'png', 'pdf', 'jpeg'],
                                    withData: true,
                                  );

                                  if (result != null && context.mounted) {
                                    final file = result.files.single;
                                    context.read<ProjectProvider>().setSelectedFile(file);
                                    String safePath = kIsWeb ? '' : (file.path ?? '');
                                    
                                    context.push(
                                      '/preview_payment',
                                      extra: {
                                        'path': safePath, 
                                        'name': file.name
                                      },
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white : AppColors.primary,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        config.tr('Upload Plan', 'வரைபடம் சேர்க்க'),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? Colors.black : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF262626),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.arrow_upward, size: 16, color: isDark ? Colors.black : Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),

  // BOTTOM FLOATING NAV BAR
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  floatingActionButton: Container(
    width: 280,
    height: 64,
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08), 
          blurRadius: 32, 
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavTab(0, Icons.home_outlined, config.tr('Home', 'முகப்பு'), config),
        _buildNavTab(1, Icons.history, config.tr('History', 'வரலாறு'), config),
        _buildNavTab(2, Icons.person, config.tr('Profile', 'சுயவிவரம்'), config),
      ],
    ),
  ),
);
  }

  String _getConstructionStageLabel(double p, AppConfigProvider config) {
    if (p < 0.14) return config.tr('1. PLOT', '1. நிலம்');
    if (p < 0.28) return config.tr('2. BASE', '2. அடித்தளம்');
    if (p < 0.40) return config.tr('3. PILLARS', '3. தூண்கள்');
    if (p < 0.54) return config.tr('4. WALLS', '4. சுவர்கள்');
    if (p < 0.68) return config.tr('5. 1ST FLOOR', '5. முதல் தளம்');
    if (p < 0.84) return config.tr('6. ROOF', '6. கூரை');
    if (p < 0.96) return config.tr('7. FINISH', '7. மின்விளக்கு');
    return config.tr('BUILT ✓', 'தயாரானது ✓');
  }

  Widget _buildHouseBuildingAnimation({
    required AppConfigProvider config,
    required bool isDark,
    required Color primaryTextColor,
  }) {
    return AnimatedBuilder(
      animation: _houseBuildController,
      builder: (context, _) {
        final progress = _houseBuildController.value;
        final isCompleted = progress >= 0.96;
        final stageLabel = _getConstructionStageLabel(progress, config);

        return GestureDetector(
          onTap: () {
            _houseBuildController.forward(from: 0.0);
          },
          child: SizedBox(
            width: 155,
            height: 155,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 1. True 3D Isometric Construction from Scratch Painter
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ScratchHouseBuilderPainter(
                      progress: progress,
                      isDark: isDark,
                      primaryColor: primaryTextColor,
                    ),
                  ),
                ),

                // 2. Live Construction Stage Badge (Top-Right)
                Positioned(
                  top: -2,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? (isDark ? const Color(0xFF065F46) : const Color(0xFFDCFCE7))
                          : (isDark ? Colors.black87 : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCompleted
                            ? (isDark ? const Color(0xFF10B981) : const Color(0xFF16A34A))
                            : (isDark ? const Color(0xFF38BDF8) : AppColors.primary).withValues(alpha: 0.6),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? (isDark ? const Color(0xFF34D399) : const Color(0xFF16A34A))
                                : (isDark ? const Color(0xFF38BDF8) : AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          stageLabel,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isCompleted
                                ? (isDark ? const Color(0xFF34D399) : const Color(0xFF15803D))
                                : primaryTextColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarouselCard({
    required String title, 
    required String subtitle, 
    required IconData icon,
    required String image, 
    required int step,
    required int pageIndex,
    required AppConfigProvider config,
  }) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: config.cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: config.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: config.isDarkMode ? 0.35 : 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Text Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.syne(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: config.primaryTextColor,
                        letterSpacing: -0.22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: config.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Image Content with Rich Graphic Fallback
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: config.surfacePillColor.withValues(alpha: 0.6),
                        child: Center(
                          child: Icon(icon, size: 48, color: config.secondaryTextColor.withValues(alpha: 0.8)),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            config.cardColor,
                            config.cardColor.withValues(alpha: 0.85),
                            config.cardColor.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.25, 0.65],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: config.cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: config.borderColor),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$step',
                          style: GoogleFonts.syne(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: config.primaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(int index, IconData icon, String label, AppConfigProvider config) {
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isActive
            ? BoxDecoration(
                color: config.surfacePillColor,
                borderRadius: BorderRadius.circular(100),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? config.primaryTextColor : config.secondaryTextColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? config.primaryTextColor : config.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 80x80 SVG Path CustomPainter
class _LargeLogoPainter extends CustomPainter {
  final Color color;
  _LargeLogoPainter({this.color = AppColors.primary});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path1 = Path()
      ..moveTo(16, 36)
      ..lineTo(40, 16)
      ..lineTo(64, 36)
      ..lineTo(64, 66)
      ..lineTo(16, 66)
      ..close();
      
    final path2 = Path()
      ..moveTo(29, 29)
      ..lineTo(29, 55);
      
    final path3 = Path()
      ..moveTo(43, 32)
      ..lineTo(32, 42.5)
      ..lineTo(43, 53);
      
    final path4 = Path()
      ..moveTo(51, 32)
      ..lineTo(51, 55);

    canvas.save();
    canvas.scale(size.width / 80, size.height / 80);
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
    canvas.drawPath(path4, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LargeLogoPainter oldDelegate) => oldDelegate.color != color;
}

// Compass Painter for Background
class _CompassPainter extends CustomPainter {
  final Color color;
  _CompassPainter({this.color = AppColors.primary});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    const cy = 124.0;
    
    canvas.drawCircle(Offset(cx, cy), 140, paint);
    
    final dashPaint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    const double dashWidth = 3;
    const double dashSpace = 3;
    final Path rectPath = Path()..addRect(Rect.fromLTWH(cx - 65, cy - 56, 130, 112));
    
    for (PathMetric measurePath in rectPath.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        Path extractPath = measurePath.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, dashPaint);
        distance += dashWidth + dashSpace;
      }
    }
    
    canvas.drawLine(Offset(cx - 65, cy), Offset(cx + 65, cy), paint);
    canvas.drawLine(Offset(cx, cy - 56), Offset(cx, cy + 56), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 49, cy - 42, 36, 30), paint);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) => oldDelegate.color != color;
}

// Background Architectural CAD Grid for Hero Card
class _BlueprintCardGridPainter extends CustomPainter {
  final Color color;
  _BlueprintCardGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    const double step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlueprintCardGridPainter oldDelegate) => oldDelegate.color != color;
}

// 3D Isometric Construction from Scratch Painter
class _ScratchHouseBuilderPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final bool isDark;
  final Color primaryColor;

  _ScratchHouseBuilderPainter({
    required this.progress,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ox = size.width / 2;
    // Ground anchor point
    final oy = size.height * 0.77;

    // Isometric coordinate mapping: x (+30°), y (+150°), z (up)
    Offset iso(double x, double y, double z) {
      final sx = ox + (x - y) * 0.866;
      final sy = oy + (x + y) * 0.5 - z;
      return Offset(sx, sy);
    }

    // Helper to draw a shaded 3D isometric cuboid block
    void drawBlock({
      required double x0,
      required double y0,
      required double z0,
      required double dx,
      required double dy,
      required double dz,
      required Color topColor,
      required Color rightColor,
      required Color leftColor,
      Color? strokeColor,
      double strokeWidth = 0.8,
    }) {
      if (dx <= 0 || dy <= 0 || dz <= 0) return;

      final pX = iso(x0 + dx, y0, z0);
      final pXY = iso(x0 + dx, y0 + dy, z0);
      final pY = iso(x0, y0 + dy, z0);

      final p0Z = iso(x0, y0, z0 + dz);
      final pXZ = iso(x0 + dx, y0, z0 + dz);
      final pXYZ = iso(x0 + dx, y0 + dy, z0 + dz);
      final pYZ = iso(x0, y0 + dy, z0 + dz);

      final strokePaint = strokeColor != null
          ? (Paint()
            ..color = strokeColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth)
          : null;

      // 1. Front-Right face
      final rightPath = Path()
        ..moveTo(pX.dx, pX.dy)
        ..lineTo(pXY.dx, pXY.dy)
        ..lineTo(pXYZ.dx, pXYZ.dy)
        ..lineTo(pXZ.dx, pXZ.dy)
        ..close();
      canvas.drawPath(rightPath, Paint()..color = rightColor..style = PaintingStyle.fill);
      if (strokePaint != null) canvas.drawPath(rightPath, strokePaint);

      // 2. Front-Left face
      final leftPath = Path()
        ..moveTo(pY.dx, pY.dy)
        ..lineTo(pXY.dx, pXY.dy)
        ..lineTo(pXYZ.dx, pXYZ.dy)
        ..lineTo(pYZ.dx, pYZ.dy)
        ..close();
      canvas.drawPath(leftPath, Paint()..color = leftColor..style = PaintingStyle.fill);
      if (strokePaint != null) canvas.drawPath(leftPath, strokePaint);

      // 3. Top face
      final topPath = Path()
        ..moveTo(p0Z.dx, p0Z.dy)
        ..lineTo(pXZ.dx, pXZ.dy)
        ..lineTo(pXYZ.dx, pXYZ.dy)
        ..lineTo(pYZ.dx, pYZ.dy)
        ..close();
      canvas.drawPath(topPath, Paint()..color = topColor..style = PaintingStyle.fill);
      if (strokePaint != null) canvas.drawPath(topPath, strokePaint);
    }

    // PHASE TIMINGS (Continuous Build From Scratch)
    final tPlot = (progress / 0.14).clamp(0.0, 1.0);
    final tFound = ((progress - 0.12) / 0.14).clamp(0.0, 1.0);
    final tCols = ((progress - 0.24) / 0.14).clamp(0.0, 1.0);
    final tWall1 = ((progress - 0.35) / 0.18).clamp(0.0, 1.0);
    final tSlab = ((progress - 0.50) / 0.15).clamp(0.0, 1.0);
    final tUpper = ((progress - 0.62) / 0.16).clamp(0.0, 1.0);
    final tRoof = ((progress - 0.75) / 0.14).clamp(0.0, 1.0);
    final tLights = ((progress - 0.86) / 0.10).clamp(0.0, 1.0);

    // 0. Blueprint Ground Drafting Grid (visible in initial building phases)
    if (progress < 0.55) {
      final gridAlpha = (1.0 - (progress / 0.55)).clamp(0.0, 1.0);
      final bpPaint = Paint()
        ..color = (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
            .withValues(alpha: gridAlpha * (isDark ? 0.38 : 0.22))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      for (int i = -3; i <= 3; i++) {
        final off = i * 15.0;
        canvas.drawLine(iso(-45, off, 0), iso(45, off, 0), bpPaint);
        canvas.drawLine(iso(off, -45, 0), iso(off, 45, 0), bpPaint);
      }
    }

    // 1. PLOT / GREEN LAWN SLAB
    if (tPlot > 0.01) {
      final easePlot = Curves.easeOutBack.transform(tPlot);
      final pW = 48.0 * easePlot;
      final pH = 48.0 * easePlot;

      drawBlock(
        x0: -pW / 2,
        y0: -pH / 2,
        z0: 0,
        dx: pW,
        dy: pH,
        dz: 3.0,
        topColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF4ADE80),
        rightColor: isDark ? const Color(0xFF0F172A) : const Color(0xFF22C55E),
        leftColor: isDark ? const Color(0xFF090D16) : const Color(0xFF16A34A),
        strokeColor: isDark
            ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
            : const Color(0xFF15803D).withValues(alpha: 0.45),
      );
    }

    // 2. CONCRETE FOUNDATION SLAB & ENTRANCE WALKWAY
    if (tFound > 0.01) {
      final easeFound = Curves.easeOutCubic.transform(tFound);
      final fH = 5.0 * easeFound;

      // Main house foundation plinth
      drawBlock(
        x0: -24,
        y0: -24,
        z0: 3,
        dx: 48,
        dy: 48,
        dz: fH,
        topColor: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
        rightColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        leftColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
        strokeColor: isDark ? Colors.white24 : Colors.black12,
      );

      // Paved entrance steps / pathway leading out
      if (tFound > 0.4) {
        drawBlock(
          x0: 4,
          y0: 22,
          z0: 3,
          dx: 12,
          dy: 10,
          dz: 2.0,
          topColor: isDark ? const Color(0xFF64748B) : const Color(0xFFF1F5F9),
          rightColor: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
          leftColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        );
      }
    }

    // 3. REINFORCED STRUCTURAL COLUMNS (Vertical pillars rising)
    if (tCols > 0.01) {
      final colH = 32.0 * tCols;
      const cW = 3.5;

      void drawColumn(double cx, double cy) {
        drawBlock(
          x0: cx,
          y0: cy,
          z0: 8,
          dx: cW,
          dy: cW,
          dz: colH,
          topColor: const Color(0xFFF59E0B), // Rebar amber head
          rightColor: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
          leftColor: isDark ? const Color(0xFF334155) : const Color(0xFF64748B),
          strokeColor: const Color(0xFFF59E0B).withValues(alpha: 0.6),
        );
      }

      drawColumn(-22, -22); // Back corner
      drawColumn(19 - cW, -22); // Right corner
      drawColumn(-22, 19 - cW); // Left corner
      drawColumn(19 - cW, 19 - cW); // Front corner
    }

    // 4. GROUND FLOOR MAIN WALLS + WOODEN DOOR + WINDOWS
    if (tWall1 > 0.01) {
      final wH = 32.0 * tWall1;

      // Ground Floor Main Body
      drawBlock(
        x0: -21,
        y0: -21,
        z0: 8,
        dx: 41,
        dy: 41,
        dz: wH,
        topColor: isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
        rightColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        leftColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
        strokeColor: isDark ? Colors.white12 : Colors.black12,
      );

      // Entrance Door on Front-Right facade
      if (tWall1 > 0.5) {
        final dProgress = ((tWall1 - 0.5) / 0.5).clamp(0.0, 1.0);
        final dH = 20.0 * dProgress;

        // Dark Door Frame
        drawBlock(
          x0: 3,
          y0: 19.2,
          z0: 8,
          dx: 11,
          dy: 1.2,
          dz: dH,
          topColor: const Color(0xFF78350F),
          rightColor: const Color(0xFF9A3412),
          leftColor: const Color(0xFF451A03),
        );

        // Wooden Door Pane
        drawBlock(
          x0: 4.5,
          y0: 19.5,
          z0: 8,
          dx: 8,
          dy: 0.8,
          dz: (dH - 1.5).clamp(0.0, 20.0),
          topColor: const Color(0xFFB45309),
          rightColor: const Color(0xFFD97706),
          leftColor: const Color(0xFF92400E),
        );

        // Brass Door Knob
        if (dProgress > 0.8) {
          final knob = iso(11, 20.2, 17);
          canvas.drawCircle(knob, 1.4, Paint()..color = const Color(0xFFFBBF24));
        }
      }

      // Ground Floor Architectural Window on Front-Left facade
      if (tWall1 > 0.6) {
        final winProg = ((tWall1 - 0.6) / 0.4).clamp(0.0, 1.0);
        final winW = 14.0 * winProg;
        final winH = 14.0 * winProg;

        // Window Frame & Glass
        drawBlock(
          x0: -18,
          y0: 4,
          z0: 15,
          dx: 1.2,
          dy: winW,
          dz: winH,
          topColor: const Color(0xFF38BDF8),
          rightColor: const Color(0xFF0284C7),
          leftColor: const Color(0xFF0369A1),
        );

        // Glass reflection shine slash
        if (winProg > 0.8) {
          final g1 = iso(-18.5, 7, 24);
          final g2 = iso(-18.5, 14, 17);
          canvas.drawLine(
            g1,
            g2,
            Paint()
              ..color = Colors.white.withValues(alpha: 0.7)
              ..strokeWidth = 1.2,
          );
        }
      }
    }

    // 5. 1ST FLOOR CANTILEVER SLAB & BALCONY RAILING
    if (tSlab > 0.01) {
      final easeSlab = Curves.easeOutBack.transform(tSlab);
      final slabDrop = 22.0 * (1.0 - easeSlab);
      final slabZ = 40.0 - slabDrop;

      // Modern Architectural Cantilever Slab
      drawBlock(
        x0: -23,
        y0: -23,
        z0: slabZ,
        dx: 46,
        dy: 46,
        dz: 4.0,
        topColor: isDark ? const Color(0xFF475569) : const Color(0xFF334155),
        rightColor: isDark ? const Color(0xFF334155) : const Color(0xFF1E293B),
        leftColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
        strokeColor: isDark ? const Color(0xFF38BDF8).withValues(alpha: 0.5) : Colors.white24,
      );

      // Glass Balcony Railing
      if (tSlab > 0.6) {
        drawBlock(
          x0: 5,
          y0: 21.5,
          z0: slabZ + 4,
          dx: 16,
          dy: 0.8,
          dz: 8.0,
          topColor: const Color(0xFF67E8F9).withValues(alpha: 0.7),
          rightColor: const Color(0xFF38BDF8).withValues(alpha: 0.6),
          leftColor: const Color(0xFF0284C7).withValues(alpha: 0.7),
          strokeColor: Colors.white70,
          strokeWidth: 0.6,
        );
      }
    }

    // 6. UPPER LEVEL ROOMS & PANORAMIC GLASS WINDOW
    if (tUpper > 0.01) {
      final uH = 26.0 * tUpper;

      // Upper Room Block
      drawBlock(
        x0: -19,
        y0: -19,
        z0: 44,
        dx: 36,
        dy: 36,
        dz: uH,
        topColor: isDark ? const Color(0xFF334155) : const Color(0xFFFFFFFF),
        rightColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        leftColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
        strokeColor: isDark ? Colors.white12 : Colors.black12,
      );

      // Contemporary Teak Wood Feature Siding
      if (tUpper > 0.4) {
        drawBlock(
          x0: -5,
          y0: 16.2,
          z0: 45,
          dx: 12,
          dy: 1.0,
          dz: (uH - 3).clamp(0.0, 22.0),
          topColor: const Color(0xFFB45309),
          rightColor: const Color(0xFFD97706),
          leftColor: const Color(0xFF92400E),
        );
      }

      // Panoramic Master Bedroom Picture Window
      if (tUpper > 0.5) {
        final upWinProg = ((tUpper - 0.5) / 0.5).clamp(0.0, 1.0);
        final pwH = 14.0 * upWinProg;

        drawBlock(
          x0: 8,
          y0: 16.5,
          z0: 48,
          dx: 8,
          dy: 0.8,
          dz: pwH,
          topColor: const Color(0xFF38BDF8),
          rightColor: const Color(0xFF0284C7),
          leftColor: const Color(0xFF0369A1),
          strokeColor: Colors.white,
          strokeWidth: 0.7,
        );

        if (upWinProg > 0.8) {
          final s1 = iso(10, 17, 58);
          final s2 = iso(14, 17, 52);
          canvas.drawLine(s1, s2, Paint()..color = Colors.white.withValues(alpha: 0.8)..strokeWidth = 1.0);
        }
      }
    }

    // 7. MODERN FLOATING ROOF SLAB & CHIMNEY
    if (tRoof > 0.01) {
      final easeRoof = Curves.easeOutBack.transform(tRoof);
      final roofDrop = 24.0 * (1.0 - easeRoof);
      final roofZ = 70.0 - roofDrop;

      // Floating Roof Overhang
      drawBlock(
        x0: -22,
        y0: -22,
        z0: roofZ,
        dx: 44,
        dy: 44,
        dz: 4.5,
        topColor: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
        rightColor: isDark ? const Color(0xFF090D16) : const Color(0xFF0F172A),
        leftColor: isDark ? const Color(0xFF020617) : const Color(0xFF020617),
        strokeColor: isDark ? const Color(0xFF38BDF8) : const Color(0xFFEA580C),
        strokeWidth: 1.0,
      );

      // Sleek Rooftop Chimney / Solar Vent
      if (tRoof > 0.5) {
        drawBlock(
          x0: -12,
          y0: -12,
          z0: roofZ + 4.5,
          dx: 6,
          dy: 6,
          dz: 8.0,
          topColor: const Color(0xFFEA580C),
          rightColor: const Color(0xFFC2410C),
          leftColor: const Color(0xFF9A3412),
        );
      }
    }

    // 8. WARM INTERIOR LIGHTS, PORCH LANTERN & GARDEN PLANTS
    if (tLights > 0.01) {
      // Warm glowing windows (interior lights turned on!)
      final glowPaint = Paint()
        ..color = const Color(0xFFFDE047).withValues(alpha: tLights * 0.85)
        ..style = PaintingStyle.fill;

      // Ground floor window warm glow
      final gWinPath = Path()
        ..moveTo(iso(-18, 4, 15).dx, iso(-18, 4, 15).dy)
        ..lineTo(iso(-18, 18, 15).dx, iso(-18, 18, 15).dy)
        ..lineTo(iso(-18, 18, 29).dx, iso(-18, 18, 29).dy)
        ..lineTo(iso(-18, 4, 29).dx, iso(-18, 4, 29).dy)
        ..close();
      canvas.drawPath(gWinPath, glowPaint);

      // Upper floor window warm glow
      final uWinPath = Path()
        ..moveTo(iso(8, 16.5, 48).dx, iso(8, 16.5, 48).dy)
        ..lineTo(iso(16, 16.5, 48).dx, iso(16, 16.5, 48).dy)
        ..lineTo(iso(16, 16.5, 62).dx, iso(16, 16.5, 62).dy)
        ..lineTo(iso(8, 16.5, 62).dx, iso(8, 16.5, 62).dy)
        ..close();
      canvas.drawPath(uWinPath, glowPaint);

      // Porch Lamp above entrance door (glowing warm radial amber light)
      final lampPos = iso(8.5, 20.0, 27);
      canvas.drawCircle(
        lampPos,
        14 * tLights,
        Paint()
          ..color = const Color(0xFFFBBF24).withValues(alpha: 0.25 * tLights)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.drawCircle(lampPos, 2.5, Paint()..color = const Color(0xFFFEF08A));

      // Cute Potted Garden Plant beside entrance steps
      final potPos = iso(16.5, 23.5, 3);
      drawBlock(
        x0: 15,
        y0: 22,
        z0: 3,
        dx: 3.5,
        dy: 3.5,
        dz: 4.0,
        topColor: const Color(0xFF9A3412),
        rightColor: const Color(0xFF7C2D12),
        leftColor: const Color(0xFF451A03),
      );
      // Foliage green sphere
      canvas.drawCircle(
        Offset(potPos.dx, potPos.dy - 6),
        4.5,
        Paint()..color = const Color(0xFF22C55E),
      );

      // Completion celebration stars/sparkles around roof
      if (tLights > 0.7) {
        void drawSparkle(Offset pt, double r) {
          final spPaint = Paint()
            ..color = const Color(0xFFFBBF24)
            ..strokeWidth = 1.0;
          canvas.drawLine(Offset(pt.dx - r, pt.dy), Offset(pt.dx + r, pt.dy), spPaint);
          canvas.drawLine(Offset(pt.dx, pt.dy - r), Offset(pt.dx, pt.dy + r), spPaint);
        }

        drawSparkle(iso(-18, -18, 78), 4.0);
        drawSparkle(iso(18, -18, 76), 3.5);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ScratchHouseBuilderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.primaryColor != primaryColor;
  }
}
