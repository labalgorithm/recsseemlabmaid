import 'dart:convert';
import 'package:universal_io/io.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/chat_message.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class IndividualChatPageModel extends ChangeNotifier {

  final String myId;
  final String partnerId;
  IndividualChatPageModel({Key? key, required this.myId, required this.partnerId}) : super();

  final List<types.Message> messages = [];

  types.User? myUser;

  String? partnerName;

  //メッセージの受け取り
  void fetchChatMessageList() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).collection('messages').orderBy('time').get();

    List<ChatMessage> chatMessages = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String message = data['message'];
      final String senderId = data['senderId'];
      final int time = data['time'];
      final String sendImg = data['sendImg'];
      final int height = data['height'];
      final int width = data['width'];
      final String name = data['name'];
      final int size = data['size'];
      final String sendFile = data['sendFile'];
      final String mimeType = data['mimeType'];
      return ChatMessage(id, message, senderId, time, sendImg, height, width, name, size, sendFile, mimeType);
    }).toList();

    for (int i=0; i<chatMessages.length; i++){

      if(chatMessages[i].message != ''){
        FirebaseFirestore.instance.collection('users').doc(chatMessages[i].senderId).snapshots().listen((DocumentSnapshot snapshot) {
          _addMessage(types.TextMessage(
            author: types.User(
                id: chatMessages[i].senderId,
                firstName: snapshot.get('name'),
                imageUrl: snapshot.get('imgURL'),
            ),
            createdAt: chatMessages[i].time,
            id: chatMessages[i].id,
            text: chatMessages[i].message,
            status: types.Status.delivered,
          ));
        });
      }
      else if (chatMessages[i].sendImg != ''){
        FirebaseFirestore.instance.collection('users').doc(chatMessages[i].senderId).snapshots().listen((DocumentSnapshot snapshot) {
          _addMessage(types.ImageMessage(
            author: types.User(
              id: chatMessages[i].senderId,
              firstName: snapshot.get('name'),
              imageUrl: snapshot.get('imgURL'),
            ),
            createdAt: chatMessages[i].time,
            height: chatMessages[i].height.toDouble(),
            id: chatMessages[i].id,
            name: chatMessages[i].name,
            size: chatMessages[i].size,
            uri: chatMessages[i].sendImg,
            width: chatMessages[i].width.toDouble(),
          ));
        });
      }
      else {
        FirebaseFirestore.instance.collection('users').doc(chatMessages[i].senderId).snapshots().listen((DocumentSnapshot snapshot) {
          _addMessage(types.FileMessage(
            author: types.User(
              id: chatMessages[i].senderId,
              firstName: snapshot.get('name'),
              imageUrl: snapshot.get('imgURL'),
            ),
            createdAt: chatMessages[i].time,
            id: chatMessages[i].id,
            name: chatMessages[i].name,
            size: chatMessages[i].size,
            uri: chatMessages[i].sendFile,
            mimeType: chatMessages[i].mimeType,
          ));
        });
      }
    }

    FirebaseFirestore.instance.collection('users').doc(myId).snapshots().listen((DocumentSnapshot snapshot) {
      myUser = types.User(
        id: myId,
        firstName: snapshot.get('name'),
        imageUrl: snapshot.get('imgURL'),
      );
    });

    FirebaseFirestore.instance.collection('users').doc(partnerId).snapshots().listen((DocumentSnapshot snapshot) {
      partnerName = snapshot.get('name');
    });
    notifyListeners();

  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: myUser!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    _addMessage(textMessage);

    Map<String, dynamic> chatMessageMap = {
      'message': message.text,
      'sendImg': '',
      'height': 0,
      'name': '',
      'size': 0,
      'width': 0,
      'sendFile': '',
      'mimeType': '',
      'senderId': myUser!.id,
      'time': DateTime.now().millisecondsSinceEpoch,
    };

    sendMessageStore(chatMessageMap, randomString());

    notifyListeners();
  }

  Future sendMessageStore(Map<String, dynamic> chatMessageData, String random) async {
    FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).collection('messages').doc(random).set(chatMessageData);
    FirebaseFirestore.instance.collection('users').doc(partnerId).collection('privateChat').doc(myId).collection('messages').doc(random).set(chatMessageData);

    FirebaseFirestore.instance.collection('users').doc(myId).collection('privateChat').doc(partnerId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['senderId'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });

    FirebaseFirestore.instance.collection('users').doc(partnerId).collection('privateChat').doc(myId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['senderId'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });

  }

  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
          messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          messages[index] = updatedMessage;

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
          messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          messages[index] = updatedMessage;

        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void handlePreviewDataFetched(types.TextMessage message, types.PreviewData previewData,) {
    final index = messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    messages[index] = updatedMessage;

  }

}