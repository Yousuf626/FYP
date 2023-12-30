import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_states.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'userBlockRepo.dart';

void main() {
  group('Search repo bloc test', () {
    late UserBloc userBloc;
    late MockUserRepo mockRepo;

    setUp(() {
      mockRepo = MockUserRepo();
      userBloc = UserBloc(userRepository: mockRepo);
    });

    tearDown(() {
      userBloc.close();
    });

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserLoaded] with specific UserProfile instance when FetchUserData event is added',
      build: () => userBloc,
      act: (bloc) => bloc.add(const FetchUserData()),
      expect: () {
        final expectedProfile = UserProfile(
          name: 'John Moc',
          age: 20,
          image: 'https://i.imgur.com/BoN9kdC.png',
          cnic: '1234567890123',
          medicalHistory: 'No medical history',
          mobile: '1234567890',
          adress: '123, ABC Street, XYZ City',
          email: 'auroobaparker@gmail.com',
        );

        return [
          UserLoading(),
          UserLoaded(user: expectedProfile),
        ];
      },
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserUploaded] when UploadUserData event is added',
      build: () => userBloc,
      act: (bloc) {
        final userProfile = UserProfile(
          name: "John ",
          email: "parker@gmail.com",
          image: "https://i.imgur.com/BoN9kdC.pg",
          mobile: "12347890",
          medicalHistory: "No history",
          adress: "123, ABC, XYZ City",
          age: 89,
          cnic: "90123",
        );
        bloc.add(SetUser(user: userProfile));
      },
      expect: () {
        return [
          UserSetting(),
          UserSetSuccess(),
        ];
      },
    );
  });
}
