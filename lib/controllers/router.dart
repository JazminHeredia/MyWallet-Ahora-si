//import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/login/login_view.dart';
import '../views/home/home_view.dart';
import '../views/transaction/transaction.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionView(),
      )
    ],
  );
}
