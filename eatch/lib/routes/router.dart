import 'package:go_router/go_router.dart';

import '../pages/authentification/authentification.dart';
import '../pages/dashboard/dashboard_manager.dart';

enum AppRoute {
  authentification,
  home,
}

final goRouter = GoRouter(
  initialLocation: "/",
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: "/",
      name: AppRoute.authentification.name,
      builder: (context, state) => const Authentification(),
    ),
  ],
);
