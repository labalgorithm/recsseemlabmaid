import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../HeaderandFooter/footer.dart';
import '../domain/memo.dart';
import '../edit_memo/edit_memo_page.dart';
import '../main_text/main_text_page.dart';

import 'package:flutter_animate/flutter_animate.dart';

class MemoListShow extends StatefulWidget {

  final List<Memo> memo;
  const MemoListShow({super.key, required this.memo});

  @override
  State<MemoListShow> createState() => _MemoListShow();
}

class _MemoListShow extends State<MemoListShow> {

  int _selectedIndex = 0;
  // 最大アイテム数 / 10 (1ページの表示数)
  int _maxPage = 0;
  // 全アイテム数
  int _itemCount = 0;
  // ボタンサイズ
  final double _buttonSize = 40;
  // 選択の色
  final Color _selectedColor = Colors.green;
  // 非選択の色
  final Color _notSelectColor = Colors.amber;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Memo> memoList = widget.memo;
    memoList.sort(((a, b) => b.date.compareTo(a.date)));

    return Scaffold(
        appBar: AppBar(
          title: const Text('議事録一覧'),
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
        body: (memoList.isEmpty)?Column(
          children: [
            const Center(child: Text('Empty', style: TextStyle(fontSize: 30),),),
            Center(
              child: Image.asset('assets/labmaid.png', width: 200)
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(delay: 4000.ms, duration: 1800.ms)
                  .shake(hz: 4, curve: Curves.easeInOutCubic)
                  .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 600.ms,
              )
                  .then(delay: 600.ms)
                  .scale(
                begin: const Offset(1, 1),
                end: const Offset(1 / 1.1, 1 / 1.1),
              ),
            ),
          ],
        ):_pagenationBottombar(memoList),

    );
  }

  Future showConfirmDialog(BuildContext context, Memo memo, List<Memo> memoList) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除の確認"),
          content: Text("『${memo.title}』を削除しますか？"),
          actions: [
            TextButton(
              child: const Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("はい"),
              onPressed: () async {
                // modelで削除
                await delete(memo);
                memoList.remove(memo);
                await Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => MemoListShow(memo: memoList),
                    fullscreenDialog: true,
                  ),
                );
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('『${memo.title}』を削除しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  Future delete(Memo memo) {
    return FirebaseFirestore.instance.collection('memolist').doc(memo.id).delete();
  }



  Widget _pagenationButton(Color color, Function function, Widget widget) {
    return Container(
      height: _buttonSize,
      width: _buttonSize,
      color: color,
      margin: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          setState(
                () {
              function();
              // ↑何かしらのイベントを呼ぶ（APIとか）
            },
          );
        },
        child: Center(child: widget),
      ),
    );
  }

  Widget _pagenationBottombar(List<Memo> memoList) {
    // サンプル数
    _itemCount = memoList.length;




    // ページの最大数
    if(_itemCount % 10 == 0) {
      _maxPage = _itemCount ~/10;
    }
    else {
      _maxPage = _itemCount ~/10 + 1;
    }

    // 現在のページから前後1ページを表示する
    // ただし、先頭、末尾の時は前後1個多く表示する
    final beforecurrentPageCount = (_selectedIndex == _maxPage - 1) ? 2 : 1;
    final startPageToEndPageCount = beforecurrentPageCount * 2 + 1;

    final startpage =
    1 < _selectedIndex ? _selectedIndex - beforecurrentPageCount : 0;
    final endpage = startpage + startPageToEndPageCount < _maxPage
        ? startpage + startPageToEndPageCount
        : _maxPage;

    List<Widget> widget = [];

    // 先頭の矢印
    if (_selectedIndex != 0 && _maxPage > 1) {
      widget.add(
        _pagenationButton(
          Colors.blue,
              () {
            _selectedIndex--;
          },
          const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      );
    }

    // 1と「・・・」
    if (_selectedIndex > 0) {
      if (startpage > 0) {
        widget.add(
          _pagenationButton(
            _notSelectColor,
                () {
              _selectedIndex = 0;
            },
            const Text(
              '1',
            ),
          ),
        );
      }
      if (_selectedIndex > 2) {
        widget.add(
          Container(
            height: _buttonSize,
            width: _buttonSize,
            color: Colors.transparent,
            margin: const EdgeInsets.all(2),
            child: const Center(
              child: Icon(
                Icons.keyboard_control_outlined,
                color: Colors.black,
              ),
            ),
          ),
        );
      }
    }

    for (var i = startpage; i < endpage; i++) {
      widget.add(
        _pagenationButton(
          (i == _selectedIndex) ? _selectedColor : _notSelectColor,
              () {
            _selectedIndex = i;
          },
          Text(
            (i + 1).toString(),
          ),
        ),
      );
    }

    // _maxPageと「・・・」
    if (_maxPage - 1 > _selectedIndex) {
      if (_maxPage - 3 > _selectedIndex) {
        widget.add(
          Container(
            height: _buttonSize,
            width: _buttonSize,
            color: Colors.transparent,
            margin: const EdgeInsets.all(2),
            child: const Center(
              child: Icon(
                Icons.keyboard_control_outlined,
                color: Colors.black,
              ),
            ),
          ),
        );
      }

      if (_maxPage > endpage) {
        widget.add(
          _pagenationButton(
            _notSelectColor,
                () {
              _selectedIndex = _maxPage - 1;
            },
            Text(
              _maxPage.toString(),
            ),
          ),
        );
      }
    }

    // 末尾の矢印
    if (_selectedIndex != _maxPage - 1 && _maxPage > 1) {
      widget.add(
        _pagenationButton(
          Colors.blue,
              () {
            _selectedIndex++;
          },
          const Icon(Icons.arrow_forward_ios_outlined),
        ),
      );
    }

    List<Memo> pageMemoList = [];



    if(memoList.length % 10 != 0 && _selectedIndex == memoList.length ~/ 10) {
      pageMemoList = memoList.getRange(_selectedIndex*10, memoList.length).toList();

    }
    else {
      pageMemoList = memoList.getRange(_selectedIndex*10, _selectedIndex*10 + 10).toList();

    }

    DateFormat outputDate = DateFormat('yyyy年MM月dd日(EEE) a hh:mm');

    final List<Widget> widgets = pageMemoList.map(
          (memo) => Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '編集',
            color: Colors.grey[350],
            icon: Icons.edit,
            onTap: () async {
              final String? title = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMemoPage(memo),
                ),
              );
              if (title != null) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('『$title』を編集しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          IconSlideAction(
            caption: '削除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              // 削除しますか？って聞いて、はいだったら削除
              await showConfirmDialog(context, memo, memoList);
            },
          ),
        ],
        child: ListTile(
          title: Text('${memo.title}　${memo.team}'),
          subtitle: Text('${outputDate.format(memo.date)}    製作者名 ${memo.name}'),
          trailing: IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainTextPage(memo)),
              );
            },
          ),
        ),
      ),
    ).toList();

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: widgets,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget,
        ),
        const SizedBox(height: 50,)
      ],
    );
  }

}