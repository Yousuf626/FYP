import 'package:aap_dev_project/models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalRecordsRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserReport>> getUserRecords() async {
    User? user = _auth.currentUser;

    DocumentSnapshot snapshot =
        await _firestore.collection('medicalRecords').doc(user?.uid).get();
    if (snapshot.exists) {
      // Assuming 'reports' is the field containing a list of reports in your document
      List<dynamic>? reportData =
          (snapshot.data() as Map<String, dynamic>?)?['records'];
      if (reportData != null) {
        List<UserReport> userReports = reportData
            .map(
                (report) => UserReport.fromJson(report as Map<String, dynamic>))
            .toList();

        return userReports;
      }
    }
    return [];
  }

  Future<List<UserReport>> uploadUserRecords(UserReport uploadedReport) async {
    User? user = _auth.currentUser;

    DocumentSnapshot snapshot =
        await _firestore.collection('medicalRecords').doc(user?.uid).get();
    if (snapshot.exists) {
      List<dynamic>? reportData =
          (snapshot.data() as Map<String, dynamic>?)?['records'];
      List<UserReport> userReports = reportData!
          .map((report) => UserReport.fromJson(report as Map<String, dynamic>))
          .toList();
      userReports.add(uploadedReport);
      await _firestore
          .collection('medicalRecords')
          .doc(user?.uid)
          .update({'records': userReports.map((e) => e.toJson()).toList()});
    }
    return [];
  }
}
