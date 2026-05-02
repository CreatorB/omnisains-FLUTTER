import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omnisains_mobile/api/auth_repository.dart';
import 'package:omnisains_mobile/models/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  static const _tokenKey = 'auth_token';

  AuthNotifier(this._repository) : super(AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null && token.isNotEmpty) {
        _repository.api.setAuthToken(token);
        final user = await _repository.getCurrentUser();
        if (user != null) {
          state = AuthState(status: AuthStatus.authenticated, user: user);
          return;
        }
      }
      state = AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, 'authenticated');
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register({
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
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.register(
        email: email,
        fullName: fullName,
        schoolName: schoolName,
        phone: phone,
        gender: gender,
        password: password,
        province: province,
        city: city,
        district: district,
        village: village,
        address: address,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, 'authenticated');
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});