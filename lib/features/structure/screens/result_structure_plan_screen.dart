import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultStructurePlanScreen extends StatelessWidget {
  const ResultStructurePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // Background color in HTML is #f9f9f9
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
                  borderRadius: BorderRadius.circular(8), // HTML uses rounded-lg which is 8px for this one, but other had 28px. The screenshot in HTML has rounded-lg (8px). Let's use 8px.
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
                        _buildSubTab(context, 'Plan', true, '/result/structure/plan'),
                        _buildSubTab(context, '3D', false, '/result/structure/3d/footing'),
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
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Header
                      Text('Beam layout', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text('40\' × 40\' · 1,600 sq ft', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                      
                      // Custom SVG for Beam Layout
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            height: 250,
                            child: CustomPaint(
                              painter: BeamLayoutPainter(),
                            ),
                          ),
                        ),
                      ),
                      
                      // Bottom Legend
                      Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.surfaceSecondary))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(width: 10, height: 10, color: Colors.black),
                                const SizedBox(width: 6),
                                Text('Column', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(width: 16, height: 2, color: Colors.black),
                                const SizedBox(width: 6),
                                Text('Main beam B1', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                              ],
                            ),
                            Row(
                              children: [
                                _buildDashedLine(16),
                                const SizedBox(width: 6),
                                Text('Beam B2', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                              ],
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

  Widget _buildDashedLine(double width) {
    return SizedBox(
      width: width,
      height: 2,
      child: CustomPaint(
        painter: DashedLinePainter(), ), ); }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 3, dashSpace = 3, startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2), Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BeamLayoutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grayPaint = Paint()
      ..color = const Color(0xFF747878)
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;
      
    final blackPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = const Color(0xFF747878)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final fillBlack = Paint()..color = Colors.black;
    final fillWhite = Paint()..color = Colors.white;

    // Dimension lines
    canvas.drawLine(const Offset(38, 16), const Offset(222, 16), grayPaint);
    canvas.drawLine(const Offset(38, 12), const Offset(38, 20), grayPaint);
    canvas.drawLine(const Offset(222, 12), const Offset(222, 20), grayPaint);
    
    _drawText(canvas, "40' - 0\"", const Offset(130, 2), 10, AppColors.textSecondary);

    canvas.drawLine(const Offset(16, 38), const Offset(16, 222), grayPaint);
    canvas.drawLine(const Offset(12, 38), const Offset(20, 38), grayPaint);
    canvas.drawLine(const Offset(12, 222), const Offset(20, 222), grayPaint);
    
    canvas.save();
    canvas.translate(8, 133);
    canvas.rotate(-1.5708); // -90 degrees in radians
    _drawText(canvas, "40' - 0\"", const Offset(0, 0), 10, AppColors.textSecondary);
    canvas.restore();

    // Outer Boundary
    canvas.drawRect(const Rect.fromLTWH(38, 38, 184, 184), blackPaint);

    // Main Beams
    canvas.drawLine(const Offset(38, 130), const Offset(222, 130), blackPaint);
    canvas.drawLine(const Offset(130, 38), const Offset(130, 222), blackPaint);

    // Secondary Beams (Dashed)
    _drawDashed(canvas, const Offset(38, 84), const Offset(130, 84), dashPaint);
    _drawDashed(canvas, const Offset(130, 84), const Offset(222, 84), dashPaint);
    _drawDashed(canvas, const Offset(38, 176), const Offset(130, 176), dashPaint);
    _drawDashed(canvas, const Offset(130, 176), const Offset(222, 176), dashPaint);

    _drawDashed(canvas, const Offset(84, 38), const Offset(84, 130), dashPaint);
    _drawDashed(canvas, const Offset(176, 38), const Offset(176, 130), dashPaint);
    _drawDashed(canvas, const Offset(84, 130), const Offset(84, 222), dashPaint);
    _drawDashed(canvas, const Offset(176, 130), const Offset(176, 222), dashPaint);

    // Beam Labels
    _drawLabel(canvas, "B1", const Rect.fromLTWH(79, 123, 14, 14), fillWhite, Colors.black, 8, const Offset(86, 126));
    _drawLabel(canvas, "B1", const Rect.fromLTWH(171, 123, 14, 14), fillWhite, Colors.black, 8, const Offset(178, 126));
    _drawLabel(canvas, "B1", const Rect.fromLTWH(123, 77, 14, 14), fillWhite, Colors.black, 8, const Offset(130, 80));
    _drawLabel(canvas, "B1", const Rect.fromLTWH(123, 169, 14, 14), fillWhite, Colors.black, 8, const Offset(130, 172));

    _drawLabel(canvas, "B2", const Rect.fromLTWH(78, 78, 13, 12), fillWhite, const Color(0xFF747878), 7.5, const Offset(84.5, 80));
    _drawLabel(canvas, "B2", const Rect.fromLTWH(170, 78, 13, 12), fillWhite, const Color(0xFF747878), 7.5, const Offset(176.5, 80));

    // Columns
    final cols = [33, 125, 217];
    for (int x in cols) {
      for (int y in cols) {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x.toDouble(), y.toDouble(), 10, 10), const Radius.circular(1)), fillBlack);
      }
    }
  }
  
  void _drawLabel(Canvas canvas, String text, Rect bgRect, Paint bgPaint, Color textColor, double fontSize, Offset textOffset) {
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(2)), bgPaint);
    _drawText(canvas, text, textOffset, fontSize, textColor, fontWeight: FontWeight.w600);
  }

  void _drawText(Canvas canvas, String text, Offset position, double fontSize, Color color, {FontWeight fontWeight = FontWeight.w500}) {
    final textSpan = TextSpan(
      text: text,
      style: GoogleFonts.inter(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(position.dx - textPainter.width / 2, position.dy));
  }

  void _drawDashed(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 3, dashSpace = 3;
    final distance = (p2 - p1).distance;
    final direction = (p2 - p1) / distance;
    double start = 0;
    while (start < distance) {
      final end = (start + dashWidth < distance) ? start + dashWidth : distance;
      canvas.drawLine(p1 + direction * start, p1 + direction * end, paint);
      start += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
