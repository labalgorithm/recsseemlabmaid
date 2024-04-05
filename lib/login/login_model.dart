import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/user_data.dart';

class LoginModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email;
  String? password;

  UserData? myData;

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

  Future login() async {
    email = emailController.text;
    password = passwordController.text;

    if (email != null && password != null) {
      //ログイン
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser!.uid;

      FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((DocumentSnapshot snapshot) {
        myData = UserData(snapshot.get('uid'), snapshot.get('email'), snapshot.get('grade'), snapshot.get('group'), snapshot.get('name'), snapshot.get('status'), snapshot.get('imgURL'));
      });
      notifyListeners();
    }
  }
}
