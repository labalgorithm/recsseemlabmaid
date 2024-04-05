import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class AddMemoModel extends ChangeNotifier {
  String? title;
  String name = '';
  String? mainText;
  String? team;
  DateTime? date;
  String? userId;

  void fetchAddList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    name = userSnapshot.data()!['name'];
    userId = currentUser.uid;

    notifyListeners();
  }

  Future addMemo(String kinds) async {
    if (title == null || title!.isEmpty) {
      throw 'タイトルが入力されていません';
    }

    //firestoreに追加
    await FirebaseFirestore.instance.collection('memolist').add({
      'kinds': kinds,
      'title': title,
      'date': date,
      'id': userId,
      'team': team,
      'mainText': mainText,
    });
  }
}