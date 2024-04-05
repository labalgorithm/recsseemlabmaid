import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../HeaderandFooter/footer.dart';
import '../domain/chat_info_list.dart';
import 'chat_member_add_page.dart';
import 'chat_page.dart';
import 'chat_room_info_model.dart';

class ChatRoomInfo extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String adminId;
  final String adminName;
  final String imgURL;
  const ChatRoomInfo({Key? key, required this.roomId, required this.roomName, required this.adminId, required this.adminName, required this.imgURL}) : super(key: key);

  @override
  State<ChatRoomInfo> createState() => _ChatRoomInfoState();
}

class _ChatRoomInfoState extends State<ChatRoomInfo> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatRoomInfoModel>(
      create: (_) => ChatRoomInfoModel()..fetchChatRoomInfo(widget.roomId),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.deepOrange,
          title: const Text('ルーム詳細情報'),
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) {
                          return ChatMemberAddPage(roomId: widget.roomId, roomName: widget.roomName, adminId: widget.adminId, adminName: widget.adminName, imgURL: widget.imgURL,);
                        }),
                  );
                },
                icon: const Icon(Icons.group_add),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) {
                        return ChatPage(roomId: widget.roomId, roomName: widget.roomName, adminId: widget.adminId, adminName: widget.adminName, imgURL: widget.imgURL,);
                      }),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Consumer<ChatRoomInfoModel>(builder: (context, model, child){
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepOrange.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                          backgroundImage: widget.imgURL != '' ? NetworkImage(widget.imgURL) : const NetworkImage('https://www.seekpng.com/png/full/967-9676420_group-icon-org2x-group-icon-orange.png'),
                        ),
                        const SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ルーム名： ${widget.roomName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text('ルーム作成者： ${widget.adminName}',),
                          ],
                        ),
                      ],
                    ),
                  ),
                  memberList(model.chatInfoList, model),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget memberList(List<ChatInfoList> chatInfoList , ChatRoomInfoModel model) {
    if(chatInfoList.isNotEmpty){
      return Column(
        children: [
          const Center(
            child: Text('メンバーリスト',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          ListView.builder(
              itemCount: chatInfoList.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: chatInfoList[index].imgURL != '' ? NetworkImage(chatInfoList[index].imgURL) : const NetworkImage('https://4thsight.xyz/wp-content/uploads/2020/02/1582801063-300x300.png'),
                    ),
                    title: Text(chatInfoList[index].name),
                    subtitle: Text(chatInfoList[index].group),
                    trailing: iconDisplay(chatInfoList[index].id, widget.roomId, chatInfoList[index].name, model)
                  ),
                );
              },
            ),
        ],
      );
    }
    else {
      return const Text('チャットメンバーはいません');
    }
  }

  Widget iconDisplay (String id, String roomId, String name, ChatRoomInfoModel model) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if(id == currentUser!.uid) {
      return IconButton(
        onPressed: () async {
          try {
            await model.exitRoom(roomId);
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) {
                    return const Footer(pageNumber: 2);
                  }
              ),
            );
            const snackBar = SnackBar(
              backgroundColor: Colors.green,
              content: Text('退会しました'),
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
          }
        },
        icon: const Icon(Icons.exit_to_app),
      );
    }
    else {
      return IconButton(
        icon: const Icon(Icons.delete_forever_rounded),
        onPressed: () async {
          await showConfirmDialog(context, id, roomId, name, model);
        },
      );
    }
  }

  Future showConfirmDialog(BuildContext context, String id, String roomId, String name, ChatRoomInfoModel model) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: const Text("退会の確認"),
            content: Text("『${name}』を退会させますか？"),
            actions: [
              TextButton(
                child: const Text("いいえ"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("はい"),
                onPressed: () async {
                  //modelで削除
                  try {
                    await model.withdrawalRoom(id, roomId);
                    await model.withdrawalMember(id, roomId);
                    await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return ChatRoomInfo(roomId: widget.roomId, roomName: widget.roomName, adminId: widget.adminId, adminName: widget.adminName, imgURL: widget.imgURL,);
                            })
                    );
                    final snackBar = SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text("${name}を退会させました"),
                    );
                    model.fetchChatRoomInfo(roomId);
                    ScaffoldMessenger.of(context).
                    showSnackBar(snackBar);
                  }
                  catch (e){
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        }
    );
  }
}