import 'package:equatable/equatable.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent([List props = const []]) : super();
}

class FetchRecord extends RecordEvent {
  const FetchRecord() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}
