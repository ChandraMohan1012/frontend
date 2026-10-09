import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/providers/project_provider.dart';

class ResultCostBoqScreen extends StatefulWidget {
  const ResultCostBoqScreen({super.key});

  @override
  State<ResultCostBoqScreen> createState() => _ResultCostBoqScreenState();
}

class _ResultCostBoqScreenState extends State<ResultCostBoqScreen> {
  int _currentPage = 0;

  final List<Map<String, dynamic>> _stages = [
    {'name': 'Earthwork & Foundation', 'percent': 0.15, 'keywords': ['Excavation']},
    {'name': 'RCC Framing & Columns', 'percent': 0.30, 'keywords': ['Steel', 'Aggregate', 'Cement', 'Sand']},
    {'name': 'Brickwork & Walls', 'percent': 0.18, 'keywords': ['Brick', 'Cement', 'Sand']},
    {'name': 'Plastering & Weathering', 'percent': 0.12, 'keywords': ['Cement', 'Sand']},
    {'name': 'Flooring & Tiling', 'percent': 0.10, 'keywords': ['Tile', 'Cement']},
    {'name': 'Plumbing & Electrical', 'percent': 0.09, 'keywords': ['Electrical', 'Plumbing', 'Pipe']},
    {'name': 'Painting & Handover', 'percent': 0.06, 'keywords': ['Paint', 'Door', 'Window']},
  ];

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();
    final allItems = projectProvider.boqItems ?? [];


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
                child: Builder(
                  builder: (context) {
                    final rawData = projectProvider.rawCostData;
                    
                    double baseCost = 3600000;
                    double costPerSqft = 2250;
                    double totalArea = 1600;
                    
                    if (rawData != null && rawData['estimates'] != null) {
                      String tierKey = 'standard';
                      if (projectProvider.selectedTier == 'Tier 1') tierKey = 'basic';
                      if (projectProvider.selectedTier == 'Tier 3') tierKey = 'premium';
                      
                      baseCost = (rawData['estimates'][tierKey] ?? 3600000).toDouble();
                      costPerSqft = (rawData['cost_per_sqft']?[tierKey] ?? 2250).toDouble();
                      totalArea = (rawData['total_area_sqft'] ?? 1600).toDouble();
                    }
                    
                    if (projectProvider.selectedContractType == 'Labor Only') {
                      baseCost = baseCost * 0.31;
                      costPerSqft = costPerSqft * 0.31;
                    }
                    if (projectProvider.selectedSoil == 'Black Cotton') {
                      baseCost *= 1.05;
                      costPerSqft *= 1.05;
                    } else if (projectProvider.selectedSoil == 'Loose Soil') {
                      baseCost *= 1.08;
                      costPerSqft *= 1.08;
                    }
                    
                    final String formattedCost = '₹${baseCost.round().toString().replaceAllMapped(RegExp(r'(\d{1,2})(?=(\d{2})+(?!\d))'), (m) => '${m[1]},').replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
                    final String formattedRate = '₹${costPerSqft.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Estimated budget', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                            Text(formattedCost, style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.primary, letterSpacing: -0.56, height: 1.15)),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(100)),
                              child: Text('$formattedRate / sq ft · ${totalArea.round()} sq ft', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
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
                    );
                  }
                ),
              ),
              const SizedBox(height: 12),

              // 4. Cost factors row
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    _buildFactorDropdown(context, projectProvider.selectedContractType, ['Turnkey', 'Labor Only'], (val) => projectProvider.setContractType(val)),
                    const SizedBox(width: 8),
                    _buildFactorDropdown(context, projectProvider.selectedTier, ['Tier 1', 'Tier 2', 'Tier 3'], (val) => projectProvider.setTier(val)),
                    const SizedBox(width: 8),
                    _buildFactorDropdown(context, projectProvider.selectedSoil, ['Red Soil', 'Black Cotton', 'Loose Soil'], (val) => projectProvider.setSoil(val)),
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
                        _buildSubTab(context, 'BOQ', true, '/result/cost/boq'),
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
                  child: Builder(
                    builder: (context) {
                      final currentStage = _stages[_currentPage];
                      
                      // Calculate dynamic cost for stage
                      double stageCost = 0;
                      final rawData = projectProvider.rawCostData;
                      if (rawData != null && rawData['estimates'] != null) {
                        String tierKey = 'standard';
                        if (projectProvider.selectedTier == 'Tier 1') tierKey = 'basic';
                        if (projectProvider.selectedTier == 'Tier 3') tierKey = 'premium';
                        double baseCost = (rawData['estimates'][tierKey] ?? 3600000).toDouble();
                        if (projectProvider.selectedContractType == 'Labor Only') {
                          baseCost *= 0.31;
                        }
                        if (projectProvider.selectedSoil == 'Black Cotton') {
                          baseCost *= 1.05;
                        } else if (projectProvider.selectedSoil == 'Loose Soil') {
                          baseCost *= 1.08;
                        }
                        stageCost = baseCost * (currentStage['percent'] as double);
                      } else {
                        stageCost = 3600000 * (currentStage['percent'] as double);
                      }
                      final formattedStageCost = '₹${stageCost.round().toString().replaceAllMapped(RegExp(r'(\d{1,2})(?=(\d{2})+(?!\d))'), (m) => '${m[1]},').replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

                      // Filter items
                      final List<String> keywords = currentStage['keywords'] as List<String>;
                      final items = allItems.where((item) {
                        if (keywords.isEmpty) return false;
                        for (var kw in keywords) {
                          if (item.itemName.toLowerCase().contains(kw.toLowerCase())) return true;
                        }
                        return false;
                      }).toList();

                      // Special multiplier for filtered items to distribute the cost
                      double sum = items.fold(0, (prev, element) => prev + element.total);
                      double multiplier = sum > 0 ? stageCost / sum : 1.0;

                      return Column(
                        children: [
                          // Stage Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Stage ${_currentPage + 1}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                                  Text(currentStage['name'], style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.primary)),
                                ],
                              ),
                              Text(formattedStageCost, style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Table
                          Expanded(
                            child: items.isEmpty
                            ? Center(
                                child: Text(
                                  'No BOQ data available yet.',
                                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textTertiary),
                                ),
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(flex: 40, child: Text('ITEM', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textTertiary))),
                                      Expanded(flex: 18, child: Text('QTY', textAlign: TextAlign.right, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textTertiary))),
                                      Expanded(flex: 18, child: Text('RATE', textAlign: TextAlign.right, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textTertiary))),
                                      Expanded(flex: 24, child: Text('TOTAL', textAlign: TextAlign.right, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textTertiary))),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Container(height: 1, color: AppColors.border),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        final item = items[index];
                                        return _buildTableRow(
                                          item.itemName,
                                          '${(item.quantity * multiplier).toStringAsFixed(0)} ${item.unit}',
                                          '₹${item.rate.toStringAsFixed(0)}',
                                          '₹${(item.total * multiplier).toStringAsFixed(0)}',
                                          index != items.length - 1, // Add border to all but last
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      
                      // Pagination
                      Container(height: 1, color: AppColors.border),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                              child: Icon(Icons.arrow_back, size: 18, color: _currentPage > 0 ? Colors.black : Colors.grey),
                            ),
                          ),
                          Column(
                            children: [
                              Text('${_currentPage + 1} / 7', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(7, (index) {
                                  return Container(
                                    width: 6, 
                                    height: 6, 
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: _currentPage == index ? Colors.black : AppColors.border, 
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _currentPage < 6 ? () => setState(() => _currentPage++) : null,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _currentPage < 6 ? Colors.black : Colors.grey, 
                                shape: BoxShape.circle,
                                boxShadow: const [BoxShadow(color: Color(0x1F0A0A0A), blurRadius: 8, offset: Offset(0, 2))],
                              ),
                              child: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                 }
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

  Widget _buildFactorDropdown(BuildContext context, String currentVal, List<String> options, Function(String) onSelected) {
    return Expanded(
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        offset: const Offset(0, 40),
        itemBuilder: (context) => options.map((String val) => PopupMenuItem(
          value: val,
          child: Text(val, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)),
        )).toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  currentVal,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
            ],
          ),
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
        ), ), ); }

  Widget _buildTableRow(String item, String qty, String rate, String total, bool border) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 40, child: Text(item, style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary))),
            Expanded(flex: 18, child: Text(qty, textAlign: TextAlign.right, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary, fontFeatures: const [FontFeature.tabularFigures()]))),
            Expanded(flex: 18, child: Text(rate, textAlign: TextAlign.right, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary, fontFeatures: const [FontFeature.tabularFigures()]))),
            Expanded(flex: 24, child: Text(total, textAlign: TextAlign.right, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary, fontFeatures: const [FontFeature.tabularFigures()]))),
          ],
        ),
        if (border) ...[
          const SizedBox(height: 8),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
