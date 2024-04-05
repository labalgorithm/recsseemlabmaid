import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../HeaderandFooter/footer.dart';
import '../../../domain/event.dart';
import '../../../Event/view/new_event_edit.dart';
import '../../../Event/src/month_view/month_view.dart';

import '../../../Event/Calendar/src/calendar_event_data.dart';
import '../../../Event/Calendar/src/constants.dart';
import '../../../Event/Calendar/src/extensions.dart';
import '../../../Event/Calendar/src/style/header_style.dart';
import '../../../Event/Calendar/src/typedefs.dart';
import '../../../Event/Calendar/src/components/common_components.dart';
import '../../view/new_event_show.dart';

class CircularCell extends StatelessWidget {
  /// Date of cell.
  final DateTime date;

  /// List of Events for current date.
  final List<CalendarEventData> events;

  /// Defines if [date] is [DateTime.now] or not.
  final bool shouldHighlight;

  /// Background color of circle around date title.
  final Color backgroundColor;

  /// Title color when title is highlighted.
  final Color highlightedTitleColor;

  /// Color of cell title.
  final Color titleColor;

  /// This class will defines how cell will be displayed.
  /// To get proper view user [CircularCell] with 1 [MonthView.cellAspectRatio].
  const CircularCell({
    Key? key,
    required this.date,
    this.events = const [],
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightedTitleColor = Constants.white,
    this.titleColor = Constants.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: shouldHighlight ? backgroundColor : Colors.transparent,
        child: Text(
          "${date.day}",
          style: TextStyle(
            fontSize: 20,
            color: shouldHighlight ? highlightedTitleColor : titleColor,
          ),
        ),
      ),
    );
  }
}

class FilledCell<T extends Object?> extends StatelessWidget {
  /// Date of current cell.
  final DateTime date;

  /// List of events on for current date.
  final List<CalendarEventData<T>> events;

  /// defines date string for current cell.
  final StringProvider? dateStringBuilder;

  /// Defines if cell should be highlighted or not.
  /// If true it will display date title in a circle.
  final bool shouldHighlight;

  /// Defines background color of cell.
  final Color backgroundColor;

  /// Defines highlight color.
  final Color highlightColor;

  /// Color for event tile.
  final Color tileColor;

  /// Called when user taps on any event tile.
  final TileTapCallback<T>? onTileTap;

  /// defines that [date] is in current month or not.
  final bool isInMonth;

  /// defines radius of highlighted date.
  final double highlightRadius;

  /// color of cell title
  final Color titleColor;

  /// color of highlighted cell title
  final Color highlightedTitleColor;

