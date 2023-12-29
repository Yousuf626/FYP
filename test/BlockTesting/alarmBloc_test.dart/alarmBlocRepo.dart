import 'package:aap_dev_project/core/repository/alarm_repo.dart';
import 'package:aap_dev_project/models/alarmz.dart';

List<AlarmInformation> MockData = [
  AlarmInformation(
    name: "John Moc",
    frequency: 1,
    id: "12345",
    isActive: true,
    time: DateTime.now(),
  ),
  AlarmInformation(
    name: "John Doe",
    frequency: 2,
    id: "56789",
    isActive: true,
    time: DateTime.now(),
  ),
  AlarmInformation(
    name: "Moc Doe",
    frequency: 3,
    id: "45678",
    isActive: true,
    time: DateTime.now(),
  ),
];

class MockAlarmRepo implements AlarmRepository {
  @override
  Future<List<AlarmInformation>> getUserAlarms() async {
    return MockData;
  }

  @override
  Future<void> uploadUserAlarm(AlarmInformation uploadedAlarms) async {
    MockData.add(uploadedAlarms);
  }

  @override
  Future<void> deleteUserAlarm(String id) async {
    MockData.removeWhere((element) => element.id == id);
  }
}
