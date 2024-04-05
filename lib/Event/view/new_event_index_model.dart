import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import '../../domain/event.dart';
import '../../Event/Calendar/model/calendar_event.dart';
import '../../Event/Calendar/src/calendar_event_data.dart';

class NewEventListModel extends ChangeNotifier {
  List<CalendarEventData<CalendarEvent>> eventsList = [];

  void fetchEventList() async {

    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();

    final List<Event> events = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final DateTime start = data['start'].toDate();
      final DateTime end = data['end'].toDate();
      final String unit = data['unit'];
      final String description = data['description'];
      final bool mailSend = data['mailSend'];
      final String userId = data['userId'];
      final int color = data['color'];
      return Event(id, title, start, end, unit, description, mailSend, userId, color);
    }).toList();

    String content = '';
    for(var i=0; i<events.length; i++) {
      
      if(events[i].title == 'ミーティング') {
        content = 'ミーティング';
      } else if(events[i].title == '輪講') {
        content = '輪講';
      } else {
        content = 'その他';
      }

      FirebaseFirestore.instance.collection('users').doc(events[i].userId).snapshots().listen((DocumentSnapshot snapshot) {
        eventsList.add(
            CalendarEventData(
              date: events[i].start,
              endDate: events[i].end,
              event: CalendarEvent(title: events[i].title),
              title: events[i].title,
              description: events[i].description,
              startTime: events[i].start,
              endTime: events[i].end,
              content: content,
              mailSend: events[i].mailSend,
              unit: events[i].unit,
              id: events[i].id,
              color:  Color(events[i].color),
              name: snapshot.get('name'),
              userId: events[i].userId,
            )
        );
      });
      
    }

    notifyListeners();
  }


}