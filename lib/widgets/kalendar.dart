import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Kalendar extends StatefulWidget {
  final Function datum;

  Kalendar(this.datum);
  @override
  State<StatefulWidget> createState() => _KalendarState();
}

class _KalendarState extends State<Kalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
      ),
    );
  }
}
