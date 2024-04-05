import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../domain/memo.dart';

class MainTextModel extends ChangeNotifier {
  final Memo memo;
  MainTextModel(this.memo) {
    mainTextController.text = memo.mainText;
  }

  final mainTextController = TextEditingController();

  String? mainText;

  void setMainText(String mainText) {
    this.mainText = mainText;
    notifyListeners();
  }

  Future update_main() async {
    mainText = mainTextController.text;

    // firestoreに追加
    await FirebaseFirestore.instance.collection('memolist').doc(memo.id).update({
      'mainText': mainText,
    });
  }
}