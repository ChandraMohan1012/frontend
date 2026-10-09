import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultStructure3dFrameScreen extends StatelessWidget {
  const ResultStructure3dFrameScreen({super.key});

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
                        _buildSubTab(context, '3D', true, '/result/structure/3d/frame'),
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
                          _buildFilterChip(context, 'Frame', true, '/result/structure/3d/frame'),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'Slab', false, '/result/structure/3d/slab'),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'Footing', false, '/result/structure/3d/footing'),
                        ],
                      ),
                      
                      // 3D Isometric View Container
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            InteractiveViewer(
                              maxScale: 3,
                              minScale: 0.5,
                              child: Center(
                                child: CustomPaint(
                                  size: const Size(340, 300),
                                  painter: IsometricFramePainter(),
                                ),
                              ),
                            ),
                            // Drag to rotate pill
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.threesixty, size: 16, color: Colors.black),
                                    const SizedBox(width: 4),
                                    Text('Drag to rotate', style: GoogleFonts.inter(fontSize: 12, color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
}

class IsometricFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 340;
    canvas.scale(scale, scale);

    final bgEllipsePaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawOval(const Rect.fromLTWH(80, 222, 180, 48), bgEllipsePaint);

    final dashPaint = Paint()..color = const Color(0xFFE2E2E2)..strokeWidth = 1..style = PaintingStyle.stroke;
    
    // Bottom grid dashed lines
    _drawDashedLine(canvas, const Offset(70, 200), const Offset(170, 248), dashPaint, 3, 3);
    _drawDashedLine(canvas, const Offset(170, 248), const Offset(270, 200), dashPaint, 3, 3);
    _drawDashedLine(canvas, const Offset(270, 200), const Offset(170, 152), dashPaint, 3, 3);
    _drawDashedLine(canvas, const Offset(170, 152), const Offset(70, 200), dashPaint, 3, 3);
    
    _drawDashedLine(canvas, const Offset(120, 176), const Offset(220, 224), dashPaint, 3, 3);
    _drawDashedLine(canvas, const Offset(220, 176), const Offset(120, 224), dashPaint, 3, 3);
    
    final halfOpDash = Paint()..color = const Color(0xFFE2E2E2).withValues(alpha: 0.5)..strokeWidth = 1..style = PaintingStyle.stroke;
    _drawDashedLine(canvas, const Offset(170, 152), const Offset(170, 248), halfOpDash, 3, 3);
    _drawDashedLine(canvas, const Offset(70, 200), const Offset(270, 200), halfOpDash, 3, 3);

    final outline = Paint()..color = const Color(0xFFC4C7C7)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final outlineDash = Paint()..color = const Color(0xFFC4C7C7)..strokeWidth = 1.5..style = PaintingStyle.stroke;

    final p1 = Path()..moveTo(90, 200)..lineTo(170, 238)..lineTo(250, 200)..lineTo(170, 162)..close();
    canvas.drawPath(p1, outline);

    _drawDashedLine(canvas, const Offset(90, 145), const Offset(170, 183), outlineDash, 4, 2);
    _drawDashedLine(canvas, const Offset(170, 183), const Offset(250, 145), outlineDash, 4, 2);
    _drawDashedLine(canvas, const Offset(250, 145), const Offset(170, 107), outlineDash, 4, 2);
    _drawDashedLine(canvas, const Offset(170, 107), const Offset(90, 145), outlineDash, 4, 2);

    final thinBlack = Paint()..color = AppColors.textDark..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final thickBlack = Paint()..color = AppColors.textDark..strokeWidth = 3..strokeCap = StrokeCap.round;
    final veryThickBlack = Paint()..color = Colors.black..strokeWidth = 3.5..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(170, 52), const Offset(170, 162), thinBlack);
    canvas.drawLine(const Offset(90, 90), const Offset(90, 200), thickBlack);
    canvas.drawLine(const Offset(130, 71), const Offset(130, 181), thinBlack);
    canvas.drawLine(const Offset(210, 71), const Offset(210, 181), thinBlack);
    canvas.drawLine(const Offset(250, 90), const Offset(250, 200), thickBlack);
    canvas.drawLine(const Offset(170, 128), const Offset(170, 238), veryThickBlack);

    final blackPoly = Path()..moveTo(90, 90)..lineTo(170, 128)..lineTo(250, 90)..lineTo(170, 52)..close();
    canvas.drawPath(blackPoly, Paint()..color = Colors.black.withValues(alpha: 0.04)..style = PaintingStyle.fill);
    
    final blackOutline = Paint()..color = Colors.black..strokeWidth = 2..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke;
    canvas.drawPath(blackPoly, blackOutline);

    final centerDash = Paint()..color = const Color(0xFF747878)..strokeWidth = 1..style = PaintingStyle.stroke;
    _drawDashedLine(canvas, const Offset(90, 90), const Offset(250, 90), centerDash, 2, 2);
    _drawDashedLine(canvas, const Offset(170, 52), const Offset(170, 128), centerDash, 2, 2);

    // Nodes
    final fillBlack = Paint()..color = Colors.black;
    canvas.drawCircle(const Offset(90, 90), 3.5, fillBlack);
    canvas.drawCircle(const Offset(170, 128), 4, fillBlack);
    canvas.drawCircle(const Offset(250, 90), 3.5, fillBlack);
    canvas.drawCircle(const Offset(170, 52), 3, fillBlack);

    final fill1A = Paint()..color = AppColors.textDark;
    canvas.drawCircle(const Offset(90, 200), 3, fill1A);
    canvas.drawCircle(const Offset(170, 238), 3.5, fillBlack);
    canvas.drawCircle(const Offset(250, 200), 3, fill1A);
    
    canvas.drawCircle(const Offset(170, 162), 2.5, Paint()..color = const Color(0xFF747878));

    // Base Rects
    final rectPaint1 = Paint()..color = const Color(0xFFC4C7C7);
    final rectPaint2 = Paint()..color = const Color(0xFF747878);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(85, 198, 10, 4), const Radius.circular(2)), rectPaint1);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(164, 236, 12, 4), const Radius.circular(2)), rectPaint2);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(245, 198, 10, 4), const Radius.circular(2)), rectPaint1);
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
