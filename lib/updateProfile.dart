// ignore_for_file: avoid_print, file_names, library_private_types_in_public_api

import 'package:aap_dev_project/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appDrawer.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "auroobaparker@gmail.com", password: "aaaaiibbaa");
    print("Signed in");
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
            _ageController.text = (snapshot['age'] ?? '').toString();
            _emailController.text = snapshot['email'] ?? '';
            _mobileController.text = snapshot['mobile'] ?? '';
            _addressController.text = snapshot['address'] ?? '';
            _cnicController.text = snapshot['cnic'] ?? '';
            _medicalHistoryController.text = snapshot['medicalHistory'] ?? '';
            _imageController.text = snapshot['image'] ?? '';
          });
        }
      } catch (e) {
        print("Error fetching user profile: $e");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = true;

  Future<void> _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'name': _nameController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'address': _addressController.text,
          'cnic': _cnicController.text,
          'medicalHistory': _medicalHistoryController.text,
          'image': _imageController.text,
        });
      } catch (e) {
        print("Error updating user profile: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: const Color(0xFFCCE7E8),
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 0, bottom: 0),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 32),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  _imageController.text,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            const Icon(Icons.camera_alt),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Color(0xFF01888B)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF01888B), width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _ageController,
                              decoration: InputDecoration(
                                labelText: 'Age',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Color(0xFF01888B)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF01888B), width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Color(0xFF01888B)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF01888B), width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _mobileController,
                              decoration: InputDecoration(
                                labelText: 'Mobile',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Color(0xFF01888B)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF01888B), width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Color(0xFF01888B)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF01888B), width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _cnicController,
                              decoration: InputDecoration(
                                labelText: 'CNIC',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Color(0xFF01888B)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF01888B), width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _medicalHistoryController,
                              decoration: InputDecoration(
                                labelText: 'Medical History',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Color(0xFF01888B)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF01888B), width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              maxLines: null,
                            ),
                          ],
                        )),
                    const SizedBox(height: 56),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: ElevatedButton(
                        onPressed: _updateUserProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01888B),
                        ),
                        child: const Text(
                            style: TextStyle(color: Colors.white),
                            'Update Profile'),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                )),
              ),
        extendBody: true,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BaseMenuBar(),
        drawer: const CustomDrawer());
  }
}
