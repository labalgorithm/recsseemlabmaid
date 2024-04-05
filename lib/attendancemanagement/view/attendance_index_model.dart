import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_event_data.dart';

import '../../domain/attendance.dart';


class AttendanceIndexModel extends ChangeNotifier {
  List<CalendarEventData<CalendarEvent>> eventsList = [];
  List<Attendance> events = [];

  void fetchEventList() async {

    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('attendances').get();

    final List<Attendance> events = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'].toString();
      final DateTime start = data['start'].toDate();
      final DateTime end = data['end'].toDate();
      final String description = data['description'];
      final bool mailSend = data['mailSend'];
      final String userId = data['userId'];
      final int color = data['color'];
      return Attendance(id, title, start, end, description, mailSend, userId, color);
    }).toList();

    for(var i=0; i<events.length; i++) {

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
              content: events[i].title,
              mailSend: events[i].mailSend,
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