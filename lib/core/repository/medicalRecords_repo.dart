import 'dart:convert';

import 'package:aap_dev_project/models/report.dart';
import 'package:http/http.dart' as http;

import '../../nodeBackend/jwtStorage.dart';
import '../../nodeBackend/upload_medical_record.dart';

class MedicalRecordsRepository {
  // Future<List<UserReport>> getUserRecords() async {
    // User? user = _auth.currentUser;

    // DocumentSnapshot snapshot = await _firestore
    //     .collection('medicalRecords')
    //     .doc(userid != '' ? userid : user?.uid)
    //     .get();
    // if (snapshot.exists) {

    //   List<dynamic>? reportData =
    //       (snapshot.data() as Map<String, dynamic>?)?['records'];
    //   if (reportData != null) {
    //     List<UserReport> userReports = reportData
    //         .map(
    //             (report) => UserReport.fromJson(report as Map<String, dynamic>))
    //         .toList();

    //     return userReports;
    //   }
    // }
    // return [];
//     try {
//       // Retrieve the JWT token
//       String? token = await retrieveJwtToken();

//       if (token == null) {
//         print('JWT token not found');
//         return [];
//       }

//       final response = await http.get(
//         Uri.parse('http://localhost:3000/api/medical-records/patient'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         List<dynamic>? test;
//         var records = jsonDecode(response.body);

// // Check if 'records' is not null before converting
//         if (records != null) {
//           test = UtilMedicalRecord.fromJson(records) as List<dynamic>?;
//           List<UserReport> userReports = test!
//             .map(
//                 (report) => UserReport.fromJson(report as Map<String, dynamic>))
//             .toList();

//         return userReports;
//         }
//         return [];
        
//       } else {
//         print('Failed to load medical records: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error: $e');
//       return [];
//     }
//   }
Future<List<UserReport>> getUserRecords() async {
    try {
      // Retrieve the JWT token
      String? token = await retrieveJwtToken();

      if (token == null) {
        print('JWT token not found');
        return [];
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/medical-records/patient'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var records = jsonDecode(response.body) as List<dynamic>;

        List<UserReport> userReports = records
            .map((record) => UserReport.fromJson(record as Map<String, dynamic>))
            .toList();

        return userReports;
      } else {
        print('Failed to load medical records: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }


  Future<void> uploadUserRecords(UserReport uploadedReport) async {
    await uploadMedicalRecord(uploadedReport);
    //in this function i need to return the list of update UserReports.
    //I need to fetch all the userReports based on LogedIn userID. Then i will append this report to that report and return the new array of reports

    // final token = retrieveJwtToken();

    // User? user = _auth.currentUser;

    // DocumentSnapshot snapshot =
    //     await _firestore.collection('medicalRecords').doc(user?.uid).get();
    // if (snapshot.exists) {
    //   List<dynamic>? reportData =
    //       (snapshot.data() as Map<String, dynamic>?)?['records'];
    //   print(reportData?.length);
    //   List<UserReport> userReports = reportData!
    //       .map((report) => UserReport.fromJson(report as Map<String, dynamic>))
    //       .toList();
    //   userReports.add(uploadedReport);
    //   print(userReports.length);
    //   await _firestore
    //       .collection('medicalRecords')
    //       .doc(user?.uid)
    //       .update({'records': userReports.map((e) => e.toJson()).toList()});
    //   return userReports;
    // } else {
    //   await _firestore.collection('medicalRecords').doc(user?.uid).set({
    //     'records': [uploadedReport.toJson()]
    //   });
    //   return [uploadedReport];
  }
}

class UtilMedicalRecord {
  final List<dynamic> records;

  UtilMedicalRecord({required this.records});

  factory UtilMedicalRecord.fromJson(Map<String, dynamic> json) {
    return UtilMedicalRecord(records: json['records']);
  }
}
