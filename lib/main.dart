import 'package:flutter/material.dart';

void main() {
  runApp(ShortNoteApp());
}

class ShortNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Short Note List',
      home: new ShortNoteList(),
    );
  }
}

class ShortNoteList extends StatefulWidget {
  @override
  createState() => new ShortNoteListState();
}

class ShortNoteListState extends State<ShortNoteList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo List')
      )
    );
  }
}