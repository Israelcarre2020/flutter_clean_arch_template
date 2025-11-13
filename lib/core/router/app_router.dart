import 'package:gist/features/demo/presentation/screens/demo_screen.dart';
import 'package:gist/features/demo/presentation/screens/detail_screen.dart';
import 'package:go_router/go_router.dart';

/// Application routes configuration
class AppRoutes {
  static const String demo = '/';
  static const String detail = '/detail';
}

/// GoRouter configuration for the application
/// Defines all navigation routes and their corresponding screens
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.demo,
    routes: [
      GoRoute(
        path: AppRoutes.demo,
        name: 'demo',
        builder: (context, state) => const DemoScreen(),
      ),
      GoRoute(
        path: AppRoutes.detail,
        name: 'detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return DetailScreen(joke: extra?['joke'] as String?);
        },
      ),
    ],
  );
}
