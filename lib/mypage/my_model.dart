import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/chat_room.dart';

class MyModel extends ChangeNotifier {

  List<ChatRoom> chats = [];

  List<dynamic> joinChatRooms = [];

  String email = '';
  String name = '';
  String group = '';
  String grade = '';
  String status = '';
  String imgURL = '';

  void fetchMyModel() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    email = userSnapshot.data()!['email'];
    name = userSnapshot.data()!['name'];
    group = userSnapshot.data()!['group'];
    grade = userSnapshot.data()!['grade'];
    status = userSnapshot.data()!['status'];
    joinChatRooms = userSnapshot.data()!['joinChatRooms'];
    imgURL = userSnapshot.data()!['imgURL'];
    notifyListeners();
    
    for(int i=0; i<joinChatRooms.length; i++) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('rooms').doc(joinChatRooms[i].toString()).get();
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(snapshot.get('admin')).get();
      String adminName = snap.get('name');
      chats.add(ChatRoom(snapshot.id, snapshot.get('roomName'), [snapshot.get('admin'), adminName], snapshot.get('recentMessage'), snapshot.get('recentMessageSender'), snapshot.get('createdAt').toDate(), snapshot.get('members'), snapshot.get('imgURL')));
    }

    notifyListeners();
  }

}