import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_state.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserLoading()) {
    on<FetchUserData>((event, emit) async {
      await getUser(emit);
    });
    on<SetUser>((event, emit) async {
      await setUser(event.user, emit);
    });
  }

  Future<void> getUser(Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final UserProfile user = await userRepository.getUser();
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(errorMsg: e.toString()));
    }
  }

  Future<void> setUser(UserProfile report, Emitter<UserState> emit) async {
    emit(UserSetting());

    try {
      await userRepository.uploadUserRecords(report);
      emit(UserSetSuccess());
    } catch (e) {
      emit(UserSetError(errorMsg: e.toString()));
    }
  }
}
