import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/bloc/state.dart';
import 'package:short_note/database/noteSqlite.dart';
import 'package:short_note/models/note.dart';

class NoteList extends StatefulWidget {
  @override
  createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
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

  void _addNote(String text) async {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);
    bloc.addNote(Note(text, DateTime.now().toString()));
  }

  void _removeNote(int id) async {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);
    bloc.deleteNote(id);
  }

  void _updateNote(Note note, String text) async {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);
    bloc.updateNote(Note(text, DateTime.now().toString(), note.id));
  }

  void _pushAddNoteScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
    }));
  }

  void _promptRemoveNote(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              content: Text("是否要删除？"),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                CupertinoDialogAction(
                    child: Text(
                      '确认',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () {
                      _removeNote(index);
                      final nav = Navigator.of(context);
                      nav.pop();
                      nav.pop();
                    })
              ]);
        });
  }

  void _promptEditNote(Note note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('编辑便签'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _promptRemoveNote(note.id),
                tooltip: '移除便签',
              ),
            ],
          ),
          body: TextField(
            controller: TextEditingController(text: note.content),
            onSubmitted: (val) {
              final text = val.trim();
              if (text.length > 0) {
                if (text != note.content) {
                  _updateNote(note, text);
                }
                Navigator.pop(context);
              }
            },
            decoration: InputDecoration(
                hintText: '记事', contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
