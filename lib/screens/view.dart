import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:exam01/database/db.dart';

class ViewPage extends StatelessWidget {

  const ViewPage({super.key, required this.id});

  final String id;
  // findMemo(id)[0];

  @override
  Widget build(BuildContext context) {
    return Text(id);
  }
}
