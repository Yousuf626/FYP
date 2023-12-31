// ignore_for_file: file_names

import 'package:aap_dev_project/pages/medicalReports/shareRecords.dart';
import 'package:flutter/material.dart';
import '../home/dashboard.dart';

class BaseMenuBar extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BaseMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFCCE7E8),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(500),
          topLeft: Radius.circular(500),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(500.0),
          topRight: Radius.circular(500.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF01888B),
          onTap: (index) => _onNavItemTap(context, index),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Icon(Icons.menu, color: Colors.white),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Icon(Icons.home_outlined, color: Colors.white),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Icon(Icons.group, color: Colors.white),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  void _onNavItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Scaffold.of(context).openDrawer();
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardApp()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShareRecords()),
        );
        break;
    }
  }
}
