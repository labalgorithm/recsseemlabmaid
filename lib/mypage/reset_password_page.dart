import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reset_password_model.dart';

//エラーを表示
String? error;

class ResetPasswordPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResetPasswordModel>(
      create: (_) => ResetPasswordModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('パスワードリセット'),
        ),
        body: Center(
          child: Consumer<ResetPasswordModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: model.emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (text) {
                          model.setEmail(text);
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.sendPasswordResetEmail();
                            final snackBar = SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('${model.email}にメールを送信しました'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.of(context).pop();

                          } on FirebaseAuthException catch (e) {
                            //ユーザーログインに失敗した場合
                            if (e.code == 'user-not-found') {
                              error = 'ユーザーは存在しません';
                            }
                            else if (e.code == 'invalid-email') {
                              error = 'メールアドレスの形をしていません';
                            }
                            else {
                              error = 'メールを送信できません';
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
                        child: Text('送信'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black45,
                    child: Center(
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
