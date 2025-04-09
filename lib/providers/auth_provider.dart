import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;

  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notify widgets that depend on this state
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  bool validateCredentials() {
    return _email.isNotEmpty && _password.isNotEmpty;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  void setSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }

  Future<User?> registerWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Guardar usuario en Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'displayName': userCredential.user!.displayName ?? '',
          'photoURL': userCredential.user!.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } catch (e) {
      // ignore: avoid_print
      print('Error during registration: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Actualizar último inicio de sesión
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return userCredential.user;
    } catch (e) {
      // ignore: avoid_print
      print('Error during email/password login: $e');
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    if (_isSigningIn) return null; // Prevent concurrent sign-in attempts
    setSigningIn(true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn(); // Always prompt user
      if (googleUser == null) {
        // User canceled the sign-in
        setSigningIn(false);
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Guardar o actualizar usuario en Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'displayName': userCredential.user!.displayName ?? '',
          'photoURL': userCredential.user!.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(), // Solo se establece en la primera creación
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return userCredential.user;
    } catch (e) {
      // ignore: avoid_print
      print('Error during Google Sign-In: $e');
      return null;
    } finally {
      setSigningIn(false);
    }
  }

  Future<User?> signInWithGoogleAccount(GoogleSignInAccount account) async {
    if (_isSigningIn) return null; // Prevent concurrent sign-in attempts
    setSigningIn(true);

    try {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      // ignore: avoid_print
      print('Error during Google sign-in: $e');
      return null;
    } finally {
      setSigningIn(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut(); // Ensure Google Sign-Out
    } catch (e) {
      // ignore: avoid_print
      print('Error during sign-out: $e');
    }
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<void> saveUserToDatabase(String userId, String email) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('users');
      await userCollection.doc(userId).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error saving user to database: $e');
    }
  }

  String? getCurrentUserId() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      // ignore: avoid_print
      print('Error: No hay un usuario autenticado.');
      return null;
    }
    // ignore: avoid_print
    print('UID del usuario autenticado: ${user.uid}');
    return user.uid;
  }

  bool isUserAuthenticated() {
    final isAuthenticated = _firebaseAuth.currentUser != null;
    // ignore: avoid_print
    print('Usuario autenticado: $isAuthenticated');
    return isAuthenticated;
  }
}