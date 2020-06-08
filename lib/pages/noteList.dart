import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/bloc/state.dart';
import 'package:short_note/database/noteSqlite.dart';
import 'package:short_note/models/note.dart';

import 'addNote.dart';
import 'editNote.dart';

class NoteListPage extends StatefulWidget {
  @override
  createState() => NoteListPageState();
}

class NoteListPageState extends State<NoteListPage> {
  final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd hh:mm');

  @override
  dispose() async {
    super.dispose();
    await NoteSqlite.close();
  }

  @override
  Widget build(BuildContext context) {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);

    return BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, NoteState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('便签'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.note_add),
                  onPressed: _pushAddNoteScreen,
                  tooltip: '添加便签',
                ),
              ],
            ),
            body: _buildNoteList(state.notes),
          );
        });
  }

  Widget _buildNoteList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _buildNote(notes[index]);
      },
    );
  }

  Widget _buildNote(Note note) {
    return Card(
      child: InkWell(
        onTap: () => _promptEditNote(note),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  note.content,
                  style: TextStyle(fontSize: 10),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _dateTimeFormat.format(DateTime.parse(note.createTime)),
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void _pushAddNoteScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        bloc: NoteBloc.instance,
        child: AddNotePage(),
      );
    }));
  }

  void _promptEditNote(Note note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        bloc: NoteBloc.instance,
        child: EditNotePage(note),
      );
    }));
  }
}
