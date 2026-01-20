
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';
import '../state/app_state.dart';

class BackendService {
  // Login et récupération du profil
  static Future<void> testLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.backendUrl}/users/auth/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ApiConfig.jwtToken = data['access'];
        // On pourrait stocker ici le nom de l'utilisateur s'il est renvoyé
        // AppState.userName = data['user']['username'];
      }
    } catch (e) {
      print("Login Error: $e");
    }
  }

  // Récupération et injection des données capteurs
  static Future<void> testEnvironment(double lat, double lon) async {
    if (ApiConfig.jwtToken == null) return;
    
    final headers = {
      "Authorization": "Bearer ${ApiConfig.jwtToken}",
      "Content-Type": "application/json"
    };

    try {
      // 1. Appel Météo
      final weatherRes = await http.get(
        Uri.parse("${ApiConfig.backendUrl}/environment/weather/?lat=$lat&lon=$lon"),
        headers: headers
      );

      // 2. Appel Qualité de l'Air
      final airRes = await http.get(
        Uri.parse("${ApiConfig.backendUrl}/environment/air-quality/?lat=$lat&lon=$lon"),
        headers: headers
      );

      if (weatherRes.statusCode == 200 && airRes.statusCode == 200) {
        final weatherData = jsonDecode(weatherRes.body);
        final airData = jsonDecode(airRes.body);
        
        // CRUCIAL : On met à jour l'état global de l'application
        AppState.setEnvironmentData(weatherData, airData);
        print("DIAGNOSTIC: AppState mis à jour avec les données de Render.");
      }
    } catch (e) {
      print("Environment Sync Error: $e");
    }
  }
}
