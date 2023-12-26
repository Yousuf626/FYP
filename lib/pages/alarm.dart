import 'dart:async';

import 'package:aap_dev_project/pages/Medicine.dart';
import 'package:aap_dev_project/pages/alarmScreen.dart';
import 'package:aap_dev_project/pages/appDrawer.dart';
import 'package:aap_dev_project/pages/bottomNavigationBar.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({Key? key}) : super(key: key);

  @override
  State<AlarmHomeScreen> createState() => _ExampleAlarmHomeScreenState();
}

class _ExampleAlarmHomeScreenState extends State<AlarmHomeScreen> {
  late List<AlarmSettings> alarms;

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    scheduleNextRingTime();
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidExternalStoragePermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  TimeOfDay showNextRingTime(AlarmInfoR alarm) {
    final currentTime = TimeOfDay.now();
    const minutesInDay = 24 * 60;
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final ringInterval = minutesInDay ~/ alarm.ringCount;

    int nextRingMinutes = currentMinutes;
    if (currentMinutes % ringInterval == 0) {
      nextRingMinutes += ringInterval;
    } else {
      nextRingMinutes = ((currentMinutes / ringInterval).ceil()) * ringInterval;
    }

    if (nextRingMinutes >= minutesInDay) {
      nextRingMinutes -= minutesInDay;
    }

    final nextRingTime =
        TimeOfDay(hour: nextRingMinutes ~/ 60, minute: nextRingMinutes % 60);
    return nextRingTime;
  }

  void scheduleNextRingTime() async {
    for (var index = 0; index < alarmsList.length; index++) {
      var alarmItem = alarmsList[index];
      if (alarmItem.isActive) {
        final alarmSettings = AlarmSettings(
          id: index + 1,
          dateTime: calculateNextRingTime(alarmItem),
          assetAudioPath: 'assets/tune.mp3',
          loopAudio: true,
          vibrate: true,
          volume: 0.8,
          fadeDuration: 3.0,
          notificationTitle: 'Its Time to take your Medicine',
          notificationBody: '${alarmItem.name} ',
          enableNotificationOnKill: true,
        );
        await Alarm.set(alarmSettings: alarmSettings);
        await Alarm.stop(index + 1);
      }
    }
  }

  List<AlarmInfoR> alarmsList = [
    AlarmInfoR(
      name: 'Risek',
      ringCount: 3,
      isActive: true,
    ),
    AlarmInfoR(
      name: 'Panadol',
      ringCount: 450,
      isActive: true,
    ),
    AlarmInfoR(
      name: 'Risek',
      ringCount: 3,
      isActive: true,
    ),
  ];

  DateTime calculateNextRingTime(AlarmInfoR alarm) {
    final currentTime = DateTime.now();
    const minutesInDay = 24 * 60;
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final ringInterval = minutesInDay ~/ alarm.ringCount;

    int nextRingMinutes = currentMinutes;
    if (currentMinutes % ringInterval == 0) {
      nextRingMinutes += ringInterval;
    } else {
      nextRingMinutes = ((currentMinutes / ringInterval).ceil()) * ringInterval;
    }

    if (nextRingMinutes >= minutesInDay) {
      nextRingMinutes -= minutesInDay;
    }

    final nextRingDateTime =
        currentTime.add(Duration(minutes: nextRingMinutes - currentMinutes));
    return nextRingDateTime;
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Widget buildAlarmCard(AlarmInfoR alarm) {
    return Card(
      color: const Color(0xFF01888B),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    alarm.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Next Dose At:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Text(
                showNextRingTime(alarm).format(context),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${alarm.ringCount} times a day',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        alarmsList.remove(alarm);
                      });
                    },
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 1.4,
                      child: Switch(
                        activeColor: Colors.yellow,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        value: alarm.isActive,
                        onChanged: (value) {
                          setState(() {
                            alarm.isActive = value;
                            scheduleNextRingTime();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Column(
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
                "Alarm",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: alarmsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildAlarmCard(alarmsList[index]);
                },
              ),
            ),
          ),
          CircleAvatar(
  radius: 30.0,
  backgroundColor: Color(0xFF01888B),
  child: IconButton(
    icon: const Icon(
      Icons.alarm_add,
      size: 30.0,
      color: Colors.white,
    ),
     onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedqrPage()), // Replace MedQrPage with your destination widget
      );
    },
  ),
),
        ],
      ),
    );
  }
}

class AlarmInfoR {
  String name;
  int ringCount;
  bool isActive;

  AlarmInfoR({
    required this.name,
    required this.ringCount,
    required this.isActive,
  });
}
