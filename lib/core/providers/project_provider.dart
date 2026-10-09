import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/features/vastu/models/vastu_score.dart';
import 'package:frontend/features/cost_estimation/models/boq_item.dart';
import 'package:frontend/core/network/kanavu_api_service.dart';

class ProjectProvider extends ChangeNotifier {
  final KanavuApiService _apiService = KanavuApiService();

  bool _isLoading = false;
  String? _error;
  
  VastuScore? _vastuScore;
  List<BoqItem>? _boqItems;
  Map<String, dynamic>? _rawCostData;
  String? _currentPlanName;
  PlatformFile? _selectedFile;

  // Dropdown states
  String _selectedContractType = 'Turnkey';
  String _selectedTier = 'Tier 2';
  String _selectedSoil = 'Red Soil';

  bool get isLoading => _isLoading;
  String? get error => _error;
  VastuScore? get vastuScore => _vastuScore;
  List<BoqItem>? get boqItems => _boqItems;
  Map<String, dynamic>? get rawCostData => _rawCostData;
  String? get currentPlanName => _currentPlanName;
  
  String get selectedContractType => _selectedContractType;
  String get selectedTier => _selectedTier;
  String get selectedSoil => _selectedSoil;

  void setSelectedFile(PlatformFile file) {
    _selectedFile = file;
    _currentPlanName = file.name;
    notifyListeners();
  }

  void setContractType(String type) {
    _selectedContractType = type;
    notifyListeners();
  }

  void setTier(String tier) {
    _selectedTier = tier;
    notifyListeners();
  }

  void setSoil(String soil) {
    _selectedSoil = soil;
    notifyListeners();
  }

  Future<void> processFloorPlan(String filePath, String fileName) async {
    _isLoading = true;
    _error = null;
    _currentPlanName = fileName;
    notifyListeners();

    try {
      // 1. Upload the blueprint image to the backend
      String? planId;
      if (_selectedFile != null) {
        planId = await _apiService.uploadBlueprintFile(_selectedFile!);
      } else {
        planId = await _apiService.uploadBlueprint(filePath);
      }
      
      if (planId == null) {
        throw Exception("Failed to upload blueprint. Please check server.");
      }

      // 2. Fetch the dynamically processed ML data
      _vastuScore = await _apiService.getVastuScore(planId);
      _rawCostData = await _apiService.getRawCostData(planId);
      _boqItems = await _apiService.getBoq(planId);
      
    } catch (e) {
      _error = "Failed to process floor plan: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _vastuScore = null;
    _boqItems = null;
    _rawCostData = null;
    _currentPlanName = null;
    _error = null;
    _selectedContractType = 'Turnkey';
    _selectedTier = 'Tier 2';
    _selectedSoil = 'Red Soil';
    notifyListeners();
  }
}
