import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisains_mobile/providers/auth_provider.dart';
import 'package:omnisains_mobile/features/auth/login_screen.dart';
import 'package:omnisains_mobile/features/auth/register_screen.dart';
import 'package:omnisains_mobile/features/dashboard/dashboard_screen.dart';
import 'package:omnisains_mobile/features/dashboard/event_detail_screen.dart';
import 'package:omnisains_mobile/features/registration/registration_screen.dart';
import 'package:omnisains_mobile/features/profile/profile_screen.dart';
import 'package:omnisains_mobile/features/privacy/privacy_policy_screen.dart';
import 'package:omnisains_mobile/models/stage.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }
      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/event/:id',
        name: 'eventDetail',
        builder: (context, state) {
          final stage = state.extra as Stage?;
          final stageId = state.pathParameters['id'];
          return EventDetailScreen(stageId: stageId ?? '0', stage: stage);
        },
      ),
      GoRoute(
        path: '/register/:stageId',
        name: 'registerStage',
        builder: (context, state) {
          final stageId = state.pathParameters['stageId'] ?? '0';
          final stage = state.extra as Stage?;
          return RegistrationScreen(stageId: int.tryParse(stageId) ?? 0, stage: stage);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );
});