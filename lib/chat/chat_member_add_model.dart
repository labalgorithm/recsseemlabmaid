import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/chat_member.dart';

class ChatMemberAddModel extends ChangeNotifier {
  List<dynamic> members = [];
  List<dynamic> newMembers = [];

  bool isLoading = false;

  List<ChatMember> memberList = [];

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void itemChange(bool val, int index, List<ChatMember> memberList) {
    memberList[index].join = val;
    if(val == true) {
      newMembers.add(memberList[index].id);
    }
    else {
      newMembers.remove(memberList[index].id);
    }
    notifyListeners();
  }

  Future fetchChatMemberAdd(String roomId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
    members = snapshot.data()!['members'].toList();

    final QuerySnapshot snap = await FirebaseFirestore.instance.collection('users').get();

    final List<ChatMember> memberList = snap.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String grade = data['grade'];
      final group = data['group'];
      final String name = data['name'];
      final String imgURL = data['imgURL'];
      return ChatMember(id, grade, group, name, imgURL, false);
    }).toList();

    this.memberList = memberList;
    members.forEach((member) {
      for(int i=0; i<memberList.length; i++) {
        if(memberList[i].id == member) {
          memberList.removeAt(i);
          break;
        }
      }
    });
    notifyListeners();
  }

  Future addMember(String roomId) async {
    if(newMembers.length == 0) {
      throw '追加メンバーなし';
    }
    else {
      
      // firestoreに更新
      newMembers.forEach((member) async {
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
          'members': FieldValue.arrayUnion([member]),
        });
        await FirebaseFirestore.instance.collection('users').doc(member).update({
          'joinChatRooms': FieldValue.arrayUnion([roomId]),
        });
        notifyListeners();
      });
      notifyListeners();
    }
  }

}