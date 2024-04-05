import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../HeaderandFooter/drawer.dart';
import '../add_memo/add_memo_page.dart';
import '../domain/memo.dart';

import 'memo_list_model.dart';
import 'memo_list_show.dart';

class MemoListPage extends StatelessWidget {
  const MemoListPage({super.key});

  @override
  Widget build(BuildContext context) {

    List<GroupColor> groupColorList = [GroupColor('Web班', Colors.cyanAccent), GroupColor('Net班', Colors.yellow), GroupColor('機械学習班', Colors.lightGreenAccent), GroupColor('時間拡大班', Colors.teal), GroupColor('All', Colors.purpleAccent), ];

    return ChangeNotifierProvider<MemoListModel>(
      create: (_) => MemoListModel()..fetchMemoList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('議事録'),

          backgroundColor: Colors.black,
        ),
        drawer: const UserDrawer(),
        body: Consumer<MemoListModel>(builder: (context, model, child) {

          List<Memo> memoList (String team, String kinds) {
            if(team =='Web班') {
              if(kinds == 'ミーティング') {
                return model.webMeet;
              }
              else {
                return model.webOther;
              }
            }
            else if(team == 'Net班') {
              if(kinds == 'ミーティング') {
                return model.netMeet;
              }
              else {
                return model.netOther;
              }
            }
            else if(team == '機械学習班') {
              if(kinds == 'ミーティング') {
                return model.machineMeet;
              }
              else {
                return model.machineOther;
              }
            }
            else if(team == '時間拡大班') {
              if(kinds == 'ミーティング') {
                return model.teMeet;
              }
              else {
                return model.teOther;
              }
            }
            else if(team == 'All') {
              if(kinds == 'ミーティング') {
                return model.allMeet;
              }
              else {
                return model.allOther;
              }
            }
            else {
              return [];
            }
          }

            // ListView(children: widgets)
            return ListView.builder(
              itemCount: groupColorList.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildList(groupColorList[index], memoList(groupColorList[index].group, 'ミーティング'), memoList(groupColorList[index].group, 'その他'), context),
            );
          }),

        floatingActionButton: Consumer<MemoListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMemoPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added) {
                  const snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('議事録を追加しました'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.fetchMemoList();
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }

  Widget _buildList(GroupColor list, List<Memo> memoList1, List<Memo> memoList2, BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: list.color,
      backgroundColor: list.color,
      textColor: Colors.black,
      title: Text(
        list.group,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      children: [
        ListTile(
          title: TextButton(
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => MemoListShow(memo: memoList1),
                  fullscreenDialog: true,
                ),
              );
            },
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
            ),
            child: const Text('ミーティング',
              style: TextStyle(
                color: Colors.black
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        ListTile(
          title: TextButton(
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => MemoListShow(memo: memoList2),
                  fullscreenDialog: true,
                ),
              );
            },
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
            ),
            child: const Text('その他',
              style: TextStyle(
                  color: Colors.black
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
