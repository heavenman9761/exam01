import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'write.dart';
import 'package:exam01/database/db.dart';
import 'package:exam01/database/memo.dart';
import 'package:logger/logger.dart';
import 'package:exam01/screens/view.dart';
import 'package:exam01/screens/write.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void demo() {
  logger.d('Log message with 2 methods');
  loggerNoStack.i('Info message');
  loggerNoStack.w('Just a warning!');
  logger.e('Error! Something bad happened');
  loggerNoStack.v({'key': 5, 'value': 'something'});
  Logger(printer: SimplePrinter(colors: true)).v('boom');
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deleteId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Memo App'),
      ),
      body: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
          //   child: Container(
          //     alignment: Alignment.centerLeft,
          //     child: const Text('Memo',
          //         style: TextStyle(fontSize: 36, color: Colors.blue)),
          //   ),
          // ),
          Expanded(child: memoBuilder(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => WritePage()))
              .then((value) => setState(() {}));
        },
        tooltip: '노트를 추가하려면 클릭하세요',
        label: const Text('메모 추가'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 경고'),
          content: const Text("정말 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
                setState(() {
                  deleteMemo(deleteId);
                });
                deleteId = '';
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
                deleteId = '';
              },
            ),
          ],
        );
      },
    );
  }

  Widget memoBuilder(BuildContext parentContext) {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              '메모가 없습니다.\n\n\n\n',
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        final List<Memo>? data = snapshot.data;

        if (data != null) {
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Memo memo = data[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          parentContext,
                          CupertinoPageRoute(
                              builder: (context) => ViewPage(id: memo.id))).then((value) => setState(() {}));
                    },
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          border: Border.all(
                            width: 1,
                            color: Colors.lightBlueAccent,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    memo.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    checkReturnChar(memo.text),
                                    style: const TextStyle(fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                      "최종 수정 시간: ${memo.editTime.split('.')[0]}",
                                      style: const TextStyle(fontSize: 11),
                                      textAlign: TextAlign.end),
                                ],
                              ),
                            ])),
                    onLongPress: () {
                      deleteId = memo.id;
                      showAlertDialog(parentContext);
                    });
              });
        }

        return Container(
          alignment: Alignment.center,
          child: const Text(
            '메모가 없습니다.\n\n\n\n',
            style: TextStyle(fontSize: 15, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        );
      },

    );
  }

  String checkReturnChar(String text) {
    return text.replaceAll('\n', ' ');
  }
}
