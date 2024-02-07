// import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:exam01/database/memo.dart';
import 'package:exam01/database/db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EditPage extends StatelessWidget {
  String title = '';
  String text = '';

  //EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveDB,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              // obscureText: true,
              onChanged: (String title){this.title = title;},
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                hintText: '제목을 적어주세요',
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              // obscureText: true,
              onChanged: (String text){this.text = text;},
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                hintText: '내용을 적어주세요',
              ),
            ),
          ],
        ),
      )

    );
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: Str2Sha512(DateTime.now().toString()),
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString()
    );

    await sd.insertMemo(fido);

    print(await sd.memos());
  }

  String Str2Sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed

    var digest = sha512.convert(bytes);

    return digest.toString();

  }
}
