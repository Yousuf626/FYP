import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/models/user.dart';

UserProfile MockData = UserProfile(
  name: "John Moc",
  email: "auroobaparker@gmail.com",
  image: "https://i.imgur.com/BoN9kdC.png",
  mobile: "1234567890",
  medicalHistory: "No medical history",
  adress: "123, ABC Street, XYZ City",
  age: 20,
  cnic: "1234567890123",
);

class MockUserRepo implements UserRepository {
  @override
  Future<UserProfile> getUser() async {
    return MockData;
  }

  @override
  Future<void> uploadUserRecords(UserProfile uploadedProfile) async {
    MockData = (uploadedProfile);
  }
}
