import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_wallet/service/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/config/router/app_router.dart';
import 'package:my_wallet/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(); // Inicializa Firebase solo para Android

  runApp(const MainApp());
}

// clase principal de la aplicación
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'My Wallet',
        theme: appTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
