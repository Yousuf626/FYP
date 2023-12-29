import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_block.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_event.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_states.dart';
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
      act: (bloc) => bloc.add(FetchRecord(userid: '123')),
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
  });
}
