import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultStructure3dFootingScreen extends StatelessWidget {
  const ResultStructure3dFootingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 20.0),
          child: Column(
            children: [
              // 1. Header
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(projectProvider.currentPlanName ?? 'Plan 05', style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary, letterSpacing: -0.24, height: 1.1), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('Structural report · 40\' × 40\' (1,600 sq ft)', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(color: AppColors.surfaceSecondary, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 20, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. Main Tabs
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildMainTab(context, '3D', false, '/result/3d_model'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Vastu', false, '/result/vastu/score'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Cost', false, '/result/cost/tiers'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Structure', true, '/result/structure/plan'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Plot Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Plot size', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('40\' × 40\'', style: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w500, color: AppColors.primary, letterSpacing: -0.26)),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.surfaceSecondary, borderRadius: BorderRadius.circular(100)),
                              child: Text('1,600 sq ft', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 68,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.surfaceSecondary, borderRadius: BorderRadius.circular(100)),
                          child: Text('IS 456', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 68,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.surfaceSecondary, borderRadius: BorderRadius.circular(100)),
                          child: Text('Zone III', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 4. Sub Tabs
              SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 1, color: const Color(0xFFE2E2E2))),
                    Row(
                      children: [
                        _buildSubTab(context, 'Plan', false, '/result/structure/plan'),
                        _buildSubTab(context, '3D', true, '/result/structure/3d/footing'),
                        _buildSubTab(context, 'Schedule', false, '/result/structure/schedule'),
                        _buildSubTab(context, 'Safety', false, '/result/structure/safety'),
                        _buildSubTab(context, 'Quantity', false, '/result/structure/quantity'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 5. Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Chips
                      Row(
                        children: [
                          _buildFilterChip(context, 'Frame', false, '/result/structure/3d/frame'),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'Slab', false, '/result/structure/3d/slab'),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'Footing', true, '/result/structure/3d/footing'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Drawing Box
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Footing Plan View
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CustomPaint(
                                        size: const Size(120, 120),
                                        painter: FootingPlanPainter(),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Footing plan', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              // Vertical Divider
                              Container(width: 1, height: 200, color: AppColors.border),
                              // Section View
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CustomPaint(
                                        size: const Size(120, 120),
                                        painter: FootingSectionPainter(),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Section', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Specs Section
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Specification', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                              Text('Footing RCC M20', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 1,
                            color: const Color(0xFFEEEEEE),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reinforcement', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                              Text('Bottom mesh Fe550D 10 mm @ 6 in', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 6. Bottom Actions
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primary, 
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 24, offset: const Offset(0, 8))],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Download PDF', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.download, size: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                        ),
                        child: const Icon(Icons.share_outlined, size: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), ), ); }

  Widget _buildMainTab(BuildContext context, String text, bool isActive, String route) {
    return InkWell(
        onTap: isActive ? null : () {
          context.replace(route);
        },
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isActive ? null : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textDark,
            ),
          ),
        ), ); }

  Widget _buildSubTab(BuildContext context, String text, bool isActive, String route) {
    return Expanded(
      child: InkWell(
        onTap: isActive ? null : () => context.replace(route),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
            if (isActive)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 2, color: AppColors.primary),
              ),
          ],
        ), ), ); }

  Widget _buildFilterChip(BuildContext context, String text, bool isActive, String route) {
    return InkWell(
      onTap: isActive ? null : () => context.replace(route),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ), ), ); }
}

class FootingPlanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 120;
    canvas.scale(scale, scale);

    final blackPaint = Paint()..color = AppColors.textDark..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final whiteFill = Paint()..color = Colors.white;
    final dashPaint = Paint()..color = AppColors.border..strokeWidth = 1..style = PaintingStyle.stroke;
    final solidBlackFill = Paint()..color = Colors.black;
    final centerlinePaint = Paint()..color = const Color(0xFF747878)..strokeWidth = 0.75..style = PaintingStyle.stroke;

    // Outer Footing Boundary
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 100, 100), const Radius.circular(2)), whiteFill);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 100, 100), const Radius.circular(2)), blackPaint);

    // Rebar Mesh Grid
    _drawDashedLine(canvas, const Offset(22, 10), const Offset(22, 110), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(38, 10), const Offset(38, 110), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(54, 10), const Offset(54, 110), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(66, 10), const Offset(66, 110), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(82, 10), const Offset(82, 110), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(98, 10), const Offset(98, 110), dashPaint, 2, 2);

    _drawDashedLine(canvas, const Offset(10, 22), const Offset(110, 22), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(10, 38), const Offset(110, 38), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(10, 54), const Offset(110, 54), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(10, 66), const Offset(110, 66), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(10, 82), const Offset(110, 82), dashPaint, 2, 2);
    _drawDashedLine(canvas, const Offset(10, 98), const Offset(110, 98), dashPaint, 2, 2);

    // Central Column Pedestal Boundary
    final pedDashPaint = Paint()..color = AppColors.textDark..strokeWidth = 1.2..style = PaintingStyle.stroke;
    _drawDashedRect(canvas, const Rect.fromLTWH(42, 42, 36, 36), pedDashPaint, 3, 2);

    // Core Column Stub
    canvas.drawRect(const Rect.fromLTWH(48, 48, 24, 24), solidBlackFill);

    // Axis Centerlines
    _drawDashedLine(canvas, const Offset(60, 2), const Offset(60, 118), centerlinePaint, 4, 3);
    _drawDashedLine(canvas, const Offset(2, 60), const Offset(118, 60), centerlinePaint, 4, 3);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint, double dashWidth, double dashSpace) {
    var distance = (p2 - p1).distance;
    var direction = (p2 - p1) / distance;
    double start = 0;
    while (start < distance) {
      double end = start + dashWidth;
      if (end > distance) end = distance;
      canvas.drawLine(p1 + direction * start, p1 + direction * end, paint);
      start += dashWidth + dashSpace;
    }
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint, double dashWidth, double dashSpace) {
    _drawDashedLine(canvas, rect.topLeft, rect.topRight, paint, dashWidth, dashSpace);
    _drawDashedLine(canvas, rect.topRight, rect.bottomRight, paint, dashWidth, dashSpace);
    _drawDashedLine(canvas, rect.bottomRight, rect.bottomLeft, paint, dashWidth, dashSpace);
    _drawDashedLine(canvas, rect.bottomLeft, rect.topLeft, paint, dashWidth, dashSpace);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FootingSectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 120;
    canvas.scale(scale, scale);

    final blackPaint = Paint()..color = AppColors.textDark..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final groundPaint = Paint()..color = const Color(0xFFC4C7C7)..strokeWidth = 1..style = PaintingStyle.stroke;
    final rebarPaint = Paint()..color = Colors.black..strokeWidth = 1.25..style = PaintingStyle.stroke;
    final thickRebarPaint = Paint()..color = Colors.black..strokeWidth = 2..style = PaintingStyle.stroke;
    final pccFill = Paint()..color = AppColors.background;
    final pccStroke = Paint()..color = AppColors.border..strokeWidth = 1..style = PaintingStyle.stroke;
    final whiteFill = Paint()..color = Colors.white;

    // Ground Line
    _drawDashedLine(canvas, const Offset(4, 36), const Offset(116, 36), groundPaint, 3, 3);

    // Column Stem
    canvas.drawLine(const Offset(48, 10), const Offset(48, 52), blackPaint);
    canvas.drawLine(const Offset(72, 10), const Offset(72, 52), blackPaint);

    // Column Longitudinal Rebars
    canvas.drawLine(const Offset(53, 12), const Offset(53, 92), rebarPaint);
    canvas.drawLine(const Offset(67, 12), const Offset(67, 92), rebarPaint);

    // Sloped Footing Profile
    final footingPath = Path()
      ..moveTo(48, 52)
      ..lineTo(14, 78)
      ..lineTo(14, 98)
      ..lineTo(106, 98)
      ..lineTo(106, 78)
      ..lineTo(72, 52)
      ..close();
    canvas.drawPath(footingPath, whiteFill);
    canvas.drawPath(footingPath, blackPaint);

    // Bottom Rebar Mesh
    canvas.drawLine(const Offset(20, 90), const Offset(100, 90), thickRebarPaint);
    canvas.drawLine(const Offset(20, 90), const Offset(20, 82), thickRebarPaint);
    canvas.drawLine(const Offset(100, 90), const Offset(100, 82), thickRebarPaint);

    // Bend Anchors
    canvas.drawLine(const Offset(53, 92), const Offset(42, 92), blackPaint);
    canvas.drawLine(const Offset(67, 92), const Offset(78, 92), blackPaint);

    // PCC Bed
    canvas.drawRect(const Rect.fromLTWH(10, 98, 100, 8), pccFill);
    canvas.drawRect(const Rect.fromLTWH(10, 98, 100, 8), pccStroke);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint, double dashWidth, double dashSpace) {
    var distance = (p2 - p1).distance;
    var direction = (p2 - p1) / distance;
    double start = 0;
    while (start < distance) {
      double end = start + dashWidth;
      if (end > distance) end = distance;
      canvas.drawLine(p1 + direction * start, p1 + direction * end, paint);
      start += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
