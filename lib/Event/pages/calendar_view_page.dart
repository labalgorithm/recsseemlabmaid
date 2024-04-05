import 'package:flutter/material.dart';
import 'package:recsseemlabmaid/Event/Calendar/view/extension.dart';
import 'package:recsseemlabmaid/Event/widgets/day_view_widget.dart';
import 'package:recsseemlabmaid/Event/widgets/week_view_widget.dart';

import '../../HeaderandFooter/drawer.dart';
import '../../timer/timer.dart';
import '../../Event/Calendar/model/calendar_event.dart';
import '../../Event/Calendar/src/calendar_controller_provider.dart';
import '../../Event/Calendar/src/calendar_event_data.dart';
import '../widgets/month_view_widget.dart';
import 'create_event_page.dart';

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
      length: 3,
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
                          return ClockTimer();
                        })
                    );
                  }
              ),
            ),

          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
          title: const Text('イベント'),
          bottom: const TabBar(
            tabs: <Tab>[
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
      const CreateEventPage(
        withDuration: true,
      ),
    );
    if (event == null) return;
    CalendarControllerProvider.of<CalendarEvent>(context).controller.add(event);
  }
}
