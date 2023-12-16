import 'package:aap_dev_project/models/report.dart';
import 'package:equatable/equatable.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent([List props = const []]) : super();
}

class FetchRecord extends RecordEvent {
  const FetchRecord() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SetRecord extends RecordEvent {
  final UserReport report;

  SetRecord({required this.report});

  @override
  List<Object> get props => [report];
}
