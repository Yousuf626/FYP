class UserSharing {
  final String code;
  final String userid;

  UserSharing({
    required this.code,
    required this.userid,
  });

  factory UserSharing.fromJson(Map<String, dynamic> json) {
    return UserSharing(
      code: json['code'] ?? '',
      userid: json['userid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'userid': userid,
    };
  }
}
