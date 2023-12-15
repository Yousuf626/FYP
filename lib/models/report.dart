class UserReport {
  final String type;
  final String image;
  final String? createdAt;

  UserReport({
    required this.type,
    required this.image,
    this.createdAt,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = json['time'].toDate();
    return UserReport(
        type: json['type'] ?? '',
        image: json['image'] ?? '',
        createdAt: '${dateTime.year}/${dateTime.month}/${dateTime.day}');
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      'createdAt': createdAt,
    };
  }
}
