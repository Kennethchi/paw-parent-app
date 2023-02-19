import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';



class DogSchedulePage extends StatefulWidget {
  @override
  _DogSchedulePageState createState() => _DogSchedulePageState();
}

class _DogSchedulePageState extends State<DogSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SfCalendar(
          firstDayOfWeek: 1,
          view: CalendarView.workWeek,
          timeSlotViewSettings: TimeSlotViewSettings(
              startHour: 9,
              endHour: 16,

              nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday]),
        ),
      ),
    );
  }
}





