import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_wallet/model/login_model.dart';

class FirestoreService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(UserModel userModel) async {
    await usersCollection.doc(userModel.uid).set(userModel.toMap(), SetOptions(merge: true));
  }
}
