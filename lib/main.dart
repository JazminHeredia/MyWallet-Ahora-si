// Importa los paquetes necesarios de Flutter y otras librerías del proyecto.
import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'package:my_wallet/service/provider/auth_provider.dart'; 
import 'package:provider/provider.dart'; 
import 'package:my_wallet/config/router/app_router.dart'; 
import 'package:my_wallet/config/theme/app_theme.dart'; 
import 'package:my_wallet/model/budget_model.dart';

// Función principal que se ejecuta al iniciar la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que el framework de Flutter esté inicializado antes de ejecutar código asíncrono.
  await Firebase.initializeApp(); // Inicializa Firebase.

  runApp(const MainApp()); // Ejecuta la aplicación llamando al widget raíz 'MainApp'.
}

// Clase principal de la aplicación (widget raíz)
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // MultiProvider permite proporcionar múltiples providers (servicios o estados) a la app.
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Se crea e inyecta el AuthProvider que gestiona la autenticación.
        ChangeNotifierProvider(create: (_) => BudgetModel()), // Se crea e inyecta el BudgetModel que gestiona el presupuesto.
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false, // Elimina la etiqueta de "debug" en la interfaz.
        title: 'My Wallet', // Título de la aplicación.
        theme: appTheme, // Aplica un tema personalizado definido en 'app_theme.dart'.
        routerConfig: appRouter, // Usa configuración de rutas personalizadas definida en 'app_router.dart'.
      ),
    );
  }
}
