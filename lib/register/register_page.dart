import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../HeaderandFooter/footer.dart';
import 'register_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key:key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _group = '';
  //エラーを表示
  String? error;
  String _grade = 'B4';
  String _gradedisplay = 'B4';

  void _handleRadioButton(String group) =>
      setState(() {
        _group = group;
      });

  void _handleDropdownButton(String grade) =>
      setState(() {
        _grade = grade;
        _gradedisplay = grade;
      });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新規登録'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: model.emailController,
                        decoration: const InputDecoration(
                            hintText: 'Email　　※必要'
                        ),
                        onChanged: (text) {
                          model.setEmail(text);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: model.passwordController,
                        decoration: const InputDecoration(
                            hintText: 'Password　　※必要',
                        ),
                        onChanged: (text) {
                          model.setPassword(text);
                        },
                      ),
                      const SizedBox(
                        height: 16,
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
                        '選択した班：$_group',
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
                                groupValue: _group,
                                onChanged: (text) {
                                    _handleRadioButton(text!);
                                    model.groupController.text = _group;
                                    model.setGroup(_group);
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
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.groupController.text = _group;
                                  model.setGroup(_group);
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
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.groupController.text = _group;
                                  model.setGroup(_group);
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
                                groupValue: _group,
                                onChanged: (text) {
                                  _handleRadioButton(text!);
                                  model.groupController.text = _group;
                                  model.setGroup(_group);
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
                        '選択した学年：$_grade',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      DropdownButton(
                        value: _gradedisplay,
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
                            _handleDropdownButton(text!);
                            model.gradeController.text = _grade;
                            model.setGrade(_grade);
                          }
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.signUp();
                            //ユーザー登録
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return const Footer(pageNumber: 0);
                                  }
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            //ユーザー登録に失敗した場合
                            if (e.code == 'weak-password') {
                              error = 'パスワードが弱いです。６文字以上を入力してください。';
                            }
                            else if (e.code == 'email-already-in-use') {
                              error = 'すでに利用されているメールアドレス';
                            }
                            else if (e.code == 'invalid-email') {
                              error = 'メールアドレスの形をしていません。';
                            }
                            else {
                              error = 'アカウント作成エラー';
                            }
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(error.toString()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: const Text('登録する'),
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
