// ignore_for_file: file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'bottomNavigationBar.dart';
import 'appDrawer.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AboutUsContent(),
      drawer: const CustomDrawer(),
      bottomNavigationBar: BaseMenuBar(),
    );
  }
}

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            'MedQR Provides',
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FeatureLine(
                    icon: 'assets/lock.png',
                    feature:
                        'Secure storage of medical history, test reports and prescriptions.'),
                SizedBox(height: 20.0),
                FeatureLine(
                    icon: 'assets/profile.png',
                    feature:
                        'Patients can register themselves easily and make their profile.'),
                SizedBox(height: 20.0),
                FeatureLine(
                    icon: 'assets/calendar.png',
                    feature: 'Customizable medication reminders'),
                SizedBox(height: 20.0),
                FeatureLine(
                    icon: 'assets/code.png',
                    feature: 'Streamlined doctor access to patient records'),
              ],
            )),
      ],
    );
  }
}

class FeatureLine extends StatelessWidget {
  final String icon;
  final String feature;

  const FeatureLine({
    Key? key,
    required this.icon,
    required this.feature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(icon, height: 50.0, width: 50.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                feature,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
