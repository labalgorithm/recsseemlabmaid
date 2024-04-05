import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../domain/memo.dart';

class EditMemoModel extends ChangeNotifier {
  final Memo memo;
  EditMemoModel(this.memo) {
    titleController.text = memo.title;
    nameController.text = memo.name;
    teamController.text = memo.team;
  }

  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final teamController = TextEditingController();

  String? title;
  String? name;
  String? team;

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }
  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setTeam(String team) {
    this.team = team;
    notifyListeners();
  }

  Future update() async {
    title = titleController.text;
    name = nameController.text;
    team = teamController.text;

    //firestoreに追加
    await FirebaseFirestore.instance.collection('memolist').doc(memo.id).update({
      'title': title,
      'name': name,
      'team': team,
    });
  }
}