import 'package:aap_dev_project/core/repository/medicalRecords_repo.dart';
import 'package:aap_dev_project/models/report.dart';

List<UserReport> MockData = [
  UserReport(
      type: "Blood Pressure",
      image:
          'https://firebasestorage.googleapis.com/v0/b/medqr-3e1ce.appspot.com/o/oq1wkiepfd767kr1iu4ynf50n9neo8f66yflczt3vnjpzyqlf0?alt=media&token=6e64eb22-2762-47ac-a2e7-9818667c7026',
      createdAt: "28/12/2023"),
  UserReport(
      type: "Diabetes",
      image:
          'https://firebasestorage.googleapis.com/v0/b/medqr-3e1ce.appspot.com/o/oq1wkiepfd767kr1iu4ynf50n9neo8f66yflczt3vnjpzyqlf0?alt=media&token=6e64eb22-2762-47ac-a2e7-9818667c7026',
      createdAt: "12/12/2023"),
  UserReport(
      type: "Blood",
      image:
          'https://firebasestorage.googleapis.com/v0/b/medqr-3e1ce.appspot.com/o/oq1wkiepfd767kr1iu4ynf50n9neo8f66yflczt3vnjpzyqlf0?alt=media&token=6e64eb22-2762-47ac-a2e7-9818667c7026',
      createdAt: "28/10/2023"),
];

class MockMedicalRecordsRepo implements MedicalRecordsRepository {
  @override
  Future<List<UserReport>> getUserRecords(String userid) async {
    return MockData;
  }

  @override
  Future<List<UserReport>> uploadUserRecords(UserReport uploadedReport) async {
    MockData.add(uploadedReport);
    return MockData;
  }
}
