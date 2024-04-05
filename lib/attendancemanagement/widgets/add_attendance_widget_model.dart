import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_event_data.dart';


import 'package:http/http.dart' as http;


class CreateAttendanceModel extends ChangeNotifier {

  String? username;
  String? userId;
  String? email;

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      username = snapshot.get('name');
      email = snapshot.get('email');
    });
    userId = user.uid;
  }

  Future addEvent(CalendarEventData<CalendarEvent> event, bool mailSend) async {
    final startDay = DateTime(event.date.year,event.date.month, event.date.day, event.startTime!.hour, event.startTime!.minute);
    DateTime endDay = DateTime(event.endDate.year,event.endDate.month, event.endDate.day, event.endTime!.hour, event.endTime!.minute);

    if(event.title == '遅刻' || event.title == '早退') {
      endDay = startDay;
    }

    final doc = FirebaseFirestore.instance.collection('attendances').doc();
    //firestoreに追加
    await doc.set ({
      'title': event.title,
      'start': startDay,
      'end': endDay,
      'description': event.description,
      'mailSend': event.mailSend,
      'userId': event.userId,
      'color': event.color.value,
    });

    if(mailSend == true) {
      emailSend(event);
    }
    notifyListeners();
  }

  emailSend(CalendarEventData<CalendarEvent> event) async {
    DateFormat outputDate = DateFormat('MM月 dd日(EEE)');
    DateFormat outputTime = DateFormat('a hh時 mm分');

    String textMessages(String title) {
      if(title == '遅刻') {
        if(event.startTime!.hour ==0 && event.startTime!.minute ==0) {
          return '${outputDate.format(event.date)}\n'
              '${event.name}：${event.title}\n'
              '詳細：${event.description}\n'
              '到着予定時刻：未定';
        }
        else{
          return '${outputDate.format(event.date)}\n'
              '${event.name}：${event.title}\n'
              '詳細：${event.description}\n'
              '到着予定時刻：${outputTime.format(event.date)}';
        }
      }
      else if(title == '早退') {
        return '${outputDate.format(event.date)}\n'
            '${event.name}：${event.title}\n'
            '詳細：${event.description}\n'
            '早退予定時刻：${outputTime.format(event.date)}';
      }
      else {
        return '${outputDate.format(event.date)}〜${outputDate.format(event.endDate)}\n'
            '${event.name}：${event.title}\n'
            '詳細：${event.description}\n';
      }
    }
    String subject = '${event.name}：${event.title}';

    Uri url = Uri.parse('http://127.0.0.1:5000/pythonmail');
    await http.post(url, body: {'name': username, 'subject': subject, 'from': email, 'text': textMessages(event.title)});
  }
}

/*
旧式メール送信
Mailer(CalendarEventData<CalendarEvent> event) async {
    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
    String username = 'lab.algorithm@gmail.com';
    String password = 'adjmhyfkhphypoox';

    DateFormat outputDate = DateFormat('MM月 dd日(EEE)');
    DateFormat outputTime = DateFormat('a hh時 mm分');

    String textMessages(String title) {
      if(title == '遅刻') {
        if(event.date.hour ==0 && event.date.minute ==0 && event.date.second ==0) {
          return '<p>${outputDate.format(event.date)}</p>\n'
              '<p>${event.name}：${event.title}</p>\n'
              '<p>メールアドレス：${email!}</p>\n'
              '<p>${event.description}</p>\n'
              '<p>到着予定時刻：未定</p>';
        }
        else{
          return '<p>${outputDate.format(event.date)}</p>\n'
              '<p>${event.name}：${event.title}</p>\n'
              '<p>メールアドレス：${email!}</p>\n'
              '<p>${event.description}</p>\n'
              '<p>到着予定時刻：${outputTime.format(event.date)}</p>';
        }
      }
      else if(title == '早退') {
        return '<p>${outputDate.format(event.date)}</p>\n'
            '<p>${event.name}：${event.title}</p>\n'
            '<p>メールアドレス：${email!}</p>\n'
            '<p>${event.description}</p>\n'
            '<p>早退予定時刻：${outputTime.format(event.date)}</p>';
      }
      else {
        return '<p>${outputDate.format(event.date)}〜${outputDate.format(event.endDate)}</p>\n'
            '<p>${event.name}：${event.title}</p>\n'
            '<p>メールアドレス：${email!}</p>\n'
            '<p>${event.description}</p>\n';
      }
    }

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.

    // recsmail@ml.al.kansai-u.ac.jp
    final message = Message()
      ..from = Address(username, '${event.name}(${email!})')
      ..recipients.add('k646592@kansai-u.ac.jp')
      ..subject = '${event.name}：${event.title}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..ccRecipients.addAll([email])
      ..html = textMessages(event.title);

    //画像やファイルを送信する場合のコード
    //..attachments = [
    //         FileAttachment(File('exploits_of_a_mom.png'))
    //           ..location = Location.inline
    //           ..cid = '<myimg@3.141>'
    //       ];
    //       ..bccRecipients.add(Address(''))   bccの設定


    // "<h1>${event.title}</h1>\n"
    //           "<p>単位:${event.unit} </p>\n"
    //           "<p>詳細:${event.description}</p>\n"
    //           "<p>期間:${outputDate.format(event.startTime!)}-~${outputDate.format(event.endTime!)}</p>";

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
 */

