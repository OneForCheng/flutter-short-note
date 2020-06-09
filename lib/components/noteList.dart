import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/models/note.dart';
import 'package:short_note/pages/editNote.dart';

import 'noteItem.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;

  NoteList(this.notes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // 倒序显示
        Note note = notes[notes.length - 1 - index];
        return NoteItem(note, () => _gotoEditNotePage(context, note));
      },
    );
  }

  void _gotoEditNotePage(BuildContext context, Note note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        bloc: NoteBloc.instance,
        child: EditNotePage(note),
      );
    }));
  }
}
