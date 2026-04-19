import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/auth_bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/ai_insights/presentation/pages/ai_insights_page.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import 'go_router_refresh_stream.dart';
import '../features/market/presentation/pages/market_page.dart';
import '../features/portfolio/presentation/pages/portfolio_page.dart';
import '../features/market/presentation/pages/coin_detail_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
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
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final bool loggedIn = authState.status == AuthStatus.authenticated;

        // Paths that don't require authentication or redirection yet
        final bool isSplash = state.matchedLocation == '/';
        final bool isAuthPage = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

        // Allow splash screen to finish
        if (isSplash) {
          return null;
        }

        // If not logged in and not on a login/signup page, go to /login
        if (!loggedIn && !isAuthPage) {
          return '/login';
        }

        // If logged in and on a login/signup page, go to /dashboard
        if (loggedIn && isAuthPage) {
          return '/dashboard';
        }

        // No redirection needed
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
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
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/ai-insights',
          builder: (context, state) => const AiInsightsPage(),
        ),
        GoRoute(
          path: '/portfolio',
          builder: (context, state) => const PortfolioPage(),
        ),
      ],
    );
  }
}
