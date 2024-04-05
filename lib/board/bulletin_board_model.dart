import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/board.dart';

class BulletinBoardModel extends ChangeNotifier {

  List<Board> boardsList = [];

  void fetchBoard() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('boards').get();

    final List<Board> boards = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final DateTime start = data['start'].toDate();
      final DateTime end = data['end'].toDate();
      final String description = data['description'];
      final bool mailSend = data['mailSend'];
      final String userId = data['userId'];
      return Board(id, title, start, end, description, mailSend, userId);
    }).toList();

    for(var i=0; i<boards.length; i++){
      FirebaseFirestore.instance.collection('users').doc(boards[i].userId).snapshots().listen((DocumentSnapshot snapshot) {
        boardsList.add(
            Board(boards[i].id, boards[i].title, boards[i].start, boards[i].end, boards[i].description, boards[i].mailSend, snapshot.get('name')),
        );
      });
    }


    notifyListeners();
  }

}