import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisains_mobile/api/api_client.dart';
import 'package:omnisains_mobile/models/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  ApiClient get api => _api;

  Future<User> login(String email, String password) async {
    final response = await _api.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    if (response['profile'] != null) {
      return User.fromJson(response['profile']);
    }
    throw Exception('Login failed: invalid response');
  }

  Future<User> register({
    required String email,
    required String fullName,
    required String schoolName,
    required String phone,
    required String gender,
    required String password,
    required String province,
    required String city,
    required String district,
    required String village,
    required String address,
  }) async {
    final response = await _api.post('/auth/register', data: {
      'email': email,
      'fullName': fullName,
      'schoolName': schoolName,
      'phone': phone,
      'gender': gender,
      'password': password,
      'province': province,
      'city': city,
      'district': district,
      'village': village,
      'address': address,
    });

    if (response['profile'] != null) {
      return User.fromJson(response['profile']);
    }
    throw Exception('Registration failed: invalid response');
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _api.get('/participants/me');
      return User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _api.post('/auth/logout', data: {});
  }
}