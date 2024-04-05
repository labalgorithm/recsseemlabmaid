import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../HeaderandFooter/footer.dart';
import 'bulletin_board_add_model.dart';


class BoardAddPage extends StatefulWidget {
  const BoardAddPage({super.key});

  @override
  _BoardAddPageState createState() => _BoardAddPageState();
}

class _BoardAddPageState extends State<BoardAddPage> {

  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy年 MM月 dd日');

  bool _mailSend = true;


  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<BoardAddModel>(
      create: (_) => BoardAddModel()..fetchUser(),
      child: Consumer<BoardAddModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('掲示板　新規登録'),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffb3b9ed),),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('投稿日',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                ),

                              ),
                            ),
                            Expanded(
                              child: Text(outputFormat.format(currentDate),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15,),

                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffb3b9ed),),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('掲載終了日',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  _selectedDate(context);
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(100, 20),
                                ),
                                child: Text(outputFormat.format(selectedDate),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15,),

                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffb3b9ed),),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('タイトル',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Title is empty.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15,),

                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffb3b9ed),),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('詳細',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: descriptionController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,

                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Description is empty.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 15.0,
                      ),

                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffb3b9ed),),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('メール送信',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                trailing: CupertinoSwitch(
                                    value: _mailSend,
                                    onChanged: (value) {
                                      setState(() {
                                        _mailSend = value;
                                      });
                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 15.0,
                      ),

                      GestureDetector(
                        onTap: () {
                          if(descriptionController.text == '') {
                            const snackBar =  SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('詳細の記載がありません'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          else if(titleController.text == '') {
                            const snackBar =  SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('タイトルの記載がありません'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          else {
                            if(_mailSend == true) {
                              model.Mailer(currentDate, selectedDate, model.userId!, titleController.text, descriptionController.text, _mailSend);
                            }
                            model.addBoard(currentDate, selectedDate, model.userId!, titleController.text, descriptionController.text, _mailSend);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return const Footer(pageNumber: 1);
                                  }
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 40,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff6471e9),
                            borderRadius: BorderRadius.circular(7.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xff626262),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                spreadRadius: -3,
                              )
                            ],
                          ),
                          child: const Text('Add Board',
                            style: TextStyle(
                              color: Color(0xfff0f0f0),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      }),
    );

  }

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

}




