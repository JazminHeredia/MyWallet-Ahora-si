import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/view/views_list.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: '/',
    name: 'LoginScreen',
    builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/home',
    name: 'HomeView',
    builder: (BuildContext context, GoRouterState state) => const HomeView(),
  ),
];