import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/models/note.dart';

class AddNotePage extends StatefulWidget {
  @override
  createState() => AddNotePageState();
}

class AddNotePageState extends State<AddNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: Text('添加便签')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              final text = val.trim();
              if (text.length > 0) {
                _addNote(text);
                Navigator.pop(context);
              }
            },
            decoration: InputDecoration(
                hintText: '记事', contentPadding: const EdgeInsets.all(16.0)),
          ));
  }

  void _addNote(String text) async {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);
    bloc.addNote(Note(content: text));
  }
}
