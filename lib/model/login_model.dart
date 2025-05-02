import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
  });

  // Para convertir el modelo a un mapa
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
