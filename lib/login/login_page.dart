import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../HeaderandFooter/footer.dart';
import '../mypage/reset_password_page.dart';
import '../register/register_page.dart';
import 'login_model.dart';

//エラーを表示
String? error;



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('LabMaid(ログイン)Sui<3'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
          ),
          body: Center(
            child: Consumer<LoginModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: model.emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
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
                            hintText: 'Password',
                          ),
                          onChanged: (text) {
                            model.setPassword(text);
                          },
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            model.startLoading();
                            //追加の処理
                            try {
                              await model.login();
                              //ユーザー登録
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Footer(pageNumber: 0);
                                  },
                                ),
                              );

                            } on FirebaseAuthException catch (e) {
                              //ユーザーログインに失敗した場合
                              if (e.code == 'user-not-found') {
                                error = 'ユーザーは存在しません';
                              }
                              else if (e.code == 'invalid-email') {
                                error = 'メールアドレスの形をしていません';
                              }
                              else if (e.code == 'wrong-password') {
                                error = 'パスワードが間違っています';
                              }
                              else {
                                error = 'ログインエラー';
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
                          child: const Text('ログイン'),
                        ),
                        TextButton(
                          onPressed: () async {
                            //画面遷移
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: const Text('新規登録の方はこちら'),
                        ),
                        TextButton(
                          onPressed: () async {
                            //画面遷移
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordPage(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: const Text('パスワードを忘れた場合はこちら'),
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
      ),
    );
  }

}
