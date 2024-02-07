import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

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
            onPressed: (){},
          )
        ],
      ),
      body: Row(),
    );
  }
}
