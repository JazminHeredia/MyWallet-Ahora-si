import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../providers/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: const Text('My Wallet'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Acción para agregar
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
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.green),
                  accountName: Text(
                    'Hola, ${user?.displayName ?? "Usuario"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  accountEmail: Text(
                    user?.email ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: user?.photoURL != null 
                      ? NetworkImage(user!.photoURL!) 
                      : null,
                    child: user?.photoURL == null 
                      ? const Icon(Icons.person, size: 40, color: Colors.green)
                      : null,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet, 
                    color: Colors.green,
                  ),
                  title: const Text('Cuentas', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  onTap: () {
                    
                  },
                ),
                ListTile(
                  title: const Text('Opción 1'),
                  onTap: () {
                    // Acción para opción 1
                  },
                ),
              ],
            ),
          ),
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
                  leading: const Icon(Icons.exit_to_app, color: Color.fromARGB(255, 0, 0, 0)),
                  title: const Text('Cerrar sesión', 
                    style: TextStyle(color: Color.fromARGB(255, 4, 121, 22))
                  ),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Cerrar sesión'),
                          content: const Text('¿Está seguro que desea cerrar sesión?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: const Text('Sí, cerrar sesión'),
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
