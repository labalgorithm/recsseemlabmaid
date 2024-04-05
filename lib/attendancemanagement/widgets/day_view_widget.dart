import 'package:flutter/material.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseemlabmaid/attendancemanagement/src/day_view/day_view.dart';



class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayView<CalendarEvent>(
      key: state,
      width: width,
    );
  }
}
