// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:aap_dev_project/core/repository/authentication_repo.dart';

// // Import the event and state files 
// import 'authentication_event.dart';
// import 'authentication_state.dart';

// // A repository class to handle communication with your backend (we'll outline this shortly)
// // class AuthenticationRepository {final authRepo = AuthenticationRepository();
// // final response = await authRepo.signup(final authRepo = AuthenticationRepository();
// // await authRepo.forgotPassword(event.email);
// //             event.name, event.email, event.mobileNumber, event.password);
// //   Future<dynamic> signup(
// //       String name, String email, String mobileNumber, String password) async {
// //     FutureOr<void> _onUserSignUpRequested(
// //         UserSignUpRequested event, Emitter<AuthenticationState> emit) async {
// //       emit(AuthenticationLoading());
// //       try {
// //         final authRepo = AuthenticationRepository();
// // final response = await authRepo.signup(
// //             event.name, event.email, event.mobileNumber, event.password);
// //         // final response = await AuthenticationRepository.signup(
// //         //     event.name, event.email, event.mobileNumber, event.password);

// //         // Assuming your API returns a token on successful signup, adjust this logic 
// //         if (response['token'] != null) {
// //           emit(AuthenticationSuccess(
// //               token: response['token'], userId: response['userId']));
// //         } else {
// //           emit(AuthenticationFailure(error: 'Signup failed'));
// //         }
// //       } catch (error) {
// //         emit(AuthenticationFailure(error: error.toString()));
// //       }
// //     }
// //   }

// //   Future<dynamic> login(String email, String password) async {
// //     // Implementation for making the login request...
// //   }

// //   // ... Other methods for forgotPassword and verifyOTPAndChangePassword
// // }

// class AuthenticationBloc
//     extends Bloc<AuthenticationEvent, AuthenticationState> {
//   final AuthenticationRepository authenticationRepository;

//   AuthenticationBloc({required this.authenticationRepository})
//       : super(AuthenticationInitial()) {
//     on<AppStarted>(_onAppStarted);
//     on<UserLoggedIn>(_onUserLoggedIn);
//     on<UserLoggedOut>(_onUserLoggedOut);
//     on<UserSignUpRequested>(_onUserSignUpRequested);
//     on<UserForgotPasswordRequested>(_onUserForgotPasswordRequested);
//     on<UserVerifyOTPAndChangePasswordRequested>(
//         _onUserVerifyOTPAndChangePasswordRequested);
//   }

//   FutureOr<void> _onAppStarted(
//       AppStarted event, Emitter<AuthenticationState> emit) async {
//     // Check for any existing authentication tokens
//     // If you have a mechanism for storing the token, adapt this logic
//   }

//   FutureOr<void> _onUserLoggedIn(
//       UserLoggedIn event, Emitter<AuthenticationState> emit) async {
//     emit(AuthenticationSuccess(token: event.token, userId: event.userId));
//   }

//   FutureOr<void> _onUserLoggedOut(
//       UserLoggedOut event, Emitter<AuthenticationState> emit) async {
//     // Clear any authentication tokens
//     emit(AuthenticationInitial());
//   }
// // Implement handlers for UserSignUpRequested, UserForgotPasswordRequested, UserVerifyOTPAndChangePasswordRequested 
// } 
// // ... (Previous code from above) ...

// FutureOr<void> _onUserSignUpRequested(
//     UserSignUpRequested event, Emitter<AuthenticationState> emit) async {
//   emit(AuthenticationLoading());
//   try {final authRepo = AuthenticationRepository();
// final response = await authRepo.signup(
//             event.name, event.email, event.mobileNumber, event.password);
//     // final response = await AuthenticationRepository.signup(
//     //     event.name, event.email, event.mobileNumber, event.password);

//     // Assuming your API returns a token on successful signup, adjust this logic 
//     if (response['token'] != null) {
//       emit(AuthenticationSuccess(
//           token: response['token'], userId: response['userId']));
//     } else {
//       emit(AuthenticationFailure(error: 'Signup failed'));
//     }
//   } catch (error) {
//     emit(AuthenticationFailure(error: error.toString()));
//   }
// }

// FutureOr<void> _onUserForgotPasswordRequested(
//     UserForgotPasswordRequested event, Emitter<AuthenticationState> emit) async {
//   emit(AuthenticationLoading());
//   try {
//     final authRepo = AuthenticationRepository();
//     await authRepo.forgotPassword(event.email);
//     // await AuthenticationRepository.forgotPassword(event.email);
//     emit(AuthenticationInitial()); // Or a specific "forgot password success" state
//   } catch (error) {
//     emit(AuthenticationFailure(error: error.toString()));
//   }
// }
// // final authRepo = AuthenticationRepository();
// // final response = await authRepo.signup(
// //       event.name, event.email, event.mobileNumber, event.password);
// FutureOr<void> _onUserVerifyOTPAndChangePasswordRequested(
//     UserVerifyOTPAndChangePasswordRequested event,
//     Emitter<AuthenticationState> emit) async {
//   emit(AuthenticationLoading());
//   try {
//     // await AuthenticationRepository.verifyOTPAndChangePassword(
//     //   event.email,
//     //   event.otp,
//       final authRepo = AuthenticationRepository();
// await authRepo.verifyOTPAndChangePassword(
//       event.email,
//       event.otp,
//       event.newPassword,
//     );
//     //   event.newPassword,
//     // );
//     emit(AuthenticationInitial()); // Or a specific "password changed" state
//   } catch (error) {
//     emit(AuthenticationFailure(error: error.toString()));
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:aap_dev_project/core/repository/authentication_repo.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository repository;

  AuthenticationBloc(this.repository) : super(AuthenticationInitial()) {
    on<AppStarted>((event, emit) => emit(AuthenticationInitial()));

    on<UserLoggedIn>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final token = await repository.login(event.email, event.password);
        emit(AuthenticationSuccess(token));
      } catch (error) {
        emit(AuthenticationFailure(error.toString()));
      }
    });

    on<UserLoggedOut>((event, emit) => emit(AuthenticationInitial()));

    on<UserSignUpRequested>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final token = await repository.signup(event.name, event.email, event.mobileNumber, event.password);
        emit(AuthenticationSuccess(token));
      } catch (error) {
        emit(AuthenticationFailure(error.toString()));
      }
    });

    on<UserForgotPasswordRequested>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        await repository.forgotPassword(event.email);
        emit(AuthenticationInitial()); // Consider creating a specific state for password reset flow
      } catch (error) {
        emit(AuthenticationFailure(error.toString()));
      }
    });

    on<UserVerifyOTPAndChangePasswordRequested>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        await repository.verifyOTPAndChangePassword(event.email, event.otp, event.newPassword);
        emit(AuthenticationInitial()); // Consider a specific state indicating successful password change
      } catch (error) {
        emit(AuthenticationFailure(error.toString()));
      }
    });
  }
}
