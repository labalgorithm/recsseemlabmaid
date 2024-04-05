import 'package:flutter/foundation.dart';

@immutable
class CalendarEvent {
  final String title;

  const CalendarEvent({this.title = "Title"});

  @override
  bool operator ==(Object other) => other is CalendarEvent && title == other.title;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => title;
}