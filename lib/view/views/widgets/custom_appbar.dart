import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:my_wallet/service/provider/auth_provider.dart';
import 'package:my_wallet/providers/theme_provider.dart';
import 'package:my_wallet/config/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorOptions = AppColors.colorOptions;
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Row(
        children: [
          const Text('My Wallet'),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.wb_sunny // sunny icon
                  : Icons.dark_mode, // moon icon
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme(colorOptions: colorOptions);
            },
            tooltip: themeProvider.isDarkMode ? 'Modo claro' : 'Modo oscuro',
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
           context.go('/transaction'); 
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                  height: 110,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.photoURL != null 
                          ? NetworkImage(user!.photoURL!) 
                          : null,
                        child: user?.photoURL == null 
                          ? Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary)
                          : null,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user?.displayName ?? "Usuario",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Inicio', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el drawer
                    context.go('/home');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Categorías', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el drawer
                    context.go('/categories'); // Navegar a la vista de categorías
                  },
                ),
                ListTile(
                  leading: Icon(Icons.trending_up, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Tendencia de gastos', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  onTap: () {
                   Navigator.pop(context);
                   context.go('/expense_trends'); // Navegar a la vista de tendencias de gastos
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Alertas', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/budget'); // Navegar a la vista de alertas
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Personalizar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el drawer
                    context.go('/personalize'); // Navegar a la vista de personalización
                  },
                ),
              ],
            ),
          ),

          // ignore: avoid_unnecessary_containers
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey)
                  )
                ),
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Cerrar sesión', 
                    style: TextStyle(color: Color.fromARGB(255, 4, 121, 22))
                  ),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          
                          content: const Text('¿Cerrar la sesión de tu cuenta?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: const Text('Cerrar sesión'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true && context.mounted) {
                      // Cerrar sesión usando el AuthProvider
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.signOut();
                      
                      if (context.mounted) {
                        context.go('/login'); // Usar go_router para navegar al login
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}