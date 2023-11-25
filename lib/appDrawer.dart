// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print, unnecessary_cast

import 'package:flutter/material.dart';
import 'updateProfile.dart';
import 'aboutUs.dart';
import 'help.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aap_dev_project/authentication.dart';

class CustomDrawer extends StatefulWidget {
  final dynamic user;

  const CustomDrawer({Key? key, this.user}) : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  _getUserProfile() {
    var snapshot = widget.user;
    print(snapshot.data());
    if (snapshot.exists) {
      setState(() {
        _nameController.text = snapshot['name'] ?? '';
        _emailController.text = snapshot['email'] ?? '';
        _imageController.text = snapshot['image'] ?? '';
      });
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
                image: _imageController.text.isEmpty
                    ? const AssetImage("assets/profile.png")
                        as ImageProvider<Object>
                    : NetworkImage(_imageController.text)
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
                    builder: (context) => UpdateProfilePage(user: widget.user)),
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
                    builder: (context) => AboutUsPage(user: widget.user)),
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
                        emailAdress: _emailController.text, user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              signOut().then((_) {
                // After signing out, navigate the user back to the login screen or wherever appropriate
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const Authentication()),
                );
              }).catchError((error) {
                // Handle error, if any
                print("Error signing out: $error");
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
