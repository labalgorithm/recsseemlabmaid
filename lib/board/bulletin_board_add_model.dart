import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../mailer/io_mailer/mailer.dart';
import '../../mailer/io_mailer/smtp_server.dart';

class BoardAddModel extends ChangeNotifier {

  String? userId;

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;

    userId = user!.uid;

  }

  Future addBoard(DateTime startDay, DateTime endDay, String userId, String title, String description, bool mailSend) async {

    final doc = FirebaseFirestore.instance.collection('boards').doc();
    //firestoreに追加
    await doc.set ({
      'title': title,
      'start': startDay,
      'end': endDay,
      'description': description,
      'mailSend': mailSend,
      'userId': userId,
    });
    notifyListeners();
  }

  Mailer(DateTime startDay, DateTime endDay, String userId, String title, String description, bool mailSend) async {
    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
    String username = 'lab.algorithm@gmail.com';
    String password = 'adjmhyfkhphypoox';

    DateFormat outputDate = DateFormat('yyyy年 MM月 dd日(EEE)');

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address('k646592@kansai-u.ac.jp')
      ..recipients.add('atukunare2@gmail.com')
      ..subject = '新しいイベントの案内 :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..ccRecipients.addAll(['k646592@kansai-u.ac.jp', 'anperdesu238@gmail.com'])
      ..html = "<h1>$title</h1>\n"
          "<p>詳細:$description</p>\n"
          "<p>期間:${outputDate.format(startDay)}-~${outputDate.format(endDay)}</p>";

    //画像やファイルを送信する場合のコード
    //..attachments = [
    //         FileAttachment(File('exploits_of_a_mom.png'))
    //           ..location = Location.inline
    //           ..cid = '<myimg@3.141>'
    //       ];
    //       ..bccRecipients.add(Address(''))   bccの設定

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE


    // Let's send another message using a slightly different syntax:
    //
    // Addresses without a name part can be set directly.
    // For instance `..recipients.add('destination@example.com')`
    // If you want to display a name part you have to create an
    // Address object: `new Address('destination@example.com', 'Display name part')`
    // Creating and adding an Address object without a name part
    // `new Address('destination@example.com')` is equivalent to
    // adding the mail address as `String`.

    // Sending multiple messages with the same connection
    //
    // Create a smtp client that will persist the connection
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // send the equivalent message

    // close the connection
    await connection.close();
  }
}

