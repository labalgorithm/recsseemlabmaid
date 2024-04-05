import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';
import '../HeaderandFooter/footer.dart';
import 'individual_chat_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class IndividualChatPage extends StatefulWidget {
  final String myId;
  final String partnerId;
  const IndividualChatPage({Key? key,
    required this.myId, required this.partnerId
  }) : super(key:key);

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class ChatL10nJa extends ChatL10n {
  const ChatL10nJa({
    super.attachmentButtonAccessibilityLabel = '画像アップロード',
    super.emptyChatPlaceholder = 'メッセージがありません。',
    super.fileButtonAccessibilityLabel = 'ファイル',
    super.inputPlaceholder = 'メッセージを入力してください',
    super.sendButtonAccessibilityLabel = '送信', required super.unreadMessagesLabel,
  });
}

class _IndividualChatPageState extends State<IndividualChatPage> {

  File? imageFile;
  String? img;

  File? docFile;
  String? file;

  types.User? myUser;

  late List<types.Message> messages = [];

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<IndividualChatPageModel>(
      create: (_) => IndividualChatPageModel(myId: widget.myId, partnerId: widget.partnerId)..fetchChatMessageList(),
      child: Consumer<IndividualChatPageModel>(builder: (context, model, child) {

        myUser = model.myUser;
        messages = model.messages;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text('${model.partnerName}'),
            backgroundColor: Colors.deepOrange,
            actions: [
              IconButton(
                  onPressed: () async {

                  },
                  icon: const Icon(Icons.info)
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) {
                          return  const Footer(pageNumber: 2);
                        })
                );
              },
            ),
          ),
          body:  (myUser != null) ? Chat(
              user: myUser!,
              messages: messages,
              onSendPressed: model.handleSendPressed,
              onAttachmentPressed: handleAttachmentPressed,
              onMessageTap: model.handleMessageTap,
              onPreviewDataFetched: model.handlePreviewDataFetched,
              showUserAvatars: true,
              showUserNames: true,
              theme: const DefaultChatTheme(
                primaryColor: Colors.green,  // メッセージの背景色の変更
                userAvatarNameColors: [Colors.green],  // ユーザー名の文字色の変更
              ),
              l10n: const ChatL10nJa(unreadMessagesLabel: ''),
            ) : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
          ),
        );
      }),
    );
  }

  void handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      imageFile = File(result.path);

      if(imageFile!= null) {
        final task = await FirebaseStorage.instance.ref().child('chats/${randomString()}').putFile(imageFile!);
        task.ref.getDownloadURL();
        img = await task.ref.getDownloadURL();
      }
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: myUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: img!,
        width: image.width.toDouble(),
      );


      setState(() {
        _addMessage(message);
      });

      Map<String, dynamic> chatImageMap = {
        'message': '',
        'sendFile': '',
        'mimeType': '',
        'sendImg': message.uri,
        'height': image.height,
        'name': result.name,
        'size': bytes.length,
        'width': image.width,
        'senderId': myUser!.id,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      sendImageStore(chatImageMap, randomString());

    }
  }

  Future sendImageStore(Map<String, dynamic> chatImageData, String random) async {
    FirebaseFirestore.instance.collection('users').doc(widget.myId).collection('privateChat').doc(widget.partnerId).collection('messages').doc(random).set(chatImageData);
    FirebaseFirestore.instance.collection('users').doc(widget.partnerId).collection('privateChat').doc(widget.myId).collection('messages').doc(random).set(chatImageData);

    FirebaseFirestore.instance.collection('users').doc(widget.myId).collection('privateChat').doc(widget.partnerId).update({
      'recentMessage': chatImageData['sendImg'],
      'recentMessageSender': chatImageData['senderId'],
      'recentMessageTime': chatImageData['time'].toString(),
    });

    FirebaseFirestore.instance.collection('users').doc(widget.partnerId).collection('privateChat').doc(widget.myId).update({
      'recentMessage': chatImageData['sendImg'],
      'recentMessageSender': chatImageData['senderId'],
      'recentMessageTime': chatImageData['time'].toString(),
    });

  }

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null && result.files.single.path != null) {
      docFile = File(result.files.single.path!);

      if(docFile!= null) {
        final task = await FirebaseStorage.instance.ref().child('chats/${randomString()}').putFile(docFile!);
        task.ref.getDownloadURL();
        file = await task.ref.getDownloadURL();
      }
      final message = types.FileMessage(
        author: myUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: file!,
      );

      setState(() {
        _addMessage(message);
      });

      Map<String, dynamic> chatFileMap = {
        'message': '',
        'sendImg': '',
        'height': 0,
        'width': 0,
        'sendFile': message.uri,
        'name': result.files.single.name,
        'size': result.files.single.size,
        'mimeType': lookupMimeType(result.files.single.path!),
        'senderId': myUser!.id,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      sendFileStore(chatFileMap, randomString());

    }
  }

  Future sendFileStore(Map<String, dynamic> chatFileData, String random) async {
    FirebaseFirestore.instance.collection('users').doc(widget.myId).collection('privateChat').doc(widget.partnerId).collection('messages').doc(random).set(chatFileData);
    FirebaseFirestore.instance.collection('users').doc(widget.partnerId).collection('privateChat').doc(widget.myId).collection('messages').doc(random).set(chatFileData);

    FirebaseFirestore.instance.collection('users').doc(widget.myId).collection('privateChat').doc(widget.partnerId).update({
      'recentMessage': chatFileData['sendFile'],
      'recentMessageSender': chatFileData['senderId'],
      'recentMessageTime': chatFileData['time'].toString(),
    });

    FirebaseFirestore.instance.collection('users').doc(widget.partnerId).collection('privateChat').doc(widget.myId).update({
      'recentMessage': chatFileData['sendFile'],
      'recentMessageSender': chatFileData['senderId'],
      'recentMessageTime': chatFileData['time'].toString(),
    });

  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);
  }

}