import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  final Dio _dio;

  static const String stagingBaseUrl = 'https://dev-api.omnisains.id/api/v1';
  static const String productionBaseUrl = 'https://omnisains.id/api/v1';

  ApiClient({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? stagingBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Dio get dio => _dio;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    final response = await _dio.post(path, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    final response = await _dio.put(path, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete(path);
    return response.data as Map<String, dynamic>;
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});