import 'package:flutter/material.dart';
//import 'package:my_wallet/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../providers/auth_provider.dart';

// Logo component
class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logomw.png',
      width: 115,
      height: 115,
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
        Text(
          'Inicia sesión para continuar',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

// CustomTextField component
class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// Forgot password component
class ForgotPassword extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPassword({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Ajusta el valor horizontal
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: onPressed,
          child: const Text(
            'Contraseña olvidada',
            style: TextStyle(
              color: Color(0xFF04703C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Login button component
class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ElevatedButton(
      onPressed: authProvider.validateCredentials() ? onPressed : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: authProvider.validateCredentials()
            ? const Color(0xFF04703C) // Ensure color is visible when enabled
            : Colors.grey, // Disabled button color
        padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'LOGIN',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// CustomDivider component
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: Color.fromARGB(255, 66, 153, 69), 
        thickness: 5.0,
        indent: 20.0, // Comienza el Divider 20 píxeles desde la izquierda
        endIndent: 5.0,
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('O', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const Expanded(child: Divider(color: Color.fromARGB(255, 66, 153, 69), 
        thickness: 5.0,
        indent: 5.0, // Comienza el Divider 20 píxeles desde la izquierda
        endIndent: 20.0, // Termina el Divider 20 píxeles antes de la derecha
        )),
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
        width: 60, // Ajuste del tamaño de la imagen
        height: 60, // Ajuste del tamaño de la imagen
      ),
      iconSize: 30, // Ajuste del tamaño del IconButton
    );
  }
}

// CustomTextButton component
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.green),
      ),
    );
  }
}

// LoginFields widget
class LoginFields extends StatelessWidget {
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        Padding( // Añade Padding al campo de correo
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0), // Ajusta el valor horizontal
          child: CustomTextField(
            labelText: 'Email',
            onChanged: authProvider.setEmail,
          ),
        ),
        const SizedBox(height: 20),
        Padding( // Añade Padding al campo de contraseña
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Ajusta el valor horizontal
          child: CustomTextField(
            labelText: '🔒︎Contraseña',
            obscureText: true,
            suffixIcon: const Icon(Icons.visibility_off),
            onChanged: authProvider.setPassword,
          ),
        ),
      ],
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
        backgroundColor: const Color(0xFF04703C),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 60),
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
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const LoginFields(),
                      const SizedBox(height: 10),
                      ForgotPassword(onPressed: () {
                        // Add logic for "Forgot Password" action
                      }),
                      const SizedBox(height: 20),
                      LoginButton(onPressed: () async {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        final user = await authProvider.signInWithEmailAndPassword();
                        if (context.mounted && user != null) {
                          if (context.mounted) {
                            context.go('/home'); // Navigate to the home route
                          }
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al iniciar sesión')),
                          );
                        }
                      }),
                      const SizedBox(height: 20),
                      const CustomDivider(),
                      const SizedBox(height: 10),
                      GoogleButton(onPressed: () async {
                        final GoogleSignIn googleSignIn = GoogleSignIn();
                        try {
                          await googleSignIn.signOut(); // Ensure no account is pre-selected
                          final GoogleSignInAccount? account = await googleSignIn.signIn(); // Prompt account selection
                          if (account != null) {
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            final user = await authProvider.signInWithGoogleAccount(account);
                            if (context.mounted && user != null) {
                              context.go('/home'); // Navigate to the home route
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
                      const SizedBox(height: 5),
                      Row( // Usamos Row para separar los textos
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes una cuenta? ',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Texto negro
                          ),
                          TextButton( // Botón solo para "Crear nueva cuenta"
                            onPressed: () {
                              // Navegación a la pantalla de creación de cuenta
                            },
                            child: const Text(
                              'Crear nueva cuenta',
                              style: TextStyle(
                                color: Color(0xFF04703C), // Fixed syntax for color
                                fontWeight: FontWeight.bold,
                              ), // Texto verde
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}