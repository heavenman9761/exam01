import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit.dart';
import 'package:exam01/database/db.dart';
import 'package:exam01/database/memo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text('Memo',
                style: TextStyle(fontSize: 36, color: Colors.blue)),
          ),
          Expanded(child: memoBuilder()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => EditPage()));
        },
        tooltip: '노트를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> LoadMemo() {
    List<Widget> memos = [];
    memos.add(Container(
      color: Colors.purpleAccent,
      height: 100,
    ));
    memos.add(Container(
      color: Colors.redAccent,
      height: 100,
    ));

    return memos;
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Widget memoBuilder() {
    return FutureBuilder<List<Memo>>(
      builder: (context, Snap) {
        if (Snap.connectionState == ConnectionState.none && Snap.hasData == null) {
          return Container(
            child: Text('메모가 없습니다.'),
          );
        }
        final List<Memo>? datas = Snap.data;
        return ListView.builder(
            itemBuilder: (context, index) {
              itemCount: datas.length;
              Memo memo = datas[index];
              return Column(
                children: [
                  Text(memo.title),
                  Text(memo.text),
                  Text(memo.editTime),
                ]
              );
            }
        );
      },
      future: loadMemo(),
    );
  }

}
