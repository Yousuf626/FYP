import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_block.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_event.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_state.dart';
import 'package:aap_dev_project/models/report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'reportBlockRepo.dart';

void main() {
  group('Search repo bloc test', () {
    late MedicalRecordsBloc recordsBloc;
    late MockMedicalRecordsRepo mockRepo;

    setUp(() {
      mockRepo = MockMedicalRecordsRepo();
      recordsBloc = MedicalRecordsBloc(recordsRepository: mockRepo);
    });

    tearDown(() {
      recordsBloc.close();
    });

    blocTest<MedicalRecordsBloc, RecordState>(
      'emits [RecordLoading, RecordLoaded] with specific UserReport instances when FetchRecord event is added',
      build: () => recordsBloc,
      act: (bloc) => bloc.add(const FetchRecord(userid: '123')),
      expect: () => [
        RecordLoading(),
        isA<RecordLoaded>()
            .having((state) => state.records.length, 'records length', 3)
            .having((state) => state.records[0], 'first record',
                isInstanceOf<UserReport>())
            .having((state) => state.records[1], 'second record',
                isInstanceOf<UserReport>())
            .having((state) => state.records[2], 'third record',
                isInstanceOf<UserReport>()),
      ],
    );

    blocTest<MedicalRecordsBloc, RecordState>(
      'emits [AlarmLoading, AlarmLoaded] after adding a new alarm',
      build: () => recordsBloc,
      act: (bloc) {
        bloc.add(SetRecord(
            report: UserReport(
          type: "Test Report",
          image:
              'https://firebasestorage.googleapis.com/v0/b/medqr-3e1ce.appspot.com/o/oq1wkiepfd767kr1iu4ynf50n9neo8f66yflczt3vnjpzyqlf0?alt=media&token=6e64eb22-2762-47ac-a2e7-9818667c7026',
          createdAt: "28/12/2023",
        )));
      },
      expect: () => [
        RecordSetting(),
        isA<RecordSetSuccess>()
            .having((state) => state.records.length, 'records length', 4)
            .having(
                (state) => state.records[3].type, 'Report Type', 'Test Report')
            .having(
              (state) => state.records[3].image,
              'Report Image',
              'https://firebasestorage.googleapis.com/v0/b/medqr-3e1ce.appspot.com/o/oq1wkiepfd767kr1iu4ynf50n9neo8f66yflczt3vnjpzyqlf0?alt=media&token=6e64eb22-2762-47ac-a2e7-9818667c7026',
            )
            .having(
              (state) => state.records[3].createdAt,
              'Report Date',
              '28/12/2023',
            ),
      ],
    );
  });
}
