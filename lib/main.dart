import 'package:flutter/material.dart';

void main() {
  runApp(ShortNoteApp());
}

class ShortNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Short Note List',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Short Note List')
        )
      ),
    );
  }
}