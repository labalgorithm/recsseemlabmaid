import 'package:flutter/material.dart';

import '../../Event/Calendar/model/calendar_event.dart';
import '../src/day_view/day_view.dart';

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
