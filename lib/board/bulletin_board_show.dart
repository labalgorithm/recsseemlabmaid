import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/board.dart';


class BoardShow extends StatefulWidget {

  final Board board;
  const BoardShow(this.board, {Key? key} ) : super(key: key);

  @override
  _BoardShowState createState() => _BoardShowState(board);

}

class _BoardShowState extends State<BoardShow> {

  final Board board;
  _BoardShowState(this.board);

  DateFormat outputFormat = DateFormat('yyyy年 MM月 dd日');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: const Text(
          '掲示板詳細',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                          child: Text(outputFormat.format(board.start),
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
                          child: Text('投稿者',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(board.userId,
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
                          child: Text(outputFormat.format(board.end),
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
                          child: Text('タイトル',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                            ),

                          ),
                        ),
                        Expanded(
                          child: Text(board.title,
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
                          child: Text(board.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15.0,
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}