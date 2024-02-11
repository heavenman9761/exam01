import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:exam01/database/db.dart';
import 'package:exam01/database/memo.dart';
import 'package:exam01/screens//edit.dart';

class ViewPage extends StatefulWidget {
  //const ViewPage({super.key});

  const ViewPage({super.key, required this.id});

  final String id;
  // String deletedId = '';

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  // final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showAlertDialog(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => EditPage(id: widget.id)))
                    .then((value) => setState(() {}));
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: LoadBuilder(),
        ));
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  LoadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              '데이터를 불러올 수 없습니다.\n\n\n\n',
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        final List<Memo>? data = snapshot.data;

        if (data != null && data.isEmpty == false) {
          Memo memo = data[0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  height: 100,
                  child: SingleChildScrollView(
                    child: Text(memo.title,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500)),
                  )),
              Text(
                "최초 작성 시간: ${memo.createTime.split('.')[0]}",
                textAlign: TextAlign.end,
              ),
              Text("최종 수정 시간: ${memo.editTime.split('.')[0]}",
                  textAlign: TextAlign.end),
              const Padding(padding: EdgeInsets.all(10)),
              Expanded(
                child: SingleChildScrollView(
                    child: Text(memo.text,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500))),
              )
            ],
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              '데이터를 불러올 수 없습니다.\n\n\n\n',
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
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
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );

    if (result == "OK") {
      setState(() {
        deleteMemo(widget.id);
        Navigator.pop(context, "");
      });
    }
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }
}
