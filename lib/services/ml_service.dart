
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';

class MLService {
  // POST /api/v1/predict
  static Future<void> testPredict(Map<String, dynamic> patientData) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.mlUrl}/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(patientData),
      );
      print("--- TEST ML PREDICT ---");
      print("Status: ${response.statusCode}");
      print("ML Result: ${response.body}");
    } catch (e) {
      print("ML Predict API Error: $e");
    }
  }

  // GET /api/v1/dashboard
  static Future<void> testDashboard(String userId) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.mlUrl}/dashboard?user_id=$userId"),
      );
      print("--- TEST ML DASHBOARD ---");
      print("Status: ${response.statusCode}");
      print("Dashboard Data: ${response.body}");
    } catch (e) {
      print("ML Dashboard API Error: $e");
    }
  }

  // POST /api/v1/predict/realtime
  static Future<void> testRealtimePredict(Map<String, dynamic> sensorData) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.mlUrl}/predict/realtime"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(sensorData),
      );
      print("--- TEST ML REALTIME ---");
      print("Status: ${response.statusCode}");
      print("Realtime Result: ${response.body}");
    } catch (e) {
      print("ML Realtime API Error: $e");
    }
  }
}
