import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../HeaderandFooter/drawer.dart';
import 'add_room_page.dart';
import 'chat_page.dart';
import 'chat_room_model.dart';
import 'chat_search_page.dart';
import 'individual_chat_page.dart';

class ChatRoomListPage extends StatefulWidget {
  const ChatRoomListPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPage();
}

class _ChatRoomListPage extends State<ChatRoomListPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ChangeNotifierProvider<ChatRoomListModel>(
        create: (_) => ChatRoomListModel()..fetchChatRoomList(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            return const ChatSearchPage();
                          })
                      );
                    }
                ),
              ),
            ],
            backgroundColor: Colors.black,
            centerTitle: true,
            elevation: 0.0,
            title: const Text('チャット'),
            bottom: const TabBar(
              tabs: <Tab>[
                Tab(text: '個人',),
                Tab(text: 'グループ',),
              ],
            ),
          ),
          drawer: const UserDrawer(),
          body: TabBarView(
            children: [
                  Consumer<ChatRoomListModel>(builder: (context, model, child){

                    if(model.userData.isNotEmpty){
                      return Scrollbar(
                        child: ListView.builder(
                            itemCount: model.userData.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: model.userData[index].imgURL != '' ? NetworkImage(model.userData[index].imgURL) : const NetworkImage('https://4thsight.xyz/wp-content/uploads/2020/02/1582801063-300x300.png'),
                                    ),
                                    title: Text(model.userData[index].name),
                                    subtitle: Text('${model.userData[index].group}　${model.userData[index].grade}　${model.userData[index].status}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.input),
                                      onPressed: () async {
                                        await model.individualChat(model.userData[index].id);
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return IndividualChatPage(myId: model.myId!, partnerId: model.partnerId!,);
                                                }),
                                        );
                                      },
                                    ),
                                ),
                              );
                            },
                        ),
                      );
                    }
                    else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }

                  }),
                Consumer<ChatRoomListModel>(builder: (context, model, child){

                    final List<Widget> widgets = model.chatRooms.map(
                          (room) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black,
                            backgroundImage: room.imgURL != '' ? NetworkImage(room.imgURL) : const NetworkImage('https://www.seekpng.com/png/full/967-9676420_group-icon-org2x-group-icon-orange.png'),
                          ),
                          title: Text(room.roomName,),
                          subtitle: Text(room.admin[1]),
                          trailing: IconButton(
                            icon: const Icon(Icons.input),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return ChatPage(roomId: room.id, roomName: room.roomName, adminId: room.admin[0], adminName: room.admin[1], imgURL: room.imgURL,);
                                      })
                              );
                            },
                          ),
                        ),
                      ),
                    ).toList();

                    if(model.chatRooms.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                    else {
                      return Scrollbar(
                        child: ListView(
                          shrinkWrap: true,
                          children: widgets,
                        ),
                      );
                    }

                  })
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return const AddRoomPage();
                    }),
              );
            },
          ),
        ),
      ),
    );
  }
}


