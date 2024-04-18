class UserSharing {
  final String code;
  final String userid;
  final String name;

  UserSharing({
    required this.code,
    required this.userid,
    required this.name,
  });

  factory UserSharing.fromJson(Map<String, dynamic> json) {
    return UserSharing(
      code: json['code'] ?? '',
      userid: json['userid'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'userid': userid,
      'name': name,
    };
  }
}
