import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_wallet/service/firestore_service.dart';
import 'package:my_wallet/model/login_model.dart'; // Importa el modelo que contiene los datos del usuario

class AuthProvider with ChangeNotifier {
  // Instancia de FirebaseAuth para manejar la autenticación con Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Variable que controla si el usuario está en proceso de login
  bool _isSigningIn = false;

  // Getter para saber si el usuario está en proceso de login
  bool get isSigningIn => _isSigningIn;

  // Setter para cambiar el estado de _isSigningIn y notificar a los oyentes
  void setSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners(); // Notifica a los listeners (por ejemplo, widgets) que el estado ha cambiado
  }

  // Función para iniciar sesión con Google
  Future<User?> signInWithGoogle() async {
    // Si ya está en proceso de login, no dejamos que inicie otro
    if (_isSigningIn) return null;
    
    setSigningIn(true); // Cambia el estado a "en proceso de login"

    try {
      // Inicia el proceso de autenticación con Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Si el usuario cancela el proceso de login, retorna null
      if (googleUser == null) {
        setSigningIn(false); // Cambia el estado a "no está en login"
        return null; // Si el usuario cancela el login
      }

      // Obtiene los tokens de autenticación de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Realiza el login con las credenciales obtenidas
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Si el login es exitoso y se obtiene un usuario
      if (userCredential.user != null) {
        // Creamos un modelo de usuario con la información que obtenemos
        final userModel = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName ?? '',
          photoURL: userCredential.user!.photoURL ?? '',
        );

        // Guardamos el usuario en Firestore para tener la información en la base de datos
        await FirestoreService().saveUser(userModel);
      }

      // Retorna el usuario autenticado
      return userCredential.user;
    } catch (e) {
      // Si ocurre un error, lo mostramos
      // ignore: avoid_print
      print('Error during Google Sign-In: $e');
      return null; // En caso de error, retornamos null
    } finally {
      // En cualquier caso, después de terminar, cambia el estado a "no está en login"
      setSigningIn(false);
    }
  }

  // Función para cerrar sesión de Firebase y Google
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut(); // Cierra sesión de Firebase
      await GoogleSignIn().signOut(); // Cierra sesión de Google
    } catch (e) {
      // Si ocurre un error al cerrar sesión, lo mostramos
      // ignore: avoid_print
      print('Error during sign-out: $e');
    }
  }

  // Getter que devuelve el usuario actual autenticado
  User? get currentUser => _firebaseAuth.currentUser;
}
