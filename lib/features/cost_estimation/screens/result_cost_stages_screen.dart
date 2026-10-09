import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ResultCostStagesScreen extends StatelessWidget {
  const ResultCostStagesScreen({super.key});

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
                          Text(projectProvider.currentPlanName ?? 'Plan 05', style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary, letterSpacing: -0.24, height: 1.1), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('Cost report · 40\' × 40\' (1,600 sq ft)', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(color: AppColors.surfaceTertiary, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 20, color: AppColors.primary),
                      ),
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
                      _buildMainTab(context, 'Vastu', false, '/result/vastu/score'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Cost', true, '/result/cost/tiers'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Structure', false, '/result/structure/plan'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Budget Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                        Text('Estimated budget', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                        Text('₹36,00,000', style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.primary, letterSpacing: -0.56, height: 1.15)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(100)),
                          child: Text('₹2,250 / sq ft · 1,600 sq ft', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTagIcon(Icons.architecture, 'Engineer BOQ'),
                        const SizedBox(height: 6),
                        _buildTagIcon(Icons.location_on_outlined, 'Live TN rates'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 4. Cost factors row
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    _buildFactorDropdown('Turnkey'),
                    const SizedBox(width: 8),
                    _buildFactorDropdown('Tier 2'),
                    const SizedBox(width: 8),
                    _buildFactorDropdown('Red Soil'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 5. Sub Tabs
              SizedBox(
                height: 44,
                child: Stack(
                  children: [
                    Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 1, color: AppColors.border)),
                    Row(
                      children: [
                        _buildSubTab(context, 'Tiers', false, '/result/cost/tiers'),
                        _buildSubTab(context, 'Stages', true, '/result/cost/stages'),
                        _buildSubTab(context, 'BOQ', false, '/result/cost/boq'),
                        _buildSubTab(context, 'Materials', false, '/result/cost/search'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 6. Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                          Text('Stage breakdown', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('Material ₹22.3 L · Labor ₹13.7 L', textAlign: TextAlign.right, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Progress Bar
                      Container(
                        height: 10,
                        width: double.infinity,
                        decoration: BoxDecoration(color: AppColors.surfaceTertiary, borderRadius: BorderRadius.circular(100)),
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                          children: [
                            Expanded(flex: 15, child: Container(color: Colors.black)),
                            Expanded(flex: 30, child: Container(color: const Color(0xFF333333))),
                            Expanded(flex: 18, child: Container(color: const Color(0xFF555555))),
                            Expanded(flex: 12, child: Container(color: const Color(0xFF777777))),
                            Expanded(flex: 10, child: Container(color: const Color(0xFF999999))),
                            Expanded(flex: 9, child: Container(color: const Color(0xFFBBBBBB))),
                            Expanded(flex: 6, child: Container(color: AppColors.border)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildStageRow(Colors.black, '1. Earthwork & Foundation', '₹5,40,000', true),
                              _buildStageRow(const Color(0xFF333333), '2. RCC Framing & Columns', '₹10,80,000', true),
                              _buildStageRow(const Color(0xFF555555), '3. Brickwork & Walls', '₹6,48,000', true),
                              _buildStageRow(const Color(0xFF777777), '4. Plastering & Weathering', '₹4,32,000', true),
                              _buildStageRow(const Color(0xFF999999), '5. Flooring & Tiling', '₹3,60,000', true),
                              _buildStageRow(const Color(0xFFBBBBBB), '6. Plumbing & Electrical', '₹3,24,000', true),
                              _buildStageRow(AppColors.border, '7. Painting & Handover', '₹2,16,000', false),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 7. Bottom Actions
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.only(left: 24, right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary, 
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Download PDF', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                              Container(
                                width: 38,
                                height: 38,
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
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.share_outlined, size: 20, color: AppColors.primary),
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
            border: isActive ? null : Border.all(color: AppColors.border),
            boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? Colors.white : AppColors.primary,
            ),
          ),
        ), ); }

  Widget _buildTagIcon(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surfaceTertiary, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildFactorDropdown(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
          ],
        ), ), ); }

  Widget _buildSubTab(BuildContext context, String text, bool isActive, String route) {
    return Expanded(
      child: InkWell(
        onTap: isActive ? null : () => context.replace(route),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.textTertiary,
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

  Widget _buildStageRow(Color color, String name, String price, bool border) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(name, style: GoogleFonts.inter(fontSize: 13, color: AppColors.primary)),
                ],
              ),
              Text(price, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
        ),
        if (border)
          Container(height: 1, color: AppColors.border),
      ],
    );
  }
}
