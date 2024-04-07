// import 'package:equatable/equatable.dart';

// abstract class AuthenticationEvent extends Equatable {
//   const AuthenticationEvent();

//   @override
//   List<Object> get props => [];
// }

// // Events
// class AppStarted extends AuthenticationEvent {}

// class UserLoggedIn extends AuthenticationEvent {
//   final String token;
//   final int userId;

//   const UserLoggedIn({required this.token, required this.userId});

//   @override
//   List<Object> get props => [token, userId];
// }

// class UserLoggedOut extends AuthenticationEvent {}

// class UserSignUpRequested extends AuthenticationEvent {
//   final String name;
//   final String email;
//   final String mobileNumber;
//   final String password;

//   const UserSignUpRequested({
//     required this.name,
//     required this.email,
//     required this.mobileNumber,
//     required this.password,
//   });

//   @override
//   List<Object> get props => [name, email, mobileNumber, password];
// }

// class UserForgotPasswordRequested extends AuthenticationEvent {
//   final String email;

//   const UserForgotPasswordRequested({required this.email});

//   @override
//   List<Object> get props => [email];
// }

// class UserVerifyOTPAndChangePasswordRequested extends AuthenticationEvent {
//   final String email;
//   final String otp;
//   final String newPassword;

//   const UserVerifyOTPAndChangePasswordRequested({
//     required this.email,
//     required this.otp,
//     required this.newPassword,
//   });

//   @override
//   List<Object> get props => [email, otp, newPassword];
// }

abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class UserLoggedIn extends AuthenticationEvent {
  final String email, password;
  UserLoggedIn(this.email, this.password);
}

class UserLoggedOut extends AuthenticationEvent {}

class UserSignUpRequested extends AuthenticationEvent {
  final String name, email, mobileNumber, password;
  UserSignUpRequested(this.name, this.email, this.mobileNumber, this.password);
}

class UserForgotPasswordRequested extends AuthenticationEvent {
  final String email;
  UserForgotPasswordRequested(this.email);
}

class UserVerifyOTPAndChangePasswordRequested extends AuthenticationEvent {
  final String email, otp, newPassword;
  UserVerifyOTPAndChangePasswordRequested(this.email, this.otp, this.newPassword);
}
