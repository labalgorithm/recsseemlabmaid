import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/chat_member.dart';

class AddChatRoomModel extends ChangeNotifier {
  final roomNamecontroller = TextEditingController();

  String? userName;
  String? roomName;
  DateTime? createdAt;

  bool isLoading = false;

  List<ChatMember> users = [];
  List<ChatMember> netMembers = [];
  List<ChatMember> gridMembers = [];
  List<ChatMember> webMembers = [];
  List<ChatMember> teacherMembers = [];

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setRoomName(String name) {
    roomName = name;
    notifyListeners();
  }

  void itemChange(bool val, int index, List<ChatMember> groupMembers, List<ChatMember> members) {
      groupMembers[index].join = val;
      for(int i=0; i<members.length; i++) {
        if (groupMembers[index].id == members[i].id) members[i].join = val;
      }
      notifyListeners();
  }

  void radioChange(List<ChatMember> members, String radio) {
    if(radio == '') {
      for(int i=0; i<members.length; i++) {
        members[i].join = false;
      }
      notifyListeners();
    }
    else if(radio == '全体') {
      for(int i=0; i<members.length; i++) {
        members[i].join = true;
      }
    }
    else if(radio == 'Network班') {
      for(int i=0; i<members.length; i++) {
        if(members[i].group == radio) {
          members[i].join = true;
        }
        else {
          members[i].join = false;
        }
      }
    }
    else if(radio == 'Grid班') {
      for(int i=0; i<members.length; i++) {
        if(members[i].group == radio) {
          members[i].join = true;
        }
        else {
          members[i].join = false;
        }
      }
    }
    else if(radio == 'Web班') {
      for(int i=0; i<members.length; i++) {
        if(members[i].group == radio) {
          members[i].join = true;
        }
        else {
          members[i].join = false;
        }
      }
    }
    else if(radio == 'B4') {
      for(int i=0; i<members.length; i++) {
        if(members[i].grade == radio) {
          members[i].join = true;
        }
        else {
          members[i].join = false;
        }
      }
    }
    else if(radio == 'M1') {
      for(int i=0; i<members.length; i++) {
        if(members[i].grade == radio) {
          members[i].join = true;
        }
        else {
          members[i].join = false;
        }
      }
    }
    else if(radio == 'M2') {
      for(int i=0; i<members.length; i++) {
        if(members[i].grade == radio) {
          members[i].join = true;
        }
        else {
          members[i].join = false;
        }
      }
    }
    else if(radio == 'D') {
      for(int i=0; i<members.length; i++) {
        if(members[i].grade == 'D1' || members[i].grade == 'D2' || members[i].grade == 'D3') {
          members[i].join = true;
        }
        else {
          members[i].join = false;
        }
      }
    }
  }

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;

    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    final List<ChatMember> users = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String grade = data['grade'];
      final String group = data['group'];
      final String name = data['name'];
      final String imgURL = data['imgURL'];
      const bool join = true;
      return ChatMember(id, grade, group, name, imgURL, join);
    }).toList();
    notifyListeners();

    for(int i =0; i<users.length; i++) {
      if(users[i].id == user!.uid) {
        users.removeAt(i);
        break;
      }
    }

    this.users = users;

    for (var member in this.users) {
      if(member.group == 'Network班') {
        netMembers.add(member);
      } else if(member.group == 'Grid班') {
        gridMembers.add(member);
      } else if(member.group == 'Web班') {
        webMembers.add(member);
      } else {
        teacherMembers.add(member);
      }
    }

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      userName = snapshot.get('name');
      notifyListeners();
    });
    notifyListeners();
  }

  Future addRoom() async {
    final user = FirebaseAuth.instance.currentUser;

    roomName = roomNamecontroller.text;
    createdAt = DateTime.now();

    final List<String> members = [];
    members.add(user!.uid);
    for (var member in users) {
      if(member.join == true) members.add(member.id);
    }

    if (roomName == null || roomName == "") {
      throw 'ルーム名が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('rooms').doc();
    //firestoreに追加
    await doc.set ({
      'roomName': roomName,
      'admin': user.uid,
      'createdAt': createdAt,
      'members': members,
      'recentMessage': '',
      'recentMessageSender': '',
      'imgURL': 'https://www.seekpng.com/png/full/967-9676420_group-icon-org2x-group-icon-orange.png',
    });
    notifyListeners();

    members.forEach((member) async {
      await FirebaseFirestore.instance.collection('users').doc(member).update({
        'joinChatRooms': FieldValue.arrayUnion([doc.id]),
      });
    });

    notifyListeners();
  }

}