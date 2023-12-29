import 'package:aap_dev_project/models/report.dart';
import 'package:equatable/equatable.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent([List props = const []]) : super();
}

class FetchRecord extends RecordEvent {
  final String userid;
  const FetchRecord({required this.userid});

  @override
  List<Object?> get props => [userid];
}

class SetRecord extends RecordEvent {
  final UserReport report;

  const SetRecord({required this.report});

  @override
  List<Object> get props => [report];
}
