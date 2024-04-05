import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';
import 'chat_serch_model.dart';

class ChatSearchPage extends StatefulWidget {
  const ChatSearchPage({Key? key}) : super(key: key);

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatSearchModel>(
      create: (_) => ChatSearchModel()..fetchChatSearch(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepOrange,
          title: const Text('ルーム全文検索',
            style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Consumer<ChatSearchModel>(builder: (context, model, child){
            return Column(
              children: [
                Container(
                  color: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: model.searchController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search groups....',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          model.initiateSearchMethod(isLoading);
                          },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isLoading ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                ) : ListView.builder(
                  itemCount: model.chatRooms.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.deepOrange,
                            child: Text(model.chatRooms[index].roomName.substring(0,1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(model.chatRooms[index].roomName),
                          subtitle: Text(model.chatRooms[index].admin[1]),
                        trailing: IconButton(
                          onPressed: () async {
                            model.entryRoom(model.chatRooms[index].id);
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context){
                                return ChatPage(roomId: model.chatRooms[index].id, roomName: model.chatRooms[index].roomName, adminId: model.chatRooms[index].admin[0], adminName: model.chatRooms[index].admin[1], imgURL: model.chatRooms[index].imgURL,);
                              }),
                            );
                          },
                          icon: const Icon(Icons.login_outlined),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );

          }),
        ),
      ),
    );
  }
}