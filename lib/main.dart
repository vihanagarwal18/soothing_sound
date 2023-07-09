import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import the intl package

void main() => runApp(MeditationGame());

class MeditationGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeditationScreen(),
    );
  }
}

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  bool isMeditating = false;
  int meditationDuration = 5; // In minutes
  int remainingTime = 5;
  late Timer timer;
  late AudioPlayer audioPlayer;
  Map<DateTime, int> meditationData = {}; // Meditation data for heatmap
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    remainingTime = meditationDuration;
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    timer = Timer.periodic(Duration(seconds: 1), (_) {});
  }

  void startMeditation() {
    setState(() {
      isMeditating = true;
      remainingTime = meditationDuration;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            stopMeditation();
          }
        });
      });
    });

    playSoothingSound();
  }

  void stopMeditation() {
    setState(() {
      isMeditating = false;
      timer.cancel();
      DateTime now = DateTime.now();
      meditationData[DateTime(now.year, now.month, now.day)] = meditationDuration * 60 - remainingTime;
    });

    stopSoothingSound();
  }

  void playSoothingSound() async {
    print("playing");
    await audioPlayer.play('assets/storm-clouds-purpple-cat.mp3', isLocal: true, volume: 1.0);
  }

  void stopSoothingSound() async {
    await audioPlayer.stop();
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFAA88FB),
      appBar: AppBar(
        title: Text('Meditation Game'),
      ),
      body: Column(

        children: [
          Visibility(
            visible: !isMeditating,
            child: Column(
              children: [
                Text(
                  'Meditation Timer',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  isMeditating ? 'Remaining Time: $remainingTime' : 'Set your meditation time',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    startMeditation();
                  },
                  child: Text('Start Meditation'),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isMeditating,
            child: Expanded(
              child: Container(
                color: Color(0xFFAA88FB),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Meditation Timer',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Remaining Time: $remainingTime',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          stopMeditation();
                        },
                        child: Text('Stop Meditation'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xFFAA88FB),
            child: TableCalendar(
              calendarFormat: calendarFormat,
              focusedDay: focusedDay,
              firstDay: DateTime(DateTime.now().year - 1),
              lastDay: DateTime(DateTime.now().year + 1),
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                //backgroundColor: Colors.green,
                //rangeHighlightColor: Colors.transparent,
                selectedTextStyle: TextStyle(color: Colors.white),
                selectedDecoration: BoxDecoration(

                  color: Colors.indigo, // Customize the color here
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                defaultTextStyle: TextStyle(color: Colors.black),
                weekendTextStyle: TextStyle(color: Colors.red),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            color:  Color(0xFF9567FD),
            child: Center(
              child: Text(
                'Todays Date: ${DateTime.now().toString().substring(0, 10)}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          /*
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeatMapScreen(meditationData: meditationData),
                ),
              );
            },
            child: Text('View Heatmap'),
          ),*/
        ],
      ),
    );
  }
}

class HeatMapScreen extends StatelessWidget {
  final Map<DateTime, int> meditationData;

  HeatMapScreen({required this.meditationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Heatmap'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.green[200],
              child: Center(
                child: Text(
                  'Todays Date: ${DateTime.now().toString().substring(0, 10)}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Center(
                child: Text('Heatmap'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'heatmap.dart';

void main() => runApp(MeditationGame());

class MeditationGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeditationScreen(),
    );
  }
}

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  bool isMeditating = false;
  int meditationDuration = 5; // In minutes
  int remainingTime = 5 ;
  //int remainingTime = 5 * 60;
  late Timer timer;
  late AudioPlayer audioPlayer;
  Map<DateTime, int> meditationData = {}; // Meditation data for heatmap

  @override
  void initState() {
    super.initState();
    remainingTime = meditationDuration ;
    //remainingTime = meditationDuration * 60;
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    timer = Timer.periodic(Duration(seconds: 1), (_) {});
  }

  void startMeditation() {
    setState(() {
      isMeditating = true;
      remainingTime = meditationDuration ;
      //remainingTime = meditationDuration * 60;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            stopMeditation();
          }
        });
      });
    });

    playSoothingSound();
  }

  void stopMeditation() {
    setState(() {
      isMeditating = false;
      timer.cancel();
      DateTime now = DateTime.now();
      meditationData[DateTime(now.year, now.month, now.day)] = meditationDuration * 60 - remainingTime;
    });

    stopSoothingSound();
  }

  void playSoothingSound() async {
    print("playing");
    await audioPlayer.play('assets/storm-clouds-purpple-cat.mp3', isLocal: true, volume: 1.0);
  }

  void stopSoothingSound() async {
    await audioPlayer.stop();
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Meditation Timer',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              isMeditating ? 'Remaining Time: $remainingTime' : 'Set your meditation time',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (!isMeditating)
              ElevatedButton(
                onPressed: () {
                  startMeditation();
                },
                child: Text('Start Meditation'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  stopMeditation();
                },
                child: Text('Stop Meditation'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HeatMapScreen(meditationData: meditationData),
                  ),
                );
              },
              child: Text('View Heatmap'),
            ),
          ],
        ),
      ),
    );
  }
}*/











/*import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

void main() => runApp(MeditationGame());

class MeditationGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeditationScreen(),
    );
  }
}

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  bool isMeditating = false;
  int meditationDuration = 5; // In minutes
  int remainingTime = 5;
  late Timer timer;
  late AudioPlayer audioPlayer;
  Map<DateTime, int> datasets = {};

  @override
  void initState() {
    super.initState();
    remainingTime = meditationDuration;
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    updateDatasets();
  }

  void startMeditation() {
    setState(() {
      isMeditating = true;
      remainingTime = meditationDuration;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            stopMeditation();
          }
        });
      });
    });

    playSoothingSound();
  }

  void stopMeditation() {
    setState(() {
      isMeditating = false;
      timer.cancel();
    });

    stopSoothingSound();
    updateDatasets();
  }

  void playSoothingSound() async {
    print("playing");
    await audioPlayer.play('assets/storm-clouds-purpple-cat.mp3', isLocal: true, volume: 1.0);
  }

  void stopSoothingSound() async {
    await audioPlayer.stop();
  }

  void updateDatasets() {
    setState(() {
      datasets.clear();
      if (!isMeditating) {
        datasets[DateTime.now()] = 1; // Change the value to the desired color set
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Game'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
              child: Align(
                alignment: Alignment.center,
                child: HeatMap(
                  datasets: datasets,
                  startDate: DateTime.now().subtract(Duration(days: 30)),
                  endDate: DateTime.now().add(Duration(days: 30)),
                  colorsets: {
                    1: Color.fromARGB(20, 2, 179, 8),
                    2: Color.fromARGB(40, 2, 179, 8),
                    3: Color.fromARGB(60, 2, 179, 8),
                    4: Color.fromARGB(80, 2, 179, 8),
                    5: Color.fromARGB(100, 2, 179, 8),
                    6: Color.fromARGB(120, 2, 179, 8),
                    7: Color.fromARGB(140, 2, 179, 8),
                    8: Color.fromARGB(160, 2, 179, 8),
                    9: Color.fromARGB(180, 2, 179, 8),
                    10: Color.fromARGB(200, 2, 179, 8),
                  },
                  onClick: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value.toString())),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Meditation Timer',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              isMeditating ? 'Remaining Time: $remainingTime' : 'Set your meditation time',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (!isMeditating)
              ElevatedButton(
                onPressed: () {
                  startMeditation();
                },
                child: Text('Start Meditation'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  stopMeditation();
                },
                child: Text('Stop Meditation'),
              ),
          ],
        ),
      ),
    );
  }
}*/










/*import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'heatmap.dart';

void main() => runApp(MeditationGame());

class MeditationGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Meditaion(),
    );
  }
}

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  bool isMeditating = false;
  int meditationDuration = 5; // In minutes
  int remainingTime=5*60;
  late Timer timer;
  late AudioPlayer audioPlayer; // ? lagane se null value mil jati initstate main fill non null value de dete

  @override
  void initState() {
    super.initState();
    remainingTime = meditationDuration * 60;
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    timer = Timer.periodic(Duration(seconds: 1), (_) {});
  }

  void startMeditation() {
    setState(() {
      isMeditating = true;
      remainingTime = meditationDuration * 60;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            stopMeditation();
          }
        });
      });
    });

    playSoothingSound();
  }

  void stopMeditation() {
    setState(() {
      isMeditating = false;
      timer.cancel();
    });

    stopSoothingSound();
  }

  void playSoothingSound() async {
    print("playing");
    await audioPlayer.play('assets/storm-clouds-purpple-cat.mp3', isLocal: true, volume: 1.0);
  }

  void stopSoothingSound() async {
    await audioPlayer.stop();
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Meditation Timer',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              isMeditating ? 'Remaining Time: $remainingTime' : 'Set your meditation time',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (!isMeditating)
              ElevatedButton(
                onPressed: () {
                  startMeditation();
                },
                child: Text('Start Meditation'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  stopMeditation();
                },
                child: Text('Stop Meditation'),
              ),
          ],
        ),
      ),
    );
  }
}*/
