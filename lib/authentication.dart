
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Authentication(),
    );
  }
}

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/MEDQR.jpg'), // Make sure the image is in the assets folder
          SizedBox(height: 60), // Spacing between image and buttons
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.green, // Background color
    onPrimary: Colors.white, // Text Color
    padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  },
  child: Text(
    'Register',
    style: TextStyle(
      fontFamily: 'Urbanist',
    ),
  ),
),
          SizedBox(height: 24), // Spacing between buttons
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.blue, // Background color
    onPrimary: Colors.white, // Text Color
    padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  },
  child: Text(
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  String signInStatus = '';

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Align(
  alignment: Alignment.topLeft,
  child: Padding(
    padding: EdgeInsets.only(top: 40.0, left: 10.0),
    child: IconButton(
      icon: Icon(Icons.arrow_back_ios), 
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Authentication()),
        );
      },
    ),
  ),
),
                Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                  ),
                ),
                SizedBox(height: 48),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      fontFamily: 'Urbanist',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
controller: passwordController,
  obscureText: _isHidden,                 
   decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      fontFamily: 'Urbanist',
                    ),
                    suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: _isHidden
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Align(
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
                SizedBox(height: 16),
                 Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  signInStatus,
                  style: TextStyle(
                    color: Colors.red, // Color for the status message
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
               ElevatedButton(
  onPressed: () async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Update status message on successful sign-in
      setState(() {
        signInStatus = 'Successfully signed in';
      });
      // Optional: Navigate to a different screen
    } on FirebaseAuthException catch (e) {
      // Update status message on error
      setState(() {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          signInStatus = 'Incorrect email or password';
        } else {
          signInStatus = 'An error occurred. Please try again later';
        }
      });
    }
  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(14),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          // Dummy placeholder for Facebook icon
                          icon: FaIcon(FontAwesomeIcons.facebook),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Add this
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          // Dummy placeholder for Google icon
                          icon: FaIcon(FontAwesomeIcons.google),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Add this
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          // Dummy placeholder for Apple icon
                          icon: FaIcon(FontAwesomeIcons.apple),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account? ',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                      ),
                      children: [
                        TextSpan(
                          text: 'Register Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontFamily: 'Urbanist',
                          ),
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
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                    // Here you can write the code to submit the data to Firebase
                    try {
                      final User? user = (await _auth.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )).user;
                      if (user != null) {
                        // Registration successful
                      }
                    } catch (e) {
                      // Handle the error
                    }
                  }
                },
                child: Text('Register'),
              ),
            ),
            // Social media buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/google.png'), // Replace with your asset
                  onPressed: () {
                    // Google sign in process
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/facebook.png'), // Replace with your asset
                  onPressed: () {
                    // Facebook sign in process
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/apple.png'), // Replace with your asset
                  onPressed: () {
                    // Apple sign in process
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Navigate to login screen
              },
              child: Text(
                'Already have an account? Login Now',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
