import 'package:flutter/material.dart';

import 'extensions.dart';

/// Stores all the events on [date]
@immutable
class CalendarEventData<T extends Object?> {
  /// Specifies date on which all these events are.
  final DateTime date;

  /// Defines the start time of the event.
  /// [endTime] and [startTime] will defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final DateTime? startTime;

  /// Defines the end time of the event.
  /// [endTime] and [startTime] defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final DateTime? endTime;

  /// Title of the event.
  final String title;

  /// Description of the event.
  final String description;

  /// Defines color of event.
  /// This color will be used in default widgets provided by plugin.
  final Color color;

  /// Event on [date].
  final T? event;

  final DateTime? _endDate;

  /// Define style of title.
  final TextStyle? titleStyle;

  /// Define style of description.
  final TextStyle? descriptionStyle;

  /// 新しく追加した機能
  /// イベントの内容
  final String content;
  /// メール送信機能
  final bool mailSend;
  /// 到着予定時刻
  final DateTime? arriveTime;
  /// 早退予定時刻
  final DateTime? leaveTime;
  /// 参加単位
  final String? unit;
  /// イベント投稿者
  final String? name;
  /// イベントID
  final String? id;
  /// ユーザID
  final String? userId;

  /// Stores all the events on [date]
  const CalendarEventData({
    required this.content,
    this.description = "",
    this.event,
    this.color = Colors.blue,
    this.startTime,
    this.endTime,
    this.titleStyle,
    this.descriptionStyle,
    this.title = "",
    this.mailSend = true,
    this.arriveTime,
    this.leaveTime,
    this.unit = "",
    this.name = '',
    this.id,
    this.userId,
    DateTime? endDate,
    required this.date,
  }) : _endDate = endDate;

  DateTime get endDate => _endDate ?? date;

  Map<String, dynamic> toJson() => {
    "date": date,
    "startTime": startTime,
    "endTime": endTime,
    "event": event,
    "title": title,
    "description": description,
    "content": content,
    "mailSend": mailSend,
    "name": name,
    "arriveTime": arriveTime,
    "leaveTime": leaveTime,
    "endDate": endDate,
    "id": id,
    "userId": userId,
  };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) {
    return other is CalendarEventData<T> &&
        date.compareWithoutTime(other.date) &&
        endDate.compareWithoutTime(other.endDate) &&
        ((event == null && other.event == null) ||
            (event != null && other.event != null && event == other.event)) &&
        ((startTime == null && other.startTime == null) ||
            (startTime != null &&
                other.startTime != null &&
                startTime!.hasSameTimeAs(other.startTime!))) &&
        ((endTime == null && other.endTime == null) ||
            (endTime != null &&
                other.endTime != null &&
                endTime!.hasSameTimeAs(other.endTime!))) &&
        title == other.title &&
        color == other.color &&
        titleStyle == other.titleStyle &&
        descriptionStyle == other.descriptionStyle &&
        description == other.description;
  }

  @override
  int get hashCode => super.hashCode;
}
