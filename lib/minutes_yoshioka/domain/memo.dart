import 'dart:ui';

class Memo {
  Memo(this.id, this.title, this.date, this.name, this.team, this.mainText, this.kinds);
  String id;
  String title;
  DateTime date;
  String name;
  String team;
  String mainText;
  String kinds;
}

class GroupColor {
  GroupColor(this.group, this.color);
  String group;
  Color color;
}
