import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerModel extends ChangeNotifier {

  String email = '';
  String name = '';
  String group = '';
  String grade = '';
  String status = '';

  void fetchUserList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    email = userSnapshot.data()!['email'];
    name = userSnapshot.data()!['name'];
    group = userSnapshot.data()!['group'];
    grade = userSnapshot.data()!['grade'];
    status = userSnapshot.data()!['status'];
    notifyListeners();
  }

}