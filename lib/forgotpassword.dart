import 'package:aap_dev_project/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State <ForgotPasswordScreen> {
    final TextEditingController _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    // Show a message that the email has been sent
  } on FirebaseAuthException catch (e) {
    // Handle errors, show a message to the user
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black), // Back button
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Don't worry! It occurs. Please enter the email address linked with your account.",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
  controller: _emailController,
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Enter your email',
  ),
  keyboardType: TextInputType.emailAddress,
),

            SizedBox(height: 20.0),
        TextButton(
  child: Text(
    'Send Code',
    style: TextStyle(fontSize: 18.0, color: Colors.white),
  ),
  style: TextButton.styleFrom(
    backgroundColor: Colors.teal,
    padding: EdgeInsets.all(16.0),
  ),
  onPressed: () {
    resetPassword(_emailController.text);
  },
),

            Stack(
  children: <Widget>[
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // ... rest of your widgets ...
        // Remove the button from here
      ],
    ),
    Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        child: Text(
          'Remember Password? Login',
          style: TextStyle(color: Colors.teal),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}
