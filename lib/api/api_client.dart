
import 'package:dio/dio.dart';
import '../services/storage_service.dart';
import 'api_config.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.backendUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshToken = await StorageService.getRefreshToken();
          if (refreshToken != null) {
            try {
              // On utilise une nouvelle instance Dio pour éviter les boucles infinies
              final refreshResponse = await Dio().post(
                '${ApiConfig.backendUrl}/users/auth/refresh/',
                data: {'refresh': refreshToken},
              );
              
              final newAccess = refreshResponse.data['access'];
              final newRefresh = refreshResponse.data['refresh'];
              await StorageService.saveTokens(newAccess, newRefresh);

              // On met à jour l'en-tête et on relance la requête originale
              error.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
              final response = await dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              await StorageService.clearAll();
              // Ici, on pourrait rediriger vers la page de login
            }
          }
        }
        return handler.next(error);
      },
    ));
  }
}
