class ChatRoom {
  ChatRoom(this.id, this.roomName, this.admin, this.recentMessage, this.recentMessageSender, this.createdAt, this.members, this.imgURL);
  String id;
  String roomName;
  List<dynamic> admin;
  String recentMessage;
  String recentMessageSender;
  DateTime createdAt;
  List<dynamic> members;
  String imgURL;
}

class ChatRoomSearch {
  ChatRoomSearch(this.id, this.roomName, this.admin, this.recentMessage, this.recentMessageSender, this.createdAt, this.members, this.imgURL);
  String id;
  String roomName;
  String admin;
  String recentMessage;
  String recentMessageSender;
  DateTime createdAt;
  List<dynamic> members;
  String imgURL;
}
