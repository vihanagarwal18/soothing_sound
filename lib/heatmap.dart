import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HeatMapScreen extends StatefulWidget {
  final Map<DateTime, int> meditationData;

  HeatMapScreen({required this.meditationData});

  @override
  _HeatMapScreenState createState() => _HeatMapScreenState();
}

class _HeatMapScreenState extends State<HeatMapScreen> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Heatmap'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    focusedDay = DateTime(focusedDay.year, focusedDay.month - 1, focusedDay.day);
                  });
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat.yMMMM().format(focusedDay), // Use DateFormat from intl package
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    focusedDay = DateTime(focusedDay.year, focusedDay.month + 1, focusedDay.day);
                  });
                },
              ),
            ],
          ),
          TableCalendar(
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
              rangeHighlightColor: Colors.transparent,
              selectedTextStyle: TextStyle(color: Colors.white),
              selectedDecoration: BoxDecoration(
                color: Colors.blue, // Customize the color here
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
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Selected Date: ${selectedDay.toString().substring(0, 10)}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







/*import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class Meditaion extends StatefulWidget {
  const Meditaion({Key? key}) : super(key: key);

  @override
  State<Meditaion> createState() => _MeditaionState();
}

class _MeditaionState extends State<Meditaion> {
  Map<DateTime, int> datasets = {
    DateTime(2023, 5, 6): 3,
    DateTime(2023, 5, 7): 7,
    DateTime(2023, 5, 8): 10,
    DateTime(2023, 5, 9): 13,
    DateTime(2023, 5, 13): 6,
  };

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

  }

  void colorToday() {
    setState(() {
      datasets[DateTime.now()] = 5; // Change the value to the desired color set
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
              child: Align(
                alignment: Alignment.center,
                child: HeatMap(
                  datasets: datasets,

                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(Duration(days: 75)),
                  colorMode: ColorMode.opacity,
                  showText: false,
                  scrollable: true,
                  size: 30,
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
            ElevatedButton(
              onPressed: (() => colorToday()),
              child: Text('Color Today'),
            ),
          ],
        ),
      ),
    );
  }
}*/