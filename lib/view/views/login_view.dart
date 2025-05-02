import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_wallet/service/provider/auth_provider.dart';

// Logo component
class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logomw.png',
      width: 140,
      height: 140,
    );
  }
}

// Welcome message component
class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Bienvenido',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

// Google button component
class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        'assets/images/google_icon.png',
        width: 90, // Aumentado el tamaño de la imagen
        height: 90, // Aumentado el tamaño de la imagen
      ),
      iconSize: 30,
    );
  }
}

// Main LoginScreen widget
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF04703C), // Verde oscuro
                Color(0xFF66BB6A), // Verde claro
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 250.0, bottom: 190.0),
                child: Column(
                  children: [
                    const Logo(),
                    const WelcomeMessage(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0, // Reducido para que el fondo blanco sea más pequeño
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Inicia sesión con Google ☺️',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GoogleButton(onPressed: () async {
                          final GoogleSignIn googleSignIn = GoogleSignIn();
                          try {
                            await googleSignIn.signOut(); // Ensure no account is pre-selected
                            final GoogleSignInAccount? account = await googleSignIn.signIn(); // Prompt account selection
                            if (account != null) {
                              if (!context.mounted) return;
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              final user = await authProvider.signInWithGoogle();
                              if (context.mounted && user != null) {
                                // Referencia al documento del usuario
                                final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
                                
                                // Verificar si el documento existe
                                final userDoc = await userRef.get();
                                
                                if (!userDoc.exists) {
                                  // Nuevo usuario - crear documento completo
                                  await userRef.set({
                                    'uid': user.uid,
                                    'email': user.email,
                                    'displayName': user.displayName,
                                    'photoURL': user.photoURL,
                                    'createdAt': FieldValue.serverTimestamp(), // Solo se establece en la primera creación
                                    'lastLogin': FieldValue.serverTimestamp(),
                                  });
                                } else {
                                  // Usuario existente - NO actualizar createdAt
                                  await userRef.update({
                                    'lastLogin': FieldValue.serverTimestamp(),
                                    'photoURL': user.photoURL,
                                    'displayName': user.displayName,
                                    'email': user.email,
                                  });
                                }
                                
                                if (context.mounted) {
                                  context.go('/home');
                                }
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error al iniciar sesión con Google')),
                                );
                              }
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No se seleccionó ninguna cuenta')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al iniciar sesión con Google: $e')),
                              );
                            }
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}