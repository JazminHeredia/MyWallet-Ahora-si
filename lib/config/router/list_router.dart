//import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/view/views_list.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: '/',
    name: 'LoginScreen',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: '/home',
    name: 'HomeView',
    builder: (context, state) => HomeView(),
  ),
  GoRoute(
    path: '/transaction',
    name: 'TransactionView',
    builder: (context, state) => TransactionView(),
  ),
  GoRoute(
    path: '/budget',
    name: 'BudgetView',
    builder: (context, state) => BudgetView(),
  ),
];