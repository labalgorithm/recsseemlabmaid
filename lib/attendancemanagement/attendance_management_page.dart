
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'attendance_management_model.dart';

class AttendanceManagementPage extends StatefulWidget {
  const AttendanceManagementPage({Key? key}) : super(key: key);

  @override
  State<AttendanceManagementPage> createState() => _AttendanceManagementPage();
}

class _AttendanceManagementPage extends State<AttendanceManagementPage> {

  late int  _lastPostDay;
  late int _today;

  void resetStatus(DateTime now) {
    setState(() {
      FirebaseFirestore.instance.collection('users').
      get().then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          FirebaseFirestore.instance.collection('users').doc(doc.id).update({
            'status': '未出席'
          });
        }
      });
      FirebaseFirestore.instance.collection('days').doc('v3JVxeDZbeD9i4Xrjtvh').update({
        'day': now
      });
    });
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    _today = int.parse(DateFormat('yyyyMMdd').format(now));
    FirebaseFirestore.instance.collection('days').doc('v3JVxeDZbeD9i4Xrjtvh').snapshots().listen((DocumentSnapshot snapshot) {
      _lastPostDay = int.parse(DateFormat('yyyyMMdd').format(snapshot.get('day').toDate()));
      if (_today > _lastPostDay) {
        resetStatus(now);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AttendanceListModel>(
      create: (_) => AttendanceListModel()..fetchAttendanceList(),
      child: SingleChildScrollView(
          child: Consumer<AttendanceListModel>(builder: (context, model, child) {

            final userGroupList = model.userGroupList;

            List getUserGroup(String text) {
              return userGroupList[text] ?? [];
            }

            String network = 'Network班';
            String web = 'Web班';
            String grid = 'Grid班';
            String teacher = '教員';

            final List<Widget> netIndex = getUserGroup(network).map(
                    (user) => Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _attendanceColor(user.status),
                            border: Border.all(
                              color: Colors.black45,
                            ),
                        ),
                        child: Text('${user.name}'),
                      ),
                    ),
            ).toList();

            final List<Widget> webIndex = getUserGroup(web).map(
                  (user) => Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _attendanceColor(user.status),
                    border: Border.all(
                      color: Colors.black45,
                    ),
                  ),
                  child: Text('${user.name}'),
                ),
              ),
            ).toList();

            final List<Widget> gridIndex = getUserGroup(grid).map(
                  (user) => Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _attendanceColor(user.status),
                      border: Border.all(
                        color: Colors.black45,
                      ),
                    ),
                    child: Text('${user.name}'),
                  ),
                ),
            ).toList();

            final List<Widget> teacherIndex = getUserGroup(teacher).map(
                  (user) => Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _attendanceColor(user.status),
                    border: Border.all(
                      color: Colors.black45,
                    ),
                  ),
                  child: Text('${user.name}'),
                ),
              ),
            ).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('出席');
                            const snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("出席しました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green[400],
                          ),
                          child: const Text(
                            '出席',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              await model.attendanceUpdate('一時退席');
                              const snackBar = SnackBar(
                                backgroundColor: Colors.yellow,
                                content: Text("一時退席しました"),
                              );
                              model.fetchAttendanceList();
                              ScaffoldMessenger.of(context).
                              showSnackBar(snackBar);
                            },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.yellow,
                          ),
                          child: const Text(
                            '一時退席',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('帰宅');
                            const snackBar = SnackBar(
                              backgroundColor: Colors.grey,
                              content: Text("帰宅しました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.grey,
                          ),
                          child: const Text(
                            '帰宅',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('欠席');
                            const snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("欠席しました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            '欠席',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('未出席');
                            const snackBar = SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text("未出席になりました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            '未出席',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                          child: const Text('Net班'),
                      ),
                      Expanded(
                          child: Row(
                            children: netIndex,
                          ),
                      ),
                    ]
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                          child: const Text('Grid班'),
                        ),
                        Expanded(
                          child: Row(
                            children: gridIndex,
                          ),
                        ),
                      ]
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                          child: const Text('Web班'),
                        ),
                        Expanded(
                          child: Row(
                            children: webIndex,
                          ),
                        ),
                      ]
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                          child: const Text('教員'),
                        ),
                        Expanded(
                          child: Row(
                            children: teacherIndex,
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            );
          }),
        ),
    );
  }


  Color _attendanceColor(String text){
    if (text == '一時退席'){
      return Colors.yellow;
    }
    else if (text == '出席'){
      return Colors.green;
    }
    else if(text == '欠席'){
      return Colors.red;
    }
    else if(text == '帰宅'){
      return Colors.grey;
    }
    else {
      return Colors.blue;
    }
  }
  
}

