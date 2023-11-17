import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEDQR',
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFFFFFFF), // Set the background color to FFFFFF
        body: MedqrPage(),
      ),
    );
  }
}

class MedqrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              SizedBox(height: 10), 
              Image.asset('assets/MEDQR.jpg'),
            ],
          ),
        ),
        SizedBox(height: 40),
        ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicineScreen()),
    );
  },
  child: Text('Add your Medicine'),
  style: ElevatedButton.styleFrom(
    primary: Colors.red,
    onPrimary: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  ),
),
      ],
    );
  }
}
class MedicineScreen extends StatefulWidget {
  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> allMedicines = ['panadol', 'ibuprofen', 'ciprofloxacin', 'acetaminophen'];
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
        .where((medicine) => medicine.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

    if (matchingResults.isNotEmpty) {
      _overlayEntry = createOverlayEntry(matchingResults);
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  OverlayEntry createOverlayEntry(List<String> matchingResults) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 60),
          child: Material(
            elevation: 4,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: matchingResults.map((medicine) => ListTile(
                title: Text(medicine),
                onTap: () {
                  _controller.text = medicine;
                  selectedMedicine = medicine;
                  _overlayEntry?.remove();
                  setState(() {});
                },
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: Icon(Icons.arrow_back, color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'What Med would you like to add?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Start typing and select from the list',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          CompositedTransformTarget(
            link: _layerLink,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Med',
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Perform next action
            },
            child: Text('Next'),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              onPrimary: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: ClipRRect(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  ),
  child: Container(
    color: Colors.lightGreen,
    child: BottomNavigationBar(
      backgroundColor: Colors.transparent,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Another Home',
        ),
      ],
    ),
  ),
),
  );
}
}