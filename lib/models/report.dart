// class UserReport {
//   final String type;
//   final String image;
//   final String? createdAt;

//   UserReport({
//     required this.type,
//     required this.image,
//     this.createdAt,
//   });

//   factory UserReport.fromJson(Map<String, dynamic> json) {
//     return UserReport(
//         type: json['type'] ?? '',
//         image: json['image'] ?? '',
//         createdAt: json['createdAt'] ?? '');
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'image': image,
//       'createdAt': createdAt,
//     };
//   }
// }
import 'dart:html' as html;

class MedicalRecord {
  final String patientId;
  final List<UserReport> records;

  MedicalRecord({
    required this.patientId,
    required this.records,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      patientId: json['patient'] ?? '',
      records: (json['records'] as List<dynamic>)
          .map((report) => UserReport.fromJson(report))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'records': records.map((report) => report.toJson()).toList(),
    };
  }
}

class Report_for_backend {
  final String filename;
  final String contentType;
  final DateTime uploadDate;
  final int length;
  final String data;

  Report_for_backend({
    required this.filename,
    required this.contentType,
    required this.uploadDate,
    required this.length,
    required this.data,
  });

  factory Report_for_backend.fromJson(Map<String, dynamic> json) {
    return Report_for_backend(
      filename: json['filename'] ?? '',
      contentType: json['contentType'] ?? '',
      uploadDate: DateTime.parse(json['uploadDate'] ?? ''),
      length: json['length'] ?? 0,
      data: json['data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'contentType': contentType,
      'uploadDate': uploadDate.toIso8601String(),
      'length': length,
      'data': data,
    };
  }
}
class UserReport {
  final String type;
  final html.File image;


  UserReport({
    required this.type,
    required this.image,
 
  });

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
        type: json['type'] ?? '',
        image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      
    };
  }
}