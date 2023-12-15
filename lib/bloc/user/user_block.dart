import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_states.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserLoading()) {
    on<FetchUserData>((event, emit) async {
      await getUser(emit);
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
}
