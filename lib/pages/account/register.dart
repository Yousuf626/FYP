// ignore_for_file: file_names, unused_import, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, sized_box_for_whitespace, sort_child_properties_last, deprecated_member_use

import 'dart:async';

import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:aap_dev_project/pages/account/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aap_dev_project/pages/home/dashboard.dart';

import '../../bloc/user/user_state.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with RouteAware {
  final UserRepository userRepository = UserRepository();
  late UserBloc _userBloc;

  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  void initState() {
    super.initState();
    // _userBloc = UserBloc(userRepository: userRepository);
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signed in with Google Successfully!")),
      );

      return userCredential;
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to sign in with Google: ${e.toString()}")),
      );
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
       if(state is UserSetSuccess){
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User successfully registered!")),
      );

      // Token generation successful (optional: access token from state)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardApp()),
      );

     
       }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor:
                Colors.white, // Set the app bar background color to white
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Authentication()),
                );
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 32),
                      const Center(
                        child: Text(
                          'Hello! Register to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 48),
                      buildTextFormField(_nameController, 'Name'),
                      const SizedBox(height: 16),
                      buildTextFormField(_emailController, 'Email'),
                      const SizedBox(height: 16),
                      buildTextFormField(_mobileController, 'Mobile Number'),
                      const SizedBox(height: 16),
                      buildTextFormField(_passwordController, 'Password',
                          isPassword: true),
                      const SizedBox(height: 16),
                      buildTextFormField(
                          _confirmPasswordController, 'Confirm password',
                          isPassword: true),
                      const SizedBox(height: 24),
                      Container(
                        width: double
                            .infinity, // This will make the button's width match its parent
                        child: FloatingActionButton.extended(
                          onPressed: _registerUser,
                          label: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          icon: const Icon(Icons.app_registration_outlined),
                          backgroundColor: const Color(0xFF01888B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 24),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login Now',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                    fontFamily: 'Urbanist',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextFormField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget socialButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: FaIcon(icon, size: 30),
      onPressed: onPressed,
    );
  }

  void _registerUser() async {
    try {
      _userBloc.add(SetUser(
        user: UserProfile(
          name: _nameController.text,
          age: 0,
          email: _emailController.text,
          mobile: _mobileController.text,
          adress: '',
          cnic: '',
          medicalHistory: '',
          image: '',
        ),
        pass: _passwordController.text,
      ));

      // Registration successful
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("User successfully registered!")),
      // );

      // // Token generation successful (optional: access token from state)
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => DashboardApp()),
      // );

      // // You might want to navigate the user to a different screen after successful registration
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to register: ${e.message}")),
      );
    }
  }
}
