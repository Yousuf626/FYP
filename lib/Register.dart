import 'package:aap_dev_project/authentication.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'login_screen.dart'; // Make sure to import your login screen

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}
class _RegistrationScreenState extends State<RegistrationScreen> {
  Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signed in with Google Successfully!")),
    );

    return userCredential;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to sign in with Google: ${e.toString()}")),
    );
    return null;
  }
}

Future<UserCredential?> signInWithFacebook() async {
  final LoginResult result = await FacebookAuth.instance.login();
  if (result.status != LoginStatus.success) return null;
  final credential = FacebookAuthProvider.credential(result.accessToken!.token);
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 32),
                Center(
                  child: Text(
                    'Hello! Register to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 48),
                buildTextFormField(_usernameController, 'Username'),
                SizedBox(height: 16),
                buildTextFormField(_emailController, 'Email'),
                SizedBox(height: 16),
                buildTextFormField(_passwordController, 'Password', isPassword: true),
                SizedBox(height: 16),
                buildTextFormField(_confirmPasswordController, 'Confirm password', isPassword: true),
                SizedBox(height: 24),
Container(
  width: double.infinity, // This will make the button's width match its parent
  child: ElevatedButton(
    onPressed: _registerUser,
    child: Text('Register'),
    style: ElevatedButton.styleFrom(
      primary: Color(0xFF30E3CA),
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      textStyle: TextStyle(fontSize: 18),
    ),
  ),
),
SizedBox(height: 16),
                Row(
 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey)
      ),
      child: socialButton(FontAwesomeIcons.google, () async {
        try {
          final userCredential = await signInWithGoogle();
          if (userCredential != null) {
            // Handle the user sign-in
          }
        } catch (e) {
          // Handle the error
        }
      }),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey)
      ),
      child: socialButton(FontAwesomeIcons.facebook, () async {
        try {
          final userCredential = await signInWithFacebook();
          if (userCredential != null) {
            // Handle the user sign-in
          }
        } catch (e) {
          // Handle the error
        }
      }),  
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey)
      ),
       child: socialButton(FontAwesomeIcons.apple, () {}),
    ),
  ],
),
SizedBox(height: 24),
                SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                          ),
                          children: [
                            TextSpan(
                              text: 'Login Now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontFamily: 'Urbanist',
                              ),
                              recognizer: TapGestureRecognizer() ..onTap =() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
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
    );
  }

  Widget buildTextFormField(TextEditingController controller, String label, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
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
  if (_formKey.currentState!.validate()) {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      // Update the display name
      if (_usernameController.text.trim().isNotEmpty) {
        await user!.updateDisplayName(_usernameController.text.trim());
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registered Successfully!")),
      );

      // Optional: Navigate to a different screen after successful registration

    } on FirebaseAuthException catch (e) {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred during registration')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all fields')),
    );
  }
}


}
