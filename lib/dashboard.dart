// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:aap_dev_project/bottomNavigationBar.dart';
import 'package:aap_dev_project/appDrawer.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dashboard Example',
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "auroobaparker@gmail.com", password: "aaaaiibbaa");
    User? user = _auth.currentUser;
    if (user != null) {
      print(user.uid);
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();

        print(snapshot.data());
        if (snapshot.exists) {
          setState(() {
            _nameController.text = snapshot['name'] ?? '';
            _mobileController.text = snapshot['mobile'] ?? '';
            _imageController.text = snapshot['image'] ?? '';
          });
        }
      } catch (e) {
        print("Error fetching user profile: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BaseMenuBar(),
      drawer: const CustomDrawer(),
      body: Column(
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
                        _nameController.text,
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        _mobileController.text,
                        style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  ClipOval(
                    child: Image.network(
                      _imageController.text,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
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
                    onPressed: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
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
      ),
    );
  }
}
