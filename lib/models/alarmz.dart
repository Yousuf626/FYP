import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmInformation {
  final String id;
  final String name;
  final DateTime time;
  final bool isActive;

  AlarmInformation({
    required this.id,
    required this.name,
    required this.time,
    required this.isActive,
  });

  factory AlarmInformation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AlarmInformation(
      id: doc.id,
      name: data['name'] ?? '',
      time: (data['time'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'time': Timestamp.fromDate(time),
      'isActive': isActive,
    };
  }

  factory AlarmInformation.fromJson(Map<String, dynamic> json) {
    return AlarmInformation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      time: DateTime.parse(json['time']),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time.toIso8601String(),
      'isActive': isActive,
    };
  }
}
