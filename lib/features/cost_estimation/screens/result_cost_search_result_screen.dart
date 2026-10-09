import 'package:frontend/core/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/features/cost_estimation/models/boq_item.dart';

class ResultCostSearchResultScreen extends StatefulWidget {
  const ResultCostSearchResultScreen({super.key});

  @override
  State<ResultCostSearchResultScreen> createState() => _ResultCostSearchResultScreenState();
}

class _ResultCostSearchResultScreenState extends State<ResultCostSearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    String numStr = amount.toStringAsFixed(0);
    if (numStr.length <= 3) return '₹$numStr';
    String lastThree = numStr.substring(numStr.length - 3);
    String remaining = numStr.substring(0, numStr.length - 3);
    RegExp reg = RegExp(r'(\d{1,2})(?=(\d{2})+(?!\d))');
    remaining = remaining.replaceAllMapped(reg, (Match m) => '${m[1]},');
    return '₹$remaining,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();
    final allItems = projectProvider.boqItems ?? [];

    bool hasQuery = _searchController.text.trim().isNotEmpty;
    String query = _searchController.text.trim().toLowerCase();

    List<BoqItem> filteredItems = allItems;
    if (hasQuery) {
      filteredItems = allItems.where((item) => item.itemName.toLowerCase().contains(query)).toList();
    }

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Estimated budget', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                          Text('₹36,00,000', style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.primary, letterSpacing: -0.56, height: 1.15)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(100)),
                            child: Text('₹2,250 / sq ft · 1,600 sq ft', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTagIcon('Engineer BOQ'),
                        const SizedBox(height: 6),
                        _buildTagIcon('Live TN rates'),
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
                        _buildSubTab(context, 'Stages', false, '/result/cost/stages'),
                        _buildSubTab(context, 'BOQ', false, '/result/cost/boq'),
                        _buildSubTab(context, 'Materials', true, '/result/cost/search'),
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
                      // Search Input
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) => setState(() {}),
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Search materials...',
                                  hintStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            if (hasQuery)
                              InkWell(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(color: AppColors.border, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 14, color: Colors.black),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Sub-row (AI Match action if no matches)
                      if (hasQuery && filteredItems.isEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('No local match', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                // Add search market prices action here
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(100)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                                    const SizedBox(width: 6),
                                    Text('Search market prices', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Results List
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredItems.isEmpty && hasQuery ? 2 : filteredItems.length,
                          separatorBuilder: (context, index) => Container(height: 1, color: AppColors.borderLight),
                          itemBuilder: (context, index) {
                            if (filteredItems.isEmpty && hasQuery) {
                              if (index == 0) return _buildMaterialRow('${_capitalize(query)} (Estimated)', 'AI matched · ₹500 / unit', true);
                              return _buildMaterialRow('${_capitalize(query)} Premium (Estimated)', 'AI matched · ₹800 / unit', true);
                            }
                            final item = filteredItems[index];
                            return _buildBoqItemRow(item);
                          },
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
                              Flexible(child: Text('Download PDF', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
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
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

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
      ),
    );
  }

  Widget _buildTagIcon(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surfaceTertiary, borderRadius: BorderRadius.circular(100)),
      child: Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.primary)),
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
        ),
      ),
    );
  }

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
        ),
      ),
    );
  }

  Widget _buildMaterialRow(String title, String subtitle, bool isAI) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (isAI)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle),
                    child: const Icon(Icons.auto_awesome, size: 18, color: Colors.black),
                  ),
                if (isAI) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
                      Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Add interaction
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(100), border: Border.all(color: const Color(0xFFC4C7C7))),
              child: Text('Add', style: GoogleFonts.inter(fontSize: 12, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoqItemRow(BoqItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.itemName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
                Text('${item.quantity.toStringAsFixed(0)} ${item.unit} · ${_formatCurrency(item.rate)} / ${item.unit}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(_formatCurrency(item.total), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
        ],
      ),
    );
  }
}
