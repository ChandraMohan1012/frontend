import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultStructure3dSlabScreen extends StatelessWidget {
  const ResultStructure3dSlabScreen({super.key});

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
                        _buildSubTab(context, '3D', true, '/result/structure/3d/slab'),
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
                          _buildFilterChip(context, 'Slab', true, '/result/structure/3d/slab'),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'Footing', false, '/result/structure/3d/footing'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // 3D Slab View Container
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: CustomPaint(
                              size: const Size(310, 160),
                              painter: SlabSectionPainter(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Specification Rows
                      Column(
                        children: [
                          _buildSpecRow('Slab thickness 5 in', 'T125', true),
                          _buildSpecRow('Cranked bars at 45°', 'L / 4', true),
                          _buildSpecRow('Main steel 8 mm @ 6 in', 'Fe550D', false),
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
        onTap: isActive ? null : () => context.replace(route),
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

  Widget _buildSpecRow(String title, String value, bool border) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: border ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)),
            ],
          ),
          Text(value, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class SlabSectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 310;
    canvas.scale(scale, scale);

    final blackPaint = Paint()..color = Colors.black..strokeWidth = 1.5..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke;
    final thickBlack = Paint()..color = Colors.black..strokeWidth = 2..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke;
    final grayDash = Paint()..color = AppColors.textSecondary..strokeWidth = 1.2..style = PaintingStyle.stroke;
    final lightFill = Paint()..color = const Color(0xFFEEEEEE);
    
    // Custom Hatch pattern substitute (diagonal lines)
    _drawHatch(canvas, const Rect.fromLTWH(18, 58, 46, 68));
    _drawHatch(canvas, const Rect.fromLTWH(246, 58, 46, 68));

    // Left Support Wall lines
    canvas.drawLine(const Offset(18, 58), const Offset(64, 58), blackPaint);
    canvas.drawLine(const Offset(64, 58), const Offset(64, 126), blackPaint);

    // Right Support Wall lines
    canvas.drawLine(const Offset(246, 58), const Offset(292, 58), blackPaint);
    canvas.drawLine(const Offset(246, 58), const Offset(246, 126), blackPaint);

    // Slab Concrete Profile
    final slabPath = Path()
      ..moveTo(18, 26)..lineTo(292, 26)..lineTo(292, 58)..lineTo(246, 58)
      ..lineTo(246, 62)..lineTo(64, 62)..lineTo(64, 58)..lineTo(18, 58)..close();
    canvas.drawPath(slabPath, lightFill);
    canvas.drawPath(slabPath, blackPaint);

    // Cranked Main Bar
    final crankPath = Path()
      ..moveTo(28, 34)..lineTo(56, 34)..lineTo(84, 54)..lineTo(226, 54)..lineTo(254, 34)..lineTo(282, 34);
    canvas.drawPath(crankPath, thickBlack);

    // Straight Bottom Reinforcement Layer
    _drawDashedLine(canvas, const Offset(28, 55), const Offset(282, 55), grayDash, 3, 3);

    // Transverse Bars (dots)
    final dotPaint = Paint()..color = Colors.black;
    final xs = [95, 118, 141, 164, 187, 210];
    for (var x in xs) {
      canvas.drawCircle(Offset(x.toDouble(), 54), 2.2, dotPaint);
    }
    canvas.drawCircle(const Offset(36, 34), 2.2, dotPaint);
    canvas.drawCircle(const Offset(48, 34), 2.2, dotPaint);
    canvas.drawCircle(const Offset(262, 34), 2.2, dotPaint);
    canvas.drawCircle(const Offset(274, 34), 2.2, dotPaint);

    // Slab Thickness Dimension
    final dimPaint = Paint()..color = AppColors.textSecondary..strokeWidth = 1..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(12, 26), const Offset(12, 58), dimPaint);
    canvas.drawLine(const Offset(9, 26), const Offset(15, 26), dimPaint);
    canvas.drawLine(const Offset(9, 58), const Offset(15, 58), dimPaint);
    
    _drawText(canvas, "125 mm slab", const Offset(12, 16), 9, Colors.black, fontWeight: FontWeight.w600);
    
    // Annotation Leader: Clear cover
    final leaderPaint = Paint()..color = const Color(0xFF747878)..strokeWidth = 0.8..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(32, 18), const Offset(14, 24), leaderPaint);
    
    _drawText(canvas, "Clear cover 15 mm", const Offset(176, 80), 9, AppColors.textSecondary, fontWeight: FontWeight.w500);
    final leaderPath = Path()..moveTo(172, 78)..lineTo(150, 78)..lineTo(144, 60);
    canvas.drawPath(leaderPath, leaderPaint);
    canvas.drawCircle(const Offset(144, 60), 1.5, dotPaint);

    // 45 deg angle marker
    _drawText(canvas, "45°", const Offset(66, 44), 8, const Color(0xFF747878), fontWeight: FontWeight.w600);
    canvas.drawArc(const Rect.fromLTWH(69, 44, 12, 12), 3.14 / 4, 3.14 / 4, false, leaderPaint);

    // Span Indicator
    final spanDash = Paint()..color = const Color(0xFFC4C7C7)..strokeWidth = 1..style = PaintingStyle.stroke;
    _drawDashedLine(canvas, const Offset(64, 104), const Offset(246, 104), spanDash, 2, 2);
    canvas.drawLine(const Offset(64, 98), const Offset(64, 110), leaderPaint);
    canvas.drawLine(const Offset(246, 98), const Offset(246, 110), leaderPaint);
    
    _drawTextCenter(canvas, "L/4 = 750 mm", const Offset(140, 118), 9, AppColors.textSecondary, fontWeight: FontWeight.w500);
  }
  
  void _drawHatch(Canvas canvas, Rect rect) {
    canvas.save();
    canvas.clipRect(rect);
    final hatchPaint = Paint()..color = const Color(0xFFC4C7C7)..strokeWidth = 1.2..style = PaintingStyle.stroke;
    for (double i = -100; i < 400; i += 6) {
      canvas.drawLine(Offset(i, 0), Offset(i + 100, 100), hatchPaint);
    }
    // Outline for hatch rect
    canvas.drawRect(rect, Paint()..color = AppColors.textSecondary..strokeWidth = 1.2..style = PaintingStyle.stroke);
    canvas.restore();
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

  void _drawText(Canvas canvas, String text, Offset position, double fontSize, Color color, {FontWeight fontWeight = FontWeight.w500}) {
    final textSpan = TextSpan(
      text: text,
      style: GoogleFonts.inter(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }
  
  void _drawTextCenter(Canvas canvas, String text, Offset position, double fontSize, Color color, {FontWeight fontWeight = FontWeight.w500}) {
    final textSpan = TextSpan(
      text: text,
      style: GoogleFonts.inter(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
