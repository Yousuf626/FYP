// ignore_for_file: unused_import, unused_local_variable, unnecessary_import, deprecated_member_use, library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print

import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/pages/Medicine.dart';
import 'package:aap_dev_project/pages/forgotpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../firebase/firebase_options.dart';
import 'package:aap_dev_project/pages/Register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return DashboardApp();
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
              'assets/MEDQR.jpg'), // Make sure the image is in the assets folder
          const SizedBox(height: 60), // Spacing between image and buttons
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.green, // Background color
    onPrimary: Colors.white, // Text Color
    padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Rounded rectangular borders
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  },
  child: const Text(
    'Register',
    style: TextStyle(
      fontFamily: 'Urbanist',
    ),
  ),
),
          const SizedBox(height: 24), // Spacing between buttons
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.blue, // Background color
    onPrimary: Colors.white, // Text Color
    padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Rounded rectangular borders
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  },
  child: const Text(
    'Login',
    style: TextStyle(
      fontFamily: 'Urbanist',
    ),
  ),
),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserRepository userRepository = UserRepository();
  late UserBloc _userBloc;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  String signInStatus = '';

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userRepository: userRepository);
  }

  Future<UserCredential?> signInWithGoogle() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    var exists = false;

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Return null if user cancels the Google Sign-In
    if (googleUser == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    var a = await FirebaseAuth.instance.signInWithCredential(credential);
    snapshot.docs.forEach((doc) => {
          exists = doc.id == a.user?.uid,
        });
    if (exists == false) {
      _userBloc.add(SetUser(
          user: UserProfile(
        name: googleUser.displayName!,
        age: 0,
        email: googleUser.email,
        mobile: '',
        adress: '',
        cnic: '',
        medicalHistory: '',
        image: googleUser.photoUrl!,
      )));
    }
    return a;
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.white, // Set the app bar background color to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Authentication()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                      fontFamily: 'Urbanist',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Urbanist',
                    ),
                    suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: _isHidden
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF6A707C),
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    signInStatus,
                    style: const TextStyle(
                      color: Colors.red, // Color for the status message
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      // Update status message on successful sign-in
                      setState(() {
                        signInStatus = 'Successfully signed in';
                      });
                      // Navigate to MedicineScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardApp()),
                      );
                    } on FirebaseAuthException catch (e) {
                      // Update status message on error
                      setState(() {
                        if (e.code == 'user-not-found' ||
                            e.code == 'wrong-password') {
                          signInStatus = 'Incorrect email or password';
                        } else {
                          signInStatus =
                              'An error occurred. Please try again later';
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF01888B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(14),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10), // Add this
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google),
                          onPressed: () async {
                            try {
                              final UserCredential? userCredential =
                                  await signInWithGoogle();
                              if (userCredential != null) {
                                // User signed in with Google. You can navigate to another screen here.
                                print('Successfully signed in with Google');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardApp()),
                                );
                              }
                            } catch (e) {
                              // Handle error here
                              print('Error signing in with Google: $e');
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Add this
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account? ',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                      ),
                      children: [
                        TextSpan(
                          text: 'Register Now',
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
                                    builder: (context) => RegistrationScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
