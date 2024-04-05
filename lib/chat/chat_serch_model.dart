import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/chat_room.dart';

class ChatSearchModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  bool hasUserSearched = false;

  List<ChatRoom> chatRooms = [];
  List<dynamic> joinChatRooms = [];

  initiateSearchMethod(bool isLoading) async {
    if(searchController.text.isNotEmpty) {
      isLoading = true;
      searchByName(searchController.text);
      notifyListeners();
    }
  }

  void searchByName(String roomName) async {
    chatRooms = [];
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('rooms').where('roomName', isEqualTo: roomName).get();
    final List<ChatRoomSearch> rooms = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String roomName = data['roomName'];
      final String admin = data['admin'];
      final String recentMessage = data['recentMessage'];
      final String recentMessageSender = data['recentMessageSender'];
      final DateTime createdAt = data['createdAt'].toDate();
      final List<dynamic> members = data['members'].toList();
      final String imgURl = data['imgURL'];
      return ChatRoomSearch(id, roomName, admin, recentMessage, recentMessageSender, createdAt, members, imgURl);
    }).toList();

    for(int i=0; i<rooms.length; i++) {
      if(joinChatRooms.where((joinRoom) => joinRoom.toString() == rooms[i].id).isEmpty) {
        FirebaseFirestore.instance.collection('users').doc(rooms[i].admin).snapshots().listen((DocumentSnapshot snapshot) {
          chatRooms.add(ChatRoom(
              rooms[i].id,
              rooms[i].roomName,
              [rooms[i].admin, snapshot.get('name')],
              rooms[i].recentMessage,
              rooms[i].recentMessageSender,
              rooms[i].createdAt,
              rooms[i].members,
              rooms[i].imgURL
          ));
        });
      }
    }
    notifyListeners();
  }

  void fetchChatSearch() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      joinChatRooms = snapshot.get('joinChatRooms').toList();
    });

    notifyListeners();
  }

  Future entryRoom(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'joinChatRooms': FieldValue.arrayUnion([id]),
    });

    FirebaseFirestore.instance.collection('rooms').doc(id).update({
      'members': FieldValue.arrayUnion([user.uid]),
    });
    notifyListeners();
  }

}