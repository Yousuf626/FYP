import 'package:aap_dev_project/bloc/alarm/alarm_bloc.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_event.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_state.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_states.dart';
import 'package:aap_dev_project/models/alarmz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'alarmBlocRepo.dart';

void main() {
  group('Search repo bloc test', () {
    late AlarmBloc alarmBloc;
    late MockAlarmRepo mockRepo;

    setUp(() {
      mockRepo = MockAlarmRepo();
      alarmBloc = AlarmBloc(alarmRepository: mockRepo);
    });

    tearDown(() {
      alarmBloc.close();
    });

    blocTest<AlarmBloc, AlarmState>(
      'emits [RecordLoading, RecordLoaded] with specific UserReport instances when FetchRecord event is added',
      build: () => alarmBloc,
      act: (bloc) => bloc.add(FetchAlarm()),
      expect: () => [
        AlarmLoading(),
        isA<AlarmLoaded>()
            .having((state) => state.alarms.length, 'records length', 3)
            .having((state) => state.alarms[0], 'first record',
                isInstanceOf<AlarmInformation>())
            .having((state) => state.alarms[1], 'second record',
                isInstanceOf<AlarmInformation>())
            .having((state) => state.alarms[2], 'third record',
                isInstanceOf<AlarmInformation>()),
      ],
    );

    blocTest<AlarmBloc, AlarmState>(
      'emits [AlarmLoading, AlarmLoaded] after adding a new alarm',
      build: () => alarmBloc,
      act: (bloc) {
        bloc.add(SetAlarm(AlarmInformation(
          name: "Test Alarm",
          frequency: 1,
          id: "99999",
          isActive: true,
          time: DateTime.now(),
        )));
      },
      expect: () => [
        AlarmSetting(),
        isA<AlarmSetSuccess>()
            .having((state) => state.alarms.length, 'records length', 4)
            .having(
                (state) => state.alarms[3].id, 'newly added alarm id', '99999')
            .having((state) => state.alarms[3].name, 'newly added alarm name',
                'Test Alarm'),
      ],
    );

    blocTest<AlarmBloc, AlarmState>(
      'emits [AlarmLoading, AlarmLoaded] without deleting when the alarm ID does not exist',
      build: () => alarmBloc,
      act: (bloc) {
        bloc.add(DeleteAlarm(alarmId: "45678"));
      },
      expect: () => [
        AlarmDeleting(),
        isA<AlarmDeletedSuccess>()
            .having((state) => state.alarms.length, 'records length', 2)
            .having((state) => state.alarms.any((alarm) => alarm.id == '45678'),
                'deleted', isFalse),
      ],
    );
  });
}
