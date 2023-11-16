// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'updateProfile.dart';
import 'aboutUs.dart';
import 'help.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
            _emailController.text = snapshot['email'] ?? '';
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
    return Drawer(
      backgroundColor: const Color(0xFFCCE7E8),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_nameController.text),
            accountEmail: Text(_emailController.text),
            decoration: BoxDecoration(
              color: const Color(0xFF01888B),
              image: DecorationImage(
                image: NetworkImage(_imageController.text),
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
                    builder: (context) => const UpdateProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
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
                    builder: (context) =>
                        HelpPage(emailAdress: _emailController.text)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
