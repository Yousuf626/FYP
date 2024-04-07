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

class RegisterUser extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String mobilenumber;

  const RegisterUser({required this.name, required this.email, required this.password, required this.mobilenumber});

  @override
  List<Object> get props => [name, email, password, mobilenumber];
}
