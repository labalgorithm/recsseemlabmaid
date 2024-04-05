import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../HeaderandFooter/footer.dart';
import '../domain/memo.dart';
import 'edit_memo_model.dart';

class EditMemoPage extends StatefulWidget {
  final Memo memo;
  const EditMemoPage(this.memo, {super.key});

  @override
  _EditMemoPageState createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditMemoPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMemoModel>(
      create: (_) => EditMemoModel(widget.memo),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('リストを編集'),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Footer(pageNumber: 4),
                ),
              );
            },
          ),
        ),
        body: Center(
            child: Consumer<EditMemoModel>(builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: model.titleController,
                      decoration: InputDecoration(
                        labelText: 'タイトル',
                        hintText: 'タイトルを入力',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (text) {
                        model.setTitle(text);
                      },
                    ),
                    const SizedBox(height: 20,),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: '製作者名',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(model.nameController.text),
                    ),
                    RadioListTile(
                      title: const Text('Web班'),
                      value: 'Web班',
                      groupValue: model.teamController.text,
                      onChanged: (value) {
                        setState(() {
                          model.teamController.text = value!;
                          model.team = model.teamController.text;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('Net班'),
                      value: 'Net班',
                      groupValue: model.teamController.text,
                      onChanged: (value) {
                        setState(() {
                          model.teamController.text = value!;
                          model.team = model.teamController.text;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('機械学習班'),
                      value: '機械学習班',
                      groupValue: model.teamController.text,
                      onChanged: (value) {
                        setState(() {
                          model.teamController.text = value!;
                          model.team = model.teamController.text;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('時間拡大班'),
                      value: '時間拡大班',
                      groupValue: model.teamController.text,
                      onChanged: (value) {
                        setState(() {
                          model.teamController.text = value!;
                          model.team = model.teamController.text;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('All'),
                      value: 'All',
                      groupValue: model.teamController.text,
                      onChanged: (value) {
                        setState(() {
                          model.teamController.text = value!;
                          model.team = model.teamController.text;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //model.team = _team;
                        try {
                          await model.update();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Footer(pageNumber: 4),
                            ),
                          );
                        } catch(e) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).
                              showSnackBar(snackBar);
                        }
                      },
                      child: const Text('更新する')
                    ),
                  ],
                ),
              );
            })
        ),
      ),
    );
  }
}