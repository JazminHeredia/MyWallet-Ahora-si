import 'package:go_router/go_router.dart';
import 'package:my_wallet/view/views_list.dart';
import 'package:my_wallet/view/views/personalize_view.dart';

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
  GoRoute(
    path: '/expense_trends',
    name: 'Expense_trends',
    builder: (context, state) => ExpenseTrends(),
  ),
  GoRoute(
    path: '/categories',
    name: 'CategoriesView',
    builder: (context, state) => CreateCategoryView(),
  ),
  GoRoute(
    path: '/login',
    name: 'LoginView',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: '/personalize',
    name: 'PersonalizeView',
    builder: (context, state) => const PersonalizeView(),
  ),
];