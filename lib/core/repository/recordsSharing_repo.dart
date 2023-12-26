import 'package:aap_dev_project/models/userSharing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecordsSharingRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserSharing>> getSharedRecords() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('recordSharing').doc('efg').get();
    if (snapshot.exists) {
      List<dynamic>? sharedData =
          (snapshot.data() as Map<String, dynamic>?)?['currentlySharing'];
      if (sharedData != null) {
        List<UserSharing> userRecords = sharedData
            .map((record) =>
                UserSharing.fromJson(record as Map<String, dynamic>))
            .toList();

        return userRecords;
      }
    }
    return [];
  }

  Future<List<UserSharing>> removerUserFromShared() async {
    User? user = _auth.currentUser;

    DocumentSnapshot snapshot =
        await _firestore.collection('recordSharing').doc('efg').get();
    if (snapshot.exists) {
      List<dynamic>? sharedData =
          (snapshot.data() as Map<String, dynamic>?)?['currentlySharing'];
      List<UserSharing> userRecords = sharedData!
          .map((records) =>
              UserSharing.fromJson(records as Map<String, dynamic>))
          .toList();
      userRecords.removeWhere((users) => users.userid == user?.uid);
      await _firestore.collection('recordSharing').doc('efg').update(
          {'currentlySharing': userRecords.map((e) => e.toJson()).toList()});
    }
    return [];
  }
}
