import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../HeaderandFooter/footer.dart';
import 'add_memo_model.dart';

class AddMemoPage extends StatefulWidget {
  const AddMemoPage({Key? key}) : super(key: key);

  @override
  _AddMemoPageState createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {

  String _team = 'Web班';

  String _kinds = 'ミーティング';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddMemoModel>(
      create: (_) => AddMemoModel()..fetchAddList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('議事録を追加'),
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
          child: Consumer<AddMemoModel>(builder: (context, model, child) {

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text("ミーティング"),
                        selected: _kinds == 'ミーティング',
                        backgroundColor: Colors.grey,
                        selectedColor: Colors.purpleAccent[100],
                        onSelected: (_) {
                          setState(() {
                            _kinds = 'ミーティング';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text("その他"),
                        selected: _kinds == 'その他',
                        backgroundColor: Colors.grey,
                        selectedColor: Colors.purpleAccent[100],
                        onSelected: (_) {
                          setState(() {
                            _kinds = 'その他';
                          });
                        },
                      ),
                    ],
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'タイトル',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        model.title = text;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: '製作者名',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(model.name),
                  ),
                  RadioListTile(
                    title: const Text('Web班'),
                    value: 'Web班',
                    groupValue: _team,
                    onChanged: (value) {
                      setState(() {
                        _team = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Net班'),
                    value: 'Net班',
                    groupValue: _team,
                    onChanged: (value) {
                      setState(() {
                        _team = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('機械学習班'),
                    value: '機械学習班',
                    groupValue: _team,
                    onChanged: (value) {
                      setState(() {
                        _team = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('時間拡大班'),
                    value: '時間拡大班',
                    groupValue: _team,
                    onChanged: (value) {
                      setState(() {
                        _team = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('All'),
                    value: 'All',
                    groupValue: _team,
                    onChanged: (value) {
                      setState(() {
                        _team = value!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      model.team = _team;
                      model.mainText = '';
                      model.date = DateTime.now();
                      try{
                        await model.addMemo(_kinds);
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
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('追加する')
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