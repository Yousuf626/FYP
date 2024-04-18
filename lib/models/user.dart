class UserProfile {
  final String name;
  final int age;
  final String mobile;
  final String adress;
  final String cnic;
  final String medicalHistory;
  final String email;
  final String image;

  UserProfile(
      {required this.name,
      required this.email,
      required this.image,
      required this.age,
      required this.mobile,
      required this.adress,
      required this.cnic,
      required this.medicalHistory});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      age: json['age'] ?? '',
      mobile: json['mobile'] ?? '',
      adress: json['adress'] ?? '',
      cnic: json['cnic'] ?? '',
      medicalHistory: json['medicalHistory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'age': age,
      'mobile': mobile,
      'adress': adress,
      'cnic': cnic,
      'medicalHistory': medicalHistory,
    };
  }
}
