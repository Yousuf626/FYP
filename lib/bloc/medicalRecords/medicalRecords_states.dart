import 'package:aap_dev_project/models/report.dart';

abstract class RecordState {
  const RecordState([List props = const []]) : super();
}

class RecordEmpty extends RecordState {}

class RecordLoading extends RecordState {}

class RecordLoaded extends RecordState {
  final List<UserReport> records;

  RecordLoaded({required this.records}) : super([records]);
}

class RecordError extends RecordState {
  final String? errorMsg;
  RecordError({this.errorMsg});
}

class RecordSetting extends RecordState {} // New state for setting a record

class RecordSetSuccess
    extends RecordState {} // New state for successful record setting

class RecordSetError extends RecordState {
  final String? errorMsg;
  RecordSetError({this.errorMsg});
}