  /// This class will defines how cell will be displayed.
  /// This widget will display all the events as tile below date title.
  const FilledCell({
    Key? key,
    required this.date,
    required this.events,
    this.isInMonth = false,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.onTileTap,
    this.tileColor = Colors.blue,
    this.highlightRadius = 11,
    this.titleColor = Colors.black,
    this.highlightedTitleColor = Constants.white,
    this.dateStringBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor:
            shouldHighlight ? highlightColor.withOpacity(1.0) : Colors.transparent,
            child: Text(
              dateStringBuilder?.call(date) ?? "${date.day}",
              style: TextStyle(
                color: shouldHighlight
                    ? highlightedTitleColor
                    : isInMonth
                    ? titleColor
                    : titleColor.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      events.length,
                          (index) => GestureDetector(
                        onTap: () {
                          onTileTap?.call(events[index], events[index].date);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Text(
                                      "${returnTitle(events[index].title, events[index].unit!)}",
                                      style: TextStyle(
                                        color: events[index].color,
                                      ),
                                  ),
                                  children: [
                                    SimpleDialogOption(
                                      child: Text('投稿者：${events[index].name!}'),
                                    ),
                                    SimpleDialogOption(
                                      child: (() {
                                        if (DateTime(events[index].date.year, events[index].date.month, events[index].date.day) == DateTime(events[index].endDate.year, events[index].endDate.month, events[index].endDate.day)) {
                                          return Text('日付：${DateFormat('MM/dd(EEE)').format(events[index].date)}');
                                        }
                                        return Text('期間：${DateFormat('MM/dd(EEE)').format(events[index].date)}〜${DateFormat('MM/dd(EEE)').format(events[index].endDate)}');
                                      })(),
                                    ),
                                    SimpleDialogOption(
                                      child: Text('時刻：${DateFormat('aa HH:mm').format(events[index].startTime!)}〜${DateFormat('aa HH:mm').format(events[index].endTime!)}'),
                                    ),
                                    SimpleDialogOption(
                                      child: Text(events[index].description),
                                    ),
                                    SimpleDialogOption(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.clear),
                                                color: Colors.grey,
                                                iconSize: 30,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child:Center(
                                                child: IconButton(
                                                  onPressed: () async {
                                                    await showConfirmDialog(context, events[index]);
                                                  },
                                                  icon: const Icon(Icons.delete_forever_rounded),
                                                  color: Colors.red,
                                                  iconSize: 30,
                                                ),
                                              ),
                                          ),
                                          Expanded(
                                            child:Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                          return NewEventShow(events[index]);
                                                        }
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.description),
                                                color: Colors.black,
                                                iconSize: 30,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child:Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                          return NewEventEdit(events[index]);
                                                        }
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.edit),
                                                color: Colors.blueAccent,
                                                iconSize: 30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: events[index].color,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 3.0),
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  returnTitle(events[index].title, events[index].unit!),
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: events[0].titleStyle ??
                                      TextStyle(
                                        color: events[index].color.accent,
                                        fontSize: 12,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Future delete(Event event) {
  final user = FirebaseAuth.instance.currentUser;
  if ( user!.uid != event.userId){
    throw 'イベント投稿者ではないため、削除できません。';
  }
  return FirebaseFirestore.instance.collection('events').doc(event.id).delete();
}

Future showConfirmDialog(BuildContext context, CalendarEventData events) {
  Event event = Event(
      events.id!, events.title, events.startTime!, events.endTime!, events.unit!, events.description, events.mailSend, events.userId!, events.color.value);
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除の確認"),
          content: Text("『${returnTitle(events.title, events.unit!)}』を削除しますか？"),
          actions: [
            TextButton(
              child: const Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("はい"),
              onPressed: () async {
                //modelで削除
                try {
                  await delete(event);

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) {
                          return const Footer(pageNumber: 0);
                        }
                    ),
                  );

                  final snackBar = SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text("${event.title}を削除しました"),
                  );
                  ScaffoldMessenger.of(context).
                  showSnackBar(snackBar);
                }
                catch (e){
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      }
  );
}

String returnTitle(String title, String unit) {
  if(title=='ミーティング'){
    return '$unit$title';
  }
  else {
    return title;
  }
}

class MonthPageHeader extends CalendarPageHeader {
  /// A header widget to display on month view.
  const MonthPageHeader({
    Key? key,
    VoidCallback? onNextMonth,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousMonth,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    StringProvider? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
    key: key,
    date: date,
    onNextDay: onNextMonth,
    onPreviousDay: onPreviousMonth,
    onTitleTapped: onTitleTapped,
    // ignore_for_file: deprecated_member_use_from_same_package
    backgroundColor: backgroundColor,
    iconColor: iconColor,
    dateStringBuilder:
    dateStringBuilder ?? MonthPageHeader._monthStringBuilder,
    headerStyle: headerStyle,
  );
  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.year}年　${date.month}月";
}

class WeekDayTile extends StatelessWidget {
  /// Index of week day.
  final int dayIndex;

  /// display week day
  final String Function(int)? weekDayStringBuilder;

  /// Background color of single week day tile.
  final Color backgroundColor;

  /// Should display border or not.
  final bool displayBorder;

  /// Style for week day string.
  final TextStyle? textStyle;

  /// Title for week day in month view.
  const WeekDayTile({
    Key? key,
    required this.dayIndex,
    this.backgroundColor = Constants.white,
    this.displayBorder = true,
    this.textStyle,
    this.weekDayStringBuilder,
  }) : super(key: key);

  Color backgroundColors(int index) {
    if(index == 6) {
      return Colors.red.withOpacity(0.2);
    }
    else if(index == 5) {
      return Colors.blue.withOpacity(0.2);
    }
    else {
      return backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColors(dayIndex),
        border: displayBorder
            ? Border.all(
          color: Colors.grey,
          width: 1.0,
        )
            : null,
      ),
      child: Text(
        weekDayStringBuilder?.call(dayIndex) ?? Constants.weekTitles[dayIndex],
        style: textStyle ??
            const TextStyle(
              fontSize: 17,
              color: Constants.black,
            ),
      ),
    );
  }
}
