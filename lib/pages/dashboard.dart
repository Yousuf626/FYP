// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_states.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/pages/Medicine.dart';
import 'package:aap_dev_project/pages/addMedicalRecord.dart';
import 'package:aap_dev_project/pages/alarm.dart';
import 'package:aap_dev_project/pages/viewMedicalRecords.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:aap_dev_project/pages/bottomNavigationBar.dart';
import 'package:aap_dev_project/pages/appDrawer.dart';

void main() {
  runApp(DashboardApp());
}

class DashboardApp extends StatelessWidget {
  DashboardApp({super.key});
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Example',
      home: DashboardScreen(userRepository: userRepository),
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.userRepository});
  final UserRepository userRepository;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userRepository: widget.userRepository);
    _userBloc.add(const FetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: BaseMenuBar(),
        body: BlocBuilder(
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
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        ),
                        color: Color(0xFF01888B),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.name,
                                  style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 30,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 20.0),
                                Text(
                                  state.user.mobile,
                                  style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                  child: Container(
                                decoration: state.user.image.isEmpty
                                    ? const BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/profile.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : null, // Set to null if there's no decoration
                                child: state.user.image.isEmpty
                                    ? null // No child if using decoration
                                    : Image.network(
                                        state.user.image,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                            height: 80,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddReport()));
                              },
                              label: const Text(
                                'Add Medical Records',
                                style: TextStyle(fontSize: 22),
                              ),
                              icon: const Icon(Icons.add_circle_outline),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                backgroundColor: const Color(0xFF01888B),
                              ),
                            ))),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AlarmHomeScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  backgroundColor: const Color(0xFFF04444),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Alarm',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    SizedBox(height: 5),
                                    Icon(Icons.alarm),
                                  ],
                                ),
                              )),
                          const SizedBox(width: 10.0),
                          Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewRecords(
                                              userid: '',
                                            )),
                                  );
                                },
                                label: const Text('View Medical Records',
                                    style: TextStyle(fontSize: 22),
                                    textAlign: TextAlign.center),
                                icon: const Icon(Icons.remove_red_eye_outlined),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  backgroundColor: const Color(0xFF01888B),
                                ),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      height: 220,
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {
                          print('Tapped');
                          const url = 'https://www.google.com';
                          await launchUrlString(url);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            'https://img.freepik.com/free-psd/medical-healthcare-poster-template_23-2148940481.jpg?w=1380&t=st=1700163117~exp=1700163717~hmac=2503f8ac3e3f45a86a6ecc0480fc21d9676592337021a3b8c62ccd4c41066b46',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is UserError) {
                return Center(child: Text(state.errorMsg!));
              }
              return const Center(child: Text('Unhandled state'));
            }));
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }
}
