import 'package:flutter/material.dart';
import 'package:short_note/pages/noteList.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '便签',
      home: new NoteList(),
    );
  }
}

