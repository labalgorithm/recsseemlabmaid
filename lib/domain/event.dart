class Event {
  Event(this.id, this.title, this.start, this.end, this.unit, this.description, this.mailSend, this.userId, this.color);
  String id;
  String title;
  DateTime start;
  DateTime end;
  String unit;
  String description;
  bool mailSend;
  String userId;
  int color;
}

