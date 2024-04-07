import 'dart:convert';

import 'package:aap_dev_project/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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

  Future<UserProfile?> registerUser(name,email,password,mobilenumber) async {

    try {
      var response1 = await http.post(
        Uri.parse('http://localhost:3000/api/patients/signup'), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": name,
"email":email,
"password":password,
 "mobileNumber": mobilenumber
}),
      );
     print(response1.body);

      if (response1.statusCode == 200) {
        print(response1.body);
      } else {
        throw Exception('Failed to activate quizzes');
      }

    } catch (e) {
      // Handle errors here
    }
  }
  }

  // Future<void> uploadUserRecords(UserProfile userp) async {
  //   User? user = _auth.currentUser;

  //   await _firestore.collection('users').doc(user?.uid).set(userp.toJson());
  // }
