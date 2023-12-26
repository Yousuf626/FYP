import 'package:aap_dev_project/models/report.dart';
import 'package:aap_dev_project/models/userSharing.dart';
import 'package:equatable/equatable.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent([List props = const []]) : super();
}

class FetchRecord extends RecordEvent {
  const FetchRecord() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddRecord extends RecordEvent {
  final String code;

  AddRecord({required this.code});

  @override
  List<Object> get props => [code];
}

class RemoveRecord extends RecordEvent {
  RemoveRecord();

  @override
  List<Object> get props => [];
}
