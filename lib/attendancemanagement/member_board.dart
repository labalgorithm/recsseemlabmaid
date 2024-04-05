
import 'package:flutter/material.dart';

import '../board/bulletin_board_add_page.dart';
import '../board/bulletin_board_page.dart';
import 'attendance_management_page.dart';


class MemberBoardPage extends StatefulWidget {
  const MemberBoardPage({Key? key}) : super(key: key);

  @override
  State<MemberBoardPage> createState() => _MemberBoardPage();
}

class _MemberBoardPage extends State<MemberBoardPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          const AttendanceManagementPage(),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(

              color: Colors.black45,
              border: Border.all(color: Colors.black26),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 3,
                ),
                const Expanded(
                  child: Text(
                      "掲示板",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return const BoardAddPage();
                              }
                          ),
                        );
                      },
                      child: const Text('新規投稿'),
                    ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: BulletinBoardPage(),
            ),
          ),
        ],
      ),
    );
  }

}

