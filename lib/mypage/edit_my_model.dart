

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

class EditMyPageModel extends ChangeNotifier {
  EditMyPageModel(this.name, this.email, this.group, this.grade) {
    nameController.text = name;
    email = email;
    group = group;
    grade = grade;
  }

  final nameController = TextEditingController();

  String email;
  String name;
  String group;
  String grade;

  String? userId;
  String imgURL = '';

  File? imageFile;
  Image? image;
  final picker = ImagePicker();

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
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

  void fetchUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    userId = uid;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    imgURL = userSnapshot.data()!['imgURL'];
    notifyListeners();
  }

  Future update() async {
    name = nameController.text;

    if(name==''){
      throw '名前が入力されていません。';
    }
    if(group==''){
      throw 'グループが選択されていません。';
    }
    if(grade==''){
      throw '学年が選択されていません。';
    }

    
    final doc = FirebaseFirestore.instance.collection('users').doc();
    String? imgURL;
    if(imageFile != null) {
      final task = await FirebaseStorage.instance.ref('users/${doc.id}').putFile(imageFile!);
      task.ref.getDownloadURL();
      imgURL = await task.ref.getDownloadURL();
    }

    imgURL ??= this.imgURL;
    
    
    //firestoreに更新
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'name': name,
      'group': group,
      'grade': grade,
      'imgURL': imgURL,
      'update': DateTime.now(),
    });
    notifyListeners();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      imageFile = File(pickedFile.path);
      Uint8List imageBytes = await File(pickedFile.path).readAsBytes();
      image = Image.memory(imageBytes);
    }
    notifyListeners();
  }

}