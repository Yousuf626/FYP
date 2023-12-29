import 'package:aap_dev_project/bloc/recordShare/recordShare_block.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_event.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_states.dart';
import 'package:aap_dev_project/models/userSharing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'shareBlocRepo.dart';

void main() {
  group('Search repo bloc test', () {
    late RecordShareBloc recordsBloc;
    late MockRecordsSharingRepo mockRepo;

    setUp(() {
      mockRepo = MockRecordsSharingRepo();
      recordsBloc = RecordShareBloc(recordsRepository: mockRepo);
    });

    tearDown(() {
      recordsBloc.close();
    });

    blocTest<RecordShareBloc, RecordState>(
      'emits [RecordLoading, RecordLoaded] with specific UserReport instances when FetchRecord event is added',
      build: () => recordsBloc,
      act: (bloc) => bloc.add(FetchRecord()),
      expect: () => [
        RecordLoading(),
        isA<RecordLoaded>()
            .having((state) => state.records.length, 'records length', 3)
            .having((state) => state.records[0], 'first record',
                isInstanceOf<UserSharing>())
            .having((state) => state.records[1], 'second record',
                isInstanceOf<UserSharing>())
            .having((state) => state.records[2], 'third record',
                isInstanceOf<UserSharing>()),
      ],
    );

    blocTest<RecordShareBloc, RecordState>(
      'emits [RecordLoading, RecordLoaded] after adding a user to shared records',
      build: () => recordsBloc,
      act: (bloc) => bloc.add(AddRecord(code: "67890")),
      expect: () => [
        RecordSetting(),
        isA<RecordSetSuccess>()
            .having((state) => state.records.length, 'records length', 4)
      ],
    );
  });
}
