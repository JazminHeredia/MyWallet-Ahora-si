import 'package:go_router/go_router.dart';
import 'package:my_wallet/config/router/list_router.dart';

final GoRouter appRouter = GoRouter(
  routes: routes,
   initialLocation: '/',
   debugLogDiagnostics: true,
);