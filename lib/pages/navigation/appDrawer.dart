// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print, unnecessary_cast

import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_state.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/nodeBackend/jwtStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../drawerOptions/updateProfile.dart';
import '../drawerOptions/aboutUs.dart';
import '../drawerOptions/help.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aap_dev_project/pages/account/authentication.dart';

class CustomDrawer extends StatefulWidget {
  final dynamic user;

  const CustomDrawer({Key? key, this.user}) : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final UserRepository userRepository = UserRepository();
  late UserBloc _userBloc;

  @override
   void initState() async {
    super.initState();
        String? token = await retrieveJwtToken();

    _userBloc = UserBloc(userRepository: userRepository);
    if (token != null) {
      _userBloc.add(FetchUserData(jwtToken: token));
    } else {
      // Handle the case where there's no token (e.g., show a login screen)
      print('No token found. User might need to log in.');
    }
  }


  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _userBloc,
        builder: (_, UserState state) {
          print(state);
          if (state is UserEmpty) {
            return const Center(child: Text('Empty state'));
          }
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserLoaded) {
            return Drawer(
              backgroundColor: const Color(0xFFCCE7E8),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(state.user.name),
                    accountEmail: Text(state.user.email),
                    decoration: BoxDecoration(
                      color: const Color(0xFF01888B),
                      image: DecorationImage(
                        image: state.user.image.isEmpty
                            ? const AssetImage("assets/profile.png")
                                as ImageProvider<Object>
                            : NetworkImage(state.user.image)
                                as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateProfilePage(user: state.user)),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About Us'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HelpPage(
                                emailAdress: state.user.email,
                                user: state.user)),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      signOut().then((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const Authentication()),
                        );
                      }).catchError((error) {
                        print("Error signing out: $error");
                      });
                    },
                  ),
                ],
              ),
            );
          }
          if (state is UserError) {
            return Center(child: Text(state.errorMsg!));
          }
          return const Center(child: Text('Unhandled state'));
        });
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }
}
