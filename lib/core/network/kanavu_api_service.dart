import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:frontend/features/vastu/models/vastu_score.dart';
import 'package:frontend/features/cost_estimation/models/boq_item.dart';

class KanavuApiService {
  // Assuming local backend. Use 10.0.2.2 for Android Emulator, localhost for iOS/Web/Windows.
  static const String baseUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000/api');

  Future<VastuScore> getVastuScore(String planId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vastu/$planId')).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Sometimes backend wraps it in { success: true, data: {...} }
        final scoreData = data['data'] ?? data;
        return VastuScore.fromJson(scoreData);
      } else {
        throw Exception('Failed to load Vastu score. Status code: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('[KanavuApiService] getVastuScore Error: $e', name: 'API');
      // Fallback to mock data for development if the server is unreachable
      return VastuScore.mock();
    }
  }

  Future<Map<String, dynamic>> getRawCostData(String planId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cost/$planId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ground'] ?? data;
      }
    } catch (e) {
      developer.log('[KanavuApiService] getRawCostData Error: $e', name: 'API');
    }
    return {};
  }

  Future<List<BoqItem>> getBoq(String planId) async {
    try {
      final costData = await getRawCostData(planId);
      
      if (costData.isNotEmpty && costData.containsKey('materials')) {
        final materialsMap = costData['materials'] as Map<String, dynamic>;
        List<BoqItem> items = [];
        materialsMap.forEach((key, val) {
          items.add(BoqItem(
            category: 'Materials',
            itemName: val['name'] ?? key,
            quantity: (val['quantity'] ?? 0).toDouble(),
            unit: val['unit'] ?? '-',
            rate: (val['price'] ?? 0).toDouble(),
            total: ((val['quantity'] ?? 0) * (val['price'] ?? 0)).toDouble(),
          ));
        });
        if (items.isNotEmpty) return items;
      }
      
      throw Exception('Failed to load BOQ or BOQ was empty.');
    } catch (e) {
      developer.log('[KanavuApiService] getBoq Error: $e', name: 'API');
      // Fallback to mock data for development if the server is unreachable
      return [
        BoqItem.mock('Foundation', 'Excavation', 1500, 'Cu.ft', 12.0),
        BoqItem.mock('Foundation', 'Concrete', 500, 'Cu.ft', 110.0),
        BoqItem.mock('Framing', 'Steel TMT', 3.5, 'Ton', 65000.0),
        BoqItem.mock('Framing', 'Bricks', 25000, 'Nos', 9.0),
      ];
    }
  }
  
  // Future method for uploading blueprint image
  Future<String?> uploadBlueprint(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      request.files.add(await http.MultipartFile.fromPath('ground_plan', imagePath));
      
      var streamedResponse = await request.send().timeout(const Duration(minutes: 2));
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['project_id'] ?? data['id'];
      }
    } catch (e) {
      developer.log('[KanavuApiService] uploadBlueprint Error: $e', name: 'API');
    }
    return null;
  }

  // Web-compatible upload method
  Future<String?> uploadBlueprintFile(PlatformFile file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      
      if (kIsWeb && file.bytes != null) {
        request.files.add(http.MultipartFile.fromBytes('ground_plan', file.bytes!, filename: file.name));
      } else if (file.path != null) {
        request.files.add(await http.MultipartFile.fromPath('ground_plan', file.path!));
      } else {
        throw Exception("No valid file data found (both bytes and path are null)");
      }
      
      var streamedResponse = await request.send().timeout(const Duration(minutes: 2));
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['project_id'] ?? data['id'];
      }
    } catch (e) {
      developer.log('[KanavuApiService] uploadBlueprintFile Error: $e', name: 'API');
    }
    return null;
  }
}
