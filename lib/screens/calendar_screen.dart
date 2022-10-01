import 'package:flutter/material.dart';
import 'package:pry_20220140/screens/report_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(alignment: Alignment.centerLeft, child: Text("Reportes")),
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(3000, 1, 1),
                onDaySelected: (selectedDay, focusedDay) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportScreen(selectedDay),
                      maintainState: false));
                }),
          )
        ],
      ),
    );
  }
}
