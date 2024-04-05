import 'package:flutter/material.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_controller_provider.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/event_controller.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/widgets/responsive_widget.dart';
import 'package:recsseemlabmaid/attendancemanagement/pages/calendar_view_page.dart';
import 'package:recsseemlabmaid/attendancemanagement/pages/web/web_home_page.dart';
import 'package:provider/provider.dart';

import 'attendance_index_model.dart';





class AttendanceTop extends StatelessWidget {
  const AttendanceTop({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AttendanceIndexModel>(
        create: (_) => AttendanceIndexModel()..fetchEventList(),
        child: Consumer<AttendanceIndexModel>(builder: (context, model, child) {
          return CalendarControllerProvider<CalendarEvent>(
            controller: EventController<CalendarEvent>()..addAll(model.eventsList),
            child: Scaffold(
              body: ResponsiveWidget(
                mobileWidget: const ViewPageDemo(),
                webWidget: WebHomePage(),
              ),
            ),
          );
        })
    );
  }
}


