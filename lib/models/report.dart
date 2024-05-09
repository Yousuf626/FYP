
import 'dart:io';
import 'dart:typed_data';
class MedicalRecord {
  final String filename;
  final String contentType;
  final DateTime uploadDate;
  final int length;
  final Uint8List data;

  MedicalRecord({
    required this.filename,
    required this.contentType,
    required this.uploadDate,
    required this.length,
    required this.data,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      filename: json['filename'],
      contentType: json['contentType'],
      uploadDate: DateTime.parse(json['uploadDate']),
      length: json['length'],
      data: Uint8List.fromList((json['data']['data'] as List).map((dynamic item) => item as int).toList()));
  }
}

class UserReport {
  final String type;
   File image;


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


class UserReport2 {
  final String type;
  Uint8List image;


  UserReport2({
    required this.type,
    required this.image,
 
  });

  factory UserReport2.fromJson(Map<String, dynamic> json) {
    return UserReport2(
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
