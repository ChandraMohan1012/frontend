import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultVastuRoomsScreen extends StatelessWidget {
  const ResultVastuRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
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
                          Text(
                            projectProvider.currentPlanName ?? 'Plan 05', 
                            style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.primary, letterSpacing: -0.12, height: 1.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text('Vastu report', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 36,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))],
                                ),
                                child: Text('EN', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                              ),
                              Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                child: Text('தமிழ்', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
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
                  ],
                ),
              ),
              const SizedBox(height: 8),

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
                      _buildMainTab(context, 'Vastu', true, '/result/vastu/score'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Cost', false, '/result/cost/tiers'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Structure', false, '/result/structure/plan'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Sub Tabs
              SizedBox(
                height: 44,
                child: Stack(
                  children: [
                    Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 1, color: AppColors.border)),
                    Row(
                      children: [
                        _buildSubTab(context, 'Score', false, '/result/vastu/score'),
                        _buildSubTab(context, 'Rooms', true, '/result/vastu/rooms'),
                        _buildSubTab(context, 'Fixes', false, '/result/vastu/fixes'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 4. Content Area
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Room audit', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary)),
                          Text('3 of 5 correct', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildRoomRow(context, Icons.chair, 'Living Room', 'North-West', true, true),
                            _buildRoomRow(context, Icons.local_fire_department, 'Kitchen', 'South-East', true, true),
                            _buildRoomRow(context, Icons.bathtub, 'Bathroom', 'North-West', true, true),
                            _buildRoomRow(context, Icons.bed, 'Master Bedroom', 'North-East', false, true),
                            _buildRoomRow(context, Icons.wb_sunny, 'Pooja Room', 'South-East', false, false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 5. Bottom Actions
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
                left: 16,
                right: 16,
                child: Container(height: 2, color: AppColors.primary),
              ),
          ],
        ), ), ); }

  Widget _buildRoomRow(BuildContext context, IconData icon, String title, String subtitle, bool isCorrect, bool border) {
    return InkWell(
      onTap: () {
        _showRoomDetailBottomSheet(context, title, subtitle, isCorrect);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.surfaceSecondary, shape: BoxShape.circle),
                      child: Icon(icon, size: 20, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (isCorrect)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.surfaceSecondary, borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          children: [
                            const Icon(Icons.check, size: 14, color: Colors.black),
                            const SizedBox(width: 4),
                            Text('Correct', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100)),
                        child: Text('Wrong', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
          if (border)
            Container(height: 1, color: AppColors.borderLight),
        ],
      ),
    );
  }

  void _showRoomDetailBottomSheet(BuildContext context, String title, String subtitle, bool isCorrect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          ),
          padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(100))),
              const SizedBox(height: 20),
              
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(title, style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary)),
                          const SizedBox(width: 8),
                          if (!isCorrect)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Text('!', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black, height: 1.0)),
                            )
                          else
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(color: AppColors.surfaceSecondary, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(Icons.check, size: 12, color: Colors.black),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('$subtitle · ${isCorrect ? 'Correct' : 'Wrong'}', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              
              // Analysis List
              Column(
                children: isCorrect
                    ? [
                        _buildAnalysisRow('Perfect Vastu placement'),
                        const SizedBox(height: 14),
                        _buildAnalysisRow('Enhances positive energy'),
                        const SizedBox(height: 14),
                        _buildAnalysisRow('Optimal for well-being'),
                      ]
                    : [
                        _buildAnalysisRow('Severe Vastu violation'),
                        const SizedBox(height: 14),
                        _buildAnalysisRow('Light spiritual zone'),
                        const SizedBox(height: 14),
                        _buildAnalysisRow('Weakens decisions, finances'),
                        const SizedBox(height: 14),
                        _buildAnalysisRow('Causes restlessness'),
                      ],
              ),
              const SizedBox(height: 28),
              
              // Action Button
              InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(color: isCorrect ? Colors.black : AppColors.primary, borderRadius: BorderRadius.circular(100)),
                  alignment: Alignment.center,
                  child: Text('Got it', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalysisRow(String text) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Text(text, style: GoogleFonts.inter(fontSize: 15, color: AppColors.primary)),
      ],
    );
  }
}
