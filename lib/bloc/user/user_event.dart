import 'package:aap_dev_project/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent([List props = const []]) : super();
}

class FetchUserData extends UserEvent {
  const FetchUserData() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SetUser extends UserEvent {
  final UserProfile user;

  const SetUser({required this.user});

  @override
  List<Object> get props => [user];
}
