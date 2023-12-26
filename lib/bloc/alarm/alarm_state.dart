import 'package:aap_dev_project/models/alarmz.dart';

abstract class AlarmState {
  const AlarmState([List props = const []]) : super();
}

class AlarmInitial extends AlarmState {}

class AlarmLoading extends AlarmState {}

class AlarmLoaded extends AlarmState {
  final List<AlarmInformation> alarms;

  AlarmLoaded({required this.alarms}) : super([alarms]);
}

class AlarmError extends AlarmState {
  final String? errorMsg;
  AlarmError({this.errorMsg});
}

class AlarmSetting extends AlarmState {}

class AlarmSetSuccess extends AlarmState {}

class AlarmSetError extends AlarmState {
  final String? errorMsg;
  AlarmSetError({this.errorMsg});
}

class AlarmDeleting extends AlarmState {}

class AlarmDeletedSuccess extends AlarmState {}

class AlarmDeleteError extends AlarmState {
  final String? errorMsg;
  AlarmDeleteError({this.errorMsg});
}
