// ignore_for_file: unused_import, file_names, unnecessary_import, sort_child_properties_last, deprecated_member_use, library_private_types_in_public_api

import 'package:aap_dev_project/bloc/alarm/alarm_bloc.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_event.dart';
import 'package:aap_dev_project/core/repository/alarm_repo.dart';
import 'package:aap_dev_project/pages/alarm.dart';
import 'package:aap_dev_project/pages/appDrawer.dart';
import 'package:aap_dev_project/pages/bottomNavigationBar.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/widgets.dart';
import 'package:aap_dev_project/models/alarmz.dart';

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
                MaterialPageRoute(
                    builder: (context) => BlocProvider<AlarmBloc>(
                          create: (context) =>
                              AlarmBloc(alarmRepository: AlarmRepository()),
                          child: const MedicineScreen(),
                        )),
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
  const MedicineScreen({Key? key}) : super(key: key);

  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> allMedicines = [
    'Panadol',
    'Ibuprofen',
    'Ciprofloxacin',
    'Acetaminophen'
  ];
  String? selectedMedicine;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TimeOfDay? selectedTime;
  int? frequencyPerDay; // New variable for frequency
  List<int> frequencyOptions = List.generate(12, (index) => index + 1);

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
      Overlay.of(context)!.insert(_overlayEntry!);
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

  void setAlarm() async {
    if (selectedMedicine == null ||
        frequencyPerDay == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select all fields')));
      return;
    }

    DateTime currentDate = DateTime.now();

    // Converting TimeOfDay to DateTime
    DateTime dateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    print('ok');
    print(dateTime);
    String uniqueId = '${DateTime.now().millisecondsSinceEpoch}';
    AlarmInformation alarmInfo = AlarmInformation(
      id: uniqueId,
      name: selectedMedicine!,
      time: dateTime,
      isActive: true,
      frequency: frequencyPerDay!,
    );

    BlocProvider.of<AlarmBloc>(context).add(SetAlarm(alarmInfo));

    print('lol');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => AlarmHomeScreen()));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
      // Here you can add the code to set the alarm
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
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
              "Add Alarm",
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
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
              Center(
                child: DropdownButton<int>(
                  value: frequencyPerDay,
                  hint: Text('Select Frequency Per Day'),
                  items:
                      frequencyOptions.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value times a day'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      frequencyPerDay = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                  child: GestureDetector(
                      onTap: () => {
                            if (selectedMedicine != null &&
                                frequencyPerDay != null)
                              {_selectTime(context).then((_) {})}
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Please select a medicine and frequency')))
                              }
                          },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer),
                            Text('Select First Dosage Time')
                          ]))),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setAlarm();
                },
                child: const Text('Set Alarm'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        )
      ]),
      bottomNavigationBar: BaseMenuBar(),
    );
  }
}
