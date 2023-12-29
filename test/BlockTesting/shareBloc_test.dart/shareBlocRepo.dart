import 'package:aap_dev_project/core/repository/recordsSharing_repo.dart';
import 'package:aap_dev_project/models/userSharing.dart';

List<UserSharing> MockData = [
  UserSharing(
    name: "John Moc",
    code: "12345",
    userid: "123456709",
  ),
  UserSharing(
    name: "John Doe",
    code: "56789",
    userid: "123456789",
  ),
  UserSharing(
    name: "Moc Doe",
    code: "45678",
    userid: "123496789",
  ),
];

class MockRecordsSharingRepo implements RecordsSharingRepository {
  @override
  Future<List<UserSharing>> getSharedRecords() async {
    return MockData;
  }

  @override
  Future<List<UserSharing>> removerUserFromShared() async {
    return [];
  }

  @override
  Future<List<UserSharing>> addUserToShared(String code) async {
    MockData.add(
        UserSharing(code: code, userid: "7387893479832", name: "Aurooba"));
    return MockData;
  }
}
