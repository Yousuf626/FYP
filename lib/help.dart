// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'bottomNavigationBar.dart';
import 'appDrawer.dart';

Future<void> sendEmail(String userEmail, String userRequest) async {
  String username = 'auroobaparker@outlook.com';
  String password = 'Aabathebest1';

  final smtpServer = hotmail(username, password);

  final message = Message()
    ..from = Address(username)
    ..recipients.add('auroobaparker@gmail.com')
    ..subject = 'New Request/Complaint'
    ..text = 'User Email: $userEmail\n\nRequest/Complaint: $userRequest';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. Error: $e');
  }
}

class HelpPage extends StatefulWidget {
  final String emailAdress;

  const HelpPage({super.key, required this.emailAdress});
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _requestController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BaseMenuBar(),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
                color: Color(0xFF01888B),
              ),
              child: const Center(
                  child: Text(
                'How Can We Help?',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.53,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'You got a problem?',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'Don\'t worry, leave us a message and we will help you solve the problem.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: widget.emailAdress,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Your Request/Complaint',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _requestController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter your request/complaint',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await sendEmail(
                            _emailController.text,
                            _requestController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Message sent successfully! We have received your message and will get back to you soon.'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01888B),
                        ),
                        child: const Text(
                            style: TextStyle(color: Colors.white),
                            'Send Message'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}