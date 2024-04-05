import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final groupController = TextEditingController();
  final gradeController = TextEditingController();

  String? email;
  String? password;
  String? name;
  String? group;
  String? grade;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setGroup(String group) {
    this.group = group;
    notifyListeners();
  }

  void setGrade(String grade) {
    this.grade = grade;
    notifyListeners();
  }

  Future signUp() async {
    this.email = emailController.text;
    this.password = passwordController.text;
    this.name = nameController.text;
    this.group = groupController.text;
    this.grade = gradeController.text;
    String status = '未出席';

    if(grade == null || grade == ''){
      grade = 'B4';
    }

    if (email != null && password != null ) {
      //firebase authでユーザー作成
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      final user = userCredential.user;

      if (user != null) {
        final uid = user.uid;

        //firestoreに追加
        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        await doc.set({
          'uid': uid,
          'email': email,
          'name': name,
          'group': group,
          'grade': grade,
          'status': status,
          'joinChatRooms': [],
          'update': DateTime.now(),
          'imgURL': 'https://4thsight.xyz/wp-content/uploads/2020/02/1582801063-300x300.png',
        });
      }
    }
  }
}
