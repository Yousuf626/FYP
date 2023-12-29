import 'package:aap_dev_project/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> getUser() async {
    User? user = _auth.currentUser;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(user?.uid).get();
    return UserProfile.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> uploadUserRecords(UserProfile userp) async {
    User? user = _auth.currentUser;

    await _firestore.collection('users').doc(user?.uid).set(userp.toJson());
  }
}
