import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit.dart';

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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Text(
                  'Memo',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.blue
                  )
                ),
              ),
            ],
          ),
          ...LoadMemo(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const EditPage())
          );
        },
        tooltip: '노트를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> LoadMemo() {
    List<Widget> memos = [];
    memos.add(Container(color: Colors.purpleAccent, height: 100,));
    memos.add(Container(color: Colors.redAccent, height: 100,));

    return memos;
  }
}