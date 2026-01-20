
class AppState {
  static bool hideCrises = false;
  static String userName = "Utilisateur";
  static String profileType = "patient";

  // Données Capteurs
  static double temperature = 28.0;
  static int humidity = 65;
  static int aqi = 32;
  static String aqiLevel = "BON";
  static double pm25 = 12.0;
  static int heartRate = 68;
  static int spo2 = 98;

  // Données IA & Historique (Dynamiques)
  static int crisesThisMonth = 0;
  static int daysWithoutCrisis = 0;
  static List<String> aiPatterns = [];
  static List<Map<String, dynamic>> crisisHistory = [];

  static void setEnvironmentData(Map<String, dynamic> weatherData, Map<String, dynamic> airData) {
    if (weatherData['results'] != null && weatherData['results'].isNotEmpty) {
      final latest = weatherData['results'].last;
      temperature = latest['temperature']?.toDouble() ?? temperature;
      humidity = latest['humidity']?.toInt() ?? humidity;
    }
    if (airData['results'] != null && airData['results'].isNotEmpty) {
      final latest = airData['results'].last;
      aqi = latest['aqi']?.toInt() ?? aqi;
      aqiLevel = latest['aqi_level'] ?? aqiLevel;
      pm25 = latest['pm25']?.toDouble() ?? pm25;
    }
  }

  // Injection des données analytiques de l'IA
  static void setAIDashboardData(Map<String, dynamic> data) {
    crisesThisMonth = data['crises_this_month'] ?? 0;
    daysWithoutCrisis = data['days_without_crisis'] ?? 0;
    aiPatterns = List<String>.from(data['patterns'] ?? []);
    crisisHistory = List<Map<String, dynamic>>.from(data['history'] ?? []);
  }
}
