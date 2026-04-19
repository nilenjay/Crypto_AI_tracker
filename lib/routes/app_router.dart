import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/market/presentation/pages/market_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/market',
        builder: (context, state) => const MarketPage(),
      ),
      GoRoute(
        path: '/coin-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CoinDetailPage(coin: extra?['coin']);
        },
      ),
    ],
  );
}
