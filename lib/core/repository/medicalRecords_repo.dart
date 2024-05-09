import 'dart:convert';

import 'package:aap_dev_project/models/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;


import '../../nodeBackend/jwtStorage.dart';
import '../../nodeBackend/upload_medical_record.dart';

class MedicalRecordsRepository {

  Future<List<MedicalRecord>> getUserRecords() async {
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
        final List<dynamic> data = jsonDecode(response.body);
        final List<MedicalRecord> records = [];
       
        for (final item in data) {
           records.add(MedicalRecord.fromJson(item));
        }
        // html.File test;
        // for (final item in records) {
        //   final blob = html.Blob([data]);
        //   test = html.File([blob], item.filename, {'type': item.contentType});
        //   print(test);
        //   record2.add(UserReport(type: item.filename, image: test));
        // }

        return records;
      } else {
        throw Exception('Failed to fetch medical records');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> uploadUserRecords(UserReport uploadedReport) async {
    await uploadMedicalRecord(uploadedReport);
    
  }
}

class UtilMedicalRecord {
  final List<dynamic> records;

  UtilMedicalRecord({required this.records});

  factory UtilMedicalRecord.fromJson(Map<String, dynamic> json) {
    return UtilMedicalRecord(records: json['records']);
  }
}
