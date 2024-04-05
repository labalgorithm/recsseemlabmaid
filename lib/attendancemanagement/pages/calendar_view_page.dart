import 'package:flutter/material.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_controller_provider.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_event_data.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/extension.dart';
import 'package:recsseemlabmaid/attendancemanagement/member_board.dart';
import 'package:recsseemlabmaid/attendancemanagement/widgets/day_view_widget.dart';
import 'package:recsseemlabmaid/attendancemanagement/widgets/month_view_widget.dart';
import 'package:recsseemlabmaid/attendancemanagement/widgets/week_view_widget.dart';

import '../../HeaderandFooter/drawer.dart';
import '../../timer/timer.dart';

import 'create_attendance_page.dart';


class ViewPageDemo extends StatefulWidget {
  const ViewPageDemo({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewPageDemo> createState() => _ViewPageDemoState();
}

class _ViewPageDemoState extends State<ViewPageDemo> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.timer),
                  onPressed: () async {
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return const ClockTimer();
                        })
                    );
                  }
              ),
            ),

          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
          title: const Text('出席管理'),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(text: 'Member',),
              Tab(text: 'Month',),
              Tab(text: 'Week',),
              Tab(text: 'Day',),
            ],
          ),
        ),
        drawer: const UserDrawer(),
        floatingActionButton: FloatingActionButton(
          elevation: 8,
          onPressed: _addEvent,
          child: const Icon(Icons.add),
        ),
        body: const TabBarView(
          children: [
            MemberBoardPage(),
            MonthViewWidget(),
            WeekViewWidget(),
            DayViewWidget()
          ],
        ),
      ),
    );
  }



  Future<void> _addEvent() async {
    final event = await context.pushRoute<CalendarEventData<CalendarEvent>>(
      const CreateAttendancePage(
        withDuration: true,
      ),
    );
    if (event == null) return;
    CalendarControllerProvider.of<CalendarEvent>(context).controller.add(event);
  }
}
