// import 'package:equatable/equatable.dart';

// abstract class AuthenticationState extends Equatable {
//   const AuthenticationState();

//   @override
//   List<Object> get props => [];
// }

// // States
// class AuthenticationInitial extends AuthenticationState {}

// class AuthenticationLoading extends AuthenticationState {}

// class AuthenticationSuccess extends AuthenticationState {
//   final String token;
//   final int userId;

//   const AuthenticationSuccess({required this.token, required this.userId});

//   @override
//   List<Object> get props => [token, userId];
// }

// class AuthenticationFailure extends AuthenticationState {
//   final String error;

//   const AuthenticationFailure({required this.error});

//   @override
//   List<Object> get props => [error];
// }

abstract class AuthenticationState {}
abstract class RegistrationState{}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String token;
  AuthenticationSuccess(this.token);
}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  AuthenticationFailure(this.error);
}


class RegistrationInitial extends RegistrationState {}
class RegistrationLoading extends RegistrationState {}


class RegistrationSuccess extends RegistrationState {
  RegistrationSuccess();
}

class RegistrationFailure extends RegistrationState {
  final String error;
  RegistrationFailure(this.error);
}
