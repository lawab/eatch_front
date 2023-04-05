import 'package:go_router/go_router.dart';

import '../pages/dashboard/dashboard_manager.dart';

enum AppRoute {
  home,
}

final goRouter = GoRouter(
  initialLocation: "/",
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: "/",
      name: AppRoute.home.name,
      builder: (context, state) => const DashboardManager(),
    ),
  ],
);
