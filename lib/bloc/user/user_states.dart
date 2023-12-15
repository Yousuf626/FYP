import 'package:aap_dev_project/models/user.dart';

abstract class UserState {
  const UserState([List props = const []]) : super();
}

class UserEmpty extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserProfile user;

  UserLoaded({required this.user}) : super([user]);
}

class UserError extends UserState {
  final String? errorMsg;
  UserError({this.errorMsg});
}
