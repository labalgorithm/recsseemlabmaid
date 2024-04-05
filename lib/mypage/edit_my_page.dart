import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../HeaderandFooter/footer.dart';
import 'edit_my_model.dart';

class EditMyPage extends StatefulWidget {
  final String name;
  final String email;
  final String group;
  final String grade;
  const EditMyPage({Key? key, required this.name, required this.email, required this.group, required this.grade}) : super(key:key);

  @override
  _EditMyPageState createState() => _EditMyPageState();
}

class _EditMyPageState extends State<EditMyPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMyPageModel>(
      create: (_) => EditMyPageModel(widget.name, widget.email, widget.group, widget.grade)..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('ユーザー情報変更'),
        ),
        body: SingleChildScrollView(
          child: Consumer<EditMyPageModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                          'メールアドレス：${model.email}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 30,
                              backgroundImage: model.imgURL != '' ? NetworkImage(model.imgURL) : const NetworkImage('https://4thsight.xyz/wp-content/uploads/2020/02/1582801063-300x300.png'),
                            ),
                          ),
                          const Expanded(
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: model.imageFile != null ?
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: kIsWeb ? model.image!.image : Image.file(model.imageFile!, fit:  BoxFit.cover,).image,
                              ) :
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 30,
                                child: Text('ここをタップ',
                                  style: TextStyle(color: Colors.black, fontSize:10),
                                ),
                              ),
                              onTap: () async {
                                await model.pickImage();
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      TextField(
                        controller: model.nameController,
                        decoration: const InputDecoration(
                          hintText: '名前(苗字のみ)',
                        ),
                        onChanged: (text) {
                          model.setName(text);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '選択した班：${model.group}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Web班',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              const Text('Web班'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Grid班',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              const Text('Grid班'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Network班',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              const Text('Network班'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: '教員',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              const Text('教員'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '選択した学年：${model.grade}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      DropdownButton(
                          value: model.grade,
                          items: const [
                            DropdownMenuItem(
                              value: 'B4',
                              child: Text('B4'),
                            ),
                            DropdownMenuItem(
                              value: 'M1',
                              child: Text('M1'),
                            ),
                            DropdownMenuItem(
                              value: 'M2',
                              child: Text('M2'),
                            ),
                            DropdownMenuItem(
                              value: 'D1',
                              child: Text('D1'),
                            ),
                            DropdownMenuItem(
                              value: 'D2',
                              child: Text('D2'),
                            ),
                            DropdownMenuItem(
                              value: 'D3',
                              child: Text('D3'),
                            ),
                            DropdownMenuItem(
                              value: '教授',
                              child: Text('教授'),
                            ),
                          ],
                          onChanged: (text) {
                            model.setGrade(text!);
                          }
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.update();
                            //ユーザー登録
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return const Footer(pageNumber: 3);
                                  }
                              ),
                            );
                          } catch (error) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(error.toString()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: const Text('変更する'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}