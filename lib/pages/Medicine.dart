// ignore_for_file: unused_import, file_names, unnecessary_import, sort_child_properties_last, deprecated_member_use, library_private_types_in_public_api

import 'package:aap_dev_project/pages/appDrawer.dart';
import 'package:aap_dev_project/pages/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/widgets.dart';

class MedqrPage extends StatelessWidget {
  const MedqrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/MEDQR.jpg'),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicineScreen()),
              );
            },
            child: const Text('Add your Medicine'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> allMedicines = [
    'panadol',
    'ibuprofen',
    'ciprofloxacin',
    'acetaminophen'
  ];
  String? selectedMedicine;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      updateOverlay();
    });
  }

  void updateOverlay() {
    _overlayEntry?.remove();
    if (_controller.text.isEmpty) {
      return;
    }

    List<String> matchingResults = allMedicines
        .where((medicine) =>
            medicine.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

    if (matchingResults.isNotEmpty) {
      _overlayEntry = createOverlayEntry(matchingResults);
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  OverlayEntry createOverlayEntry(List<String> matchingResults) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: matchingResults
                  .map((medicine) => ListTile(
                        title: Text(medicine),
                        onTap: () {
                          _controller.text = medicine;
                          selectedMedicine = medicine;
                          _overlayEntry?.remove();
                          setState(() {});
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back, color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'What Med would you like to add?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Start typing and select from the list',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              CompositedTransformTarget(
                link: _layerLink,
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Med',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Perform next action
                },
                child: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BaseMenuBar());
  }
}
