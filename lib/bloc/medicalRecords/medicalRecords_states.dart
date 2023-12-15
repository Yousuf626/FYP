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
