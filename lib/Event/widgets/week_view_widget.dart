import 'package:flutter/material.dart';

import '../../Event/Calendar/model/calendar_event.dart';
import '../src/week_view/week_view.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({Key? key, this.state, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView<CalendarEvent>(
      key: state,
      width: width,
    );
  }
}
