import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../domain/chat_info_list.dart';

class ChatRoomInfoModel extends ChangeNotifier {
  List<dynamic> members = [];

  List<ChatInfoList> chatInfoList = [];

  List<dynamic> chatRooms = [];
  List<dynamic> chatMembers = [];

  void fetchChatRoomInfo(String roomId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
    members = snapshot.data()!['members'].toList();
    members.forEach((member) async {
      final DocumentSnapshot<Map<String, dynamic>> memberSnapshot = await FirebaseFirestore.instance.collection('users').doc(member).get();
      chatInfoList.add(ChatInfoList(member, memberSnapshot.data()!['name'], memberSnapshot.data()!['group'], memberSnapshot.data()!['imgURL']));
      notifyListeners();
    });
    notifyListeners();
  }

  Future withdrawalRoom(String id, String roomId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    chatRooms = snapshot.data()!['joinChatRooms'];
    chatRooms.remove(roomId);
    // firestoreに更新
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'joinChatRooms': chatRooms,
    });
    notifyListeners();
  }

  Future withdrawalMember(String id, String roomId) async {
    final DocumentSnapshot<Map<String, dynamic>> memberSnapshot = await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
    chatMembers = memberSnapshot.data()!['members'];
    chatMembers.remove(id);
    // firestoreに更新
    await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'members': chatMembers,
    });
    notifyListeners();
  }

  Future exitRoom(String roomId) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'joinChatRooms': FieldValue.arrayRemove([roomId]),
    });
    await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'members': FieldValue.arrayRemove([user.uid]),
    });
    notifyListeners();
  }
}