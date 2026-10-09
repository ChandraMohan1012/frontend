import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/providers/project_provider.dart';

class ProcessingScreen extends StatefulWidget {
  final Map<String, String>? fileData;
  const ProcessingScreen({super.key, this.fileData});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startProcessing();
    });
  }

  Future<void> _startProcessing() async {
    final provider = context.read<ProjectProvider>();
    final path = widget.fileData?['path'] ?? '';
    final name = widget.fileData?['name'] ?? 'house_plan.pdf';
    
    await provider.processFloorPlan(path, name);
    
    if (mounted) {
      context.replace('/result/3d_model');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // 1. Top Title Block
              Padding(
                padding: const EdgeInsets.only(top: 36.0, bottom: 4.0),
                child: Column(
                  children: [
                    Text(
                      'Processing',
                      style: GoogleFonts.syne(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        letterSpacing: -0.52,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Please wait',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Main Processing Visual & Steps
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  children: [
                    // Hero Card
                    Container(
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Image with scanning line
                          SizedBox(
                            height: 152,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCbrPXkeFNHttKCb5WziIuFNrc5qd6W0CP_aHhMGal4a9PjLXbbW_XK2OVlPKhOOIYCpIlUXeyS9YWa8C7oS-bJQi1Z2Po04gZCeagAb92XlGPaaM0xKYfSLR5Fm1JLS11rRQVSiz2S4Q2RU1fIxmEAaemf4KH4SKFMk1u6NsORYEJhsZoTOgb6T-jL7SH2qWSloCzM4e7SC3YqV5dvKy6igEcG9rL-TQ4294_ReqlC',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => const Icon(Icons.architecture, size: 80, color: AppColors.border),
                                ),
                                // Scanning guide line
                                Container(
                                  height: 1.5,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.primary.withValues(alpha: 0.6),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Percentage
                          Text(
                            '62%',
                            style: GoogleFonts.syne(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              letterSpacing: -0.32,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Progress Bar
                          Container(
                            width: 240,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1DFDF),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 0.62,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 14),
                    
                    // Step List Card
                    Container(
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        children: [
                          _buildStep(title: 'Reading walls', status: 'completed'),
                          const Divider(height: 1, thickness: 1, color: AppColors.border),
                          _buildStep(title: 'Building 3D', status: 'completed'),
                          const Divider(height: 1, thickness: 1, color: AppColors.border),
                          _buildStep(title: 'Vastu check', status: 'active'),
                          const Divider(height: 1, thickness: 1, color: AppColors.border),
                          _buildStep(title: 'Cost estimate', status: 'pending'),
                          const Divider(height: 1, thickness: 1, color: AppColors.border),
                          _buildStep(title: 'Structure check', status: 'pending'),
                        ],
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

  Widget _buildStep({required String title, required String status}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (status == 'completed')
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 13, color: Colors.white),
                )
              else if (status == 'active')
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE1DFDF),
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: status == 'active' ? FontWeight.w600 : (status == 'completed' ? FontWeight.w500 : FontWeight.w400),
                  color: status == 'pending' ? AppColors.textSecondary : AppColors.primary,
                ),
              ),
            ],
          ),
          if (status == 'completed')
            const Icon(Icons.done, size: 17, color: AppColors.primary)
          else if (status == 'active')
            Text('Now', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
