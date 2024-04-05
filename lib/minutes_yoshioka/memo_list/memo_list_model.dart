import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import '../domain/memo.dart';

class MemoListModel extends ChangeNotifier {

  List<Memo> webMeet = [];
  List<Memo> webOther = [];
  List<Memo> netMeet = [];
  List<Memo> netOther = [];
  List<Memo> machineMeet = [];
  List<Memo> machineOther = [];
  List<Memo> teMeet = [];
  List<Memo> teOther = [];
  List<Memo> allMeet = [];
  List<Memo> allOther = [];

  void fetchMemoList() async {

    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('memolist').get();
    final List<Memo> memo = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final DateTime date = data['date'].toDate();
      final String userId = data['id'];
      final String team = data['team'];
      final String mainText = data['mainText'];
      final String kinds = data['kinds'];
      return Memo(id, title, date, userId, team, mainText, kinds);
    }).toList();


    for(var i=0; i<memo.length; i++) {
      FirebaseFirestore.instance.collection('users').doc(memo[i].name).snapshots().listen((DocumentSnapshot snapshot) {
        if(memo[i].kinds == 'ミーティング' && memo[i].team == 'Web班') {
          webMeet.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'その他' && memo[i].team == 'Web班') {
          webOther.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'ミーティング' && memo[i].team == 'Net班') {
          netMeet.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'その他' && memo[i].team == 'Net班') {
          netOther.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'ミーティング' && memo[i].team == '機械学習班') {
          machineMeet.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'その他' && memo[i].team == '機械学習班') {
          machineOther.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'ミーティング' && memo[i].team == '時間拡大班') {
          teMeet.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'その他' && memo[i].team == '時間拡大班') {
          teOther.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else if(memo[i].kinds == 'ミーティング' && memo[i].team == 'All') {
          allMeet.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }
        else {
          allOther.add(
              Memo(memo[i].id, memo[i].title, memo[i].date, snapshot.get('name'), memo[i].team, memo[i].mainText, memo[i].kinds)
          );
        }

      });
    }



    notifyListeners();
  }
}