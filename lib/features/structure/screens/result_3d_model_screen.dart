import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Result3dModelScreen extends StatelessWidget {
  const Result3dModelScreen({super.key});

  Widget _buildMainTab(BuildContext context, String text, bool isActive, String route) {
    return InkWell(
      onTap: isActive ? null : () => context.replace(route),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: isActive ? null : [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
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
      ),
    );
  }

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
              // 1. HEADER
              SizedBox(
                height: 44,
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
                      onTap: () {
                        context.replace('/home');
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceSecondary, // secondary-fixed
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: AppColors.primary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. MAIN TABS
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildMainTab(context, '3D', true, '/result/3d_model'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Vastu', false, '/result/vastu/score'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Cost', false, '/result/cost/tiers'),
                      const SizedBox(width: 8),
                      _buildMainTab(context, 'Structure', false, '/result/structure/plan'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. CONTENT CARD
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Image
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCiqfYn3fLr_7qSmG6Gdn4Bw03nKtdP_aRs6wYsKj1hUzJo5FjyDnBu0Z9b0JCIAl5d0_S-u_NHJMxqguUlXo2ndBv5ilg2xqCGrxkj2HiaxnBa9P0ubXSqr2nCmSrX8IaZDqYjinbeeeS7-0VEc_GSUEYOSyEDyyZlPIJmFYjery_yCOa_8R4n1Q86nEvUzjpNvNj0bNYEr_b7MaIxJHN2nU6NFUCd7wCoDOT0T6t9',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Drag to rotate Pill
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.threesixty, size: 16, color: Colors.black),
                              const SizedBox(width: 4),
                              Text(
                                'Drag to rotate',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // AR Icon
                      const Positioned(
                        top: 16,
                        right: 16,
                        child: Icon(Icons.view_in_ar, size: 18, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 4. STATS ROW
              Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('1,600', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary, height: 1.0)),
                          const SizedBox(height: 4),
                          Text('Sq ft', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.0)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 32, color: AppColors.borderLight),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('3 BHK', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary, height: 1.0)),
                          const SizedBox(height: 4),
                          Text('Rooms', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.0)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 32, color: AppColors.borderLight),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary, height: 1.0)),
                          const SizedBox(height: 4),
                          Text('Floors', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.0)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 5. ACTIONS
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Sleek black to match
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 28),
                            Text(
                              'Download PDF',
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.download_rounded, color: Colors.black, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.border, width: 1.5),
                          ),
                          child: const Center(
                            child: Icon(Icons.share_outlined, color: Colors.black, size: 20),
                          ),
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
    );
  }
}
