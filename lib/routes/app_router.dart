import 'package:go_router/go_router.dart';
import '../features/auth/presentation/auth_bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final bool loggedIn = authState.status == AuthStatus.authenticated;
        final bool isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

        // If not logged in and not on a login/signup page, go to /login
        if (!loggedIn && !isLoggingIn) {
          return '/login';
        }

        // If logged in and on a login/signup page, go to /dashboard
        if (loggedIn && isLoggingIn) {
          return '/dashboard';
        }

        // No redirection needed
        return null;
      },
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
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    );
  }
}
