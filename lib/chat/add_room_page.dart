import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../HeaderandFooter/footer.dart';
import 'add_room_model.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({Key? key}) : super(key: key);

  @override
  State<AddRoomPage> createState() => _AddRoomPage();

}

class _AddRoomPage extends State<AddRoomPage> {

  String _group = '全体';

  void _handleRadioButton(String group) =>
      setState(() {
        _group = group;
      });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddChatRoomModel>(
      create: (_) => AddChatRoomModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.clear, color: Colors.red,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Consumer<AddChatRoomModel>(builder: (context, model, child) {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    model.startLoading();
                    try {
                      await model.addRoom();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return const Footer(pageNumber: 2);
                            }
                        ),
                      );

                      const snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('チャットルームを追加しました'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      //失敗した場合

                      final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } finally {
                      model.endLoading();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("作成"),
                ),
              );
            }),
          ],
          title: const Text('ルーム作成'),
        ),
        body: Center(
          child: Consumer<AddChatRoomModel>(builder: (context, model, child) {
            final List<Widget> netMembersList = model.netMembers.asMap().entries.map((member)
            => Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.yellowAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                          alignment: Alignment.center,
                            child: Text(member.value.name),
                        ),
                    ),
                    Expanded(
                      child: Checkbox(value: member.value.join,
                          onChanged: (bool? val){
                            model.itemChange(val!, member.key, model.netMembers, model.users);
                      }),
                    )
                  ],
                ),
              ),
            ),
            ).toList();

            final List<Widget> gridMembersList = model.gridMembers.asMap().entries.map((member)
            => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.greenAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(member.value.name),
                      ),
                    ),
                    Expanded(
                      child: Checkbox(value: member.value.join,
                          onChanged: (bool? val){
                            model.itemChange(val!, member.key, model.gridMembers, model.users);
                          }),
                    )
                  ],
                ),
              ),
            ),
            ).toList();

            final List<Widget> webMembersList = model.webMembers.asMap().entries.map((member)
            => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.lightBlueAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(member.value.name),
                      ),
                    ),
                    Expanded(
                      child: Checkbox(value: member.value.join,
                          onChanged: (bool? val){
                            model.itemChange(val!, member.key, model.webMembers, model.users);
                          }),
                    )
                  ],
                ),
              ),
            ),
            ).toList();

            final List<Widget> teacherMembersList = model.teacherMembers.asMap().entries.map((member)
            => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.purpleAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(member.value.name),
                      ),
                    ),
                    Expanded(
                      child: Checkbox(value: member.value.join,
                          onChanged: (bool? val){
                            model.itemChange(val!, member.key, model.teacherMembers, model.users);
                          }),
                    )
                  ],
                ),
              ),
            ),
            ).toList();

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ルーム作成者：${model.userName}',
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const Text('チャットルーム名',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    TextFormField(
                        controller: model.roomNamecontroller,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black87,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        onChanged: (text) {
                          model.setRoomName(text);
                        },
                      ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const Text('ルーム作成日時',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Text(DateFormat('yyyy/MM/dd(EEE) a hh:mm').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const Text('チャットルームへ招待',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: '全体',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                  child: Text('全体'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Network班',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                  child: Text('Net班'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Grid班',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                  child: Text('Grid班'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Web班',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                  child: Text('Web班'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'B4',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                  child: Text('B4'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'M1',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                child: Text('M1'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'M2',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                child: Text('M2'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'D',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                child: Text('D'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: '',
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.radioChange(model.users, _group);
                                },
                              ),
                              const Expanded(
                                child: Text('OFF'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: netMembersList,
                    ),
                    Row(
                      children: gridMembersList,
                    ),
                    Row(
                      children: webMembersList,
                    ),
                    Row(children: teacherMembersList,)
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}