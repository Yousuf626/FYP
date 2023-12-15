import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent([List props = const []]) : super();
}

class FetchUserData extends UserEvent {
  const FetchUserData() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}
