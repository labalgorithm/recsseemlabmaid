class Board {
  Board(this.id, this.title, this.start, this.end, this.description, this.mailSend, this.userId);
  String id;
  String title;
  DateTime start;
  DateTime end;
  String description;
  bool mailSend;
  String userId;
}