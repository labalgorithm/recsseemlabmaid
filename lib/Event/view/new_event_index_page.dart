import 'package:flutter/material.dart';
import 'package:recsseemlabmaid/Event/pages/calendar_view_page.dart';
import 'package:recsseemlabmaid/Event/pages/web/web_home_page.dart';
import 'package:provider/provider.dart';

import '../../Event/Calendar/model/calendar_event.dart';

import '../../Event/Calendar/src/calendar_controller_provider.dart';
import '../../Event/Calendar/src/event_controller.dart';
import '../../Event/Calendar/widgets/responsive_widget.dart';
import 'new_event_index_model.dart';


class TopPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<NewEventListModel>(
      create: (_) => NewEventListModel()..fetchEventList(),
      child: Consumer<NewEventListModel>(builder: (context, model, child) {
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


