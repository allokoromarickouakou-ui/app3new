
import '../api/api_client.dart';
import '../api/api_config.dart';
import '../state/app_state.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient _client = ApiClient();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _client.dio.post('/users/auth/login/', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final access = response.data['access'];
        final refresh = response.data['refresh'];
        
        await StorageService.saveTokens(access, refresh);
        ApiConfig.jwtToken = access;

        // EXTRACTION RÉELLE DU PROFIL DEPUIS LE BACKEND
        if (response.data['user'] != null) {
          AppState.userName = response.data['user']['username'] ?? email.split('@')[0];
          // On récupère le profile_type réel (patient, prevention, ou remission)
          AppState.profileType = response.data['user']['profile_type'] ?? "patient";
          AppState.hideCrises = (AppState.profileType != "patient");
        } else {
          AppState.userName = email.split('@')[0];
        }
        
        return true;
      }
      return false;
    } catch (e) {
      print("Auth Error: $e");
      return false;
    }
  }
}
