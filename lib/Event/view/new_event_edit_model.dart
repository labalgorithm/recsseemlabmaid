import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../Event/Calendar/model/calendar_event.dart';
import '../../Event/Calendar/src/calendar_event_data.dart';

import '../../mailer/io_mailer/mailer.dart';
import '../../mailer/io_mailer/smtp_server.dart';

class NewEditEventModel extends ChangeNotifier {

  String? username;
  String? userId;

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      username = snapshot.get('name');
    });
    userId = user.uid;
  }

  Future editEvent(CalendarEventData<CalendarEvent> event) async {
    final startDay = DateTime(event.date.year,event.date.month, event.date.day, event.startTime!.hour, event.startTime!.minute);
    final endDay = DateTime(event.endDate.year,event.endDate.month, event.endDate.day, event.endTime!.hour, event.endTime!.minute);

    // firestoreに更新
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'title': event.title,
      'start': startDay,
      'end': endDay,
      'unit': event.unit,
      'description': event.description,
      'mailSend': event.mailSend,
      'userId': event.userId,
      'color': event.color.value,
    });
    notifyListeners();
  }

  Mailer(CalendarEventData<CalendarEvent> event) async {
    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
    String username = 'lab.algorithm@gmail.com';
    String password = 'adjmhyfkhphypoox';

    DateFormat outputDate = DateFormat('yyyy年 MM月 dd日(EEE) a hh:mm');

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, event.name)
      ..recipients.add('atukunare2@gmail.com')
      ..subject = '新しいイベントの案内 :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..ccRecipients.addAll(['k646592@kansai-u.ac.jp', 'anperdesu238@gmail.com'])
      ..html = "<h1>${event.title}</h1>\n"
          "<p>単位:${event.unit} </p>\n"
          "<p>詳細:${event.description}</p>\n"
          "<p>期間:${outputDate.format(event.startTime!)}-~${outputDate.format(event.endTime!)}</p>";

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

