import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  EditNotePage(this.note);

  @override
  createState() => EditNotePageState();
}

class EditNotePageState extends State<EditNotePage> {
  @override
  Widget build(BuildContext context) {
    final Note note = widget.note;

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
              _updateNoteContent(note, text);
            }
            Navigator.pop(context);
          }
        },
        decoration: InputDecoration(
            hintText: '记事', contentPadding: const EdgeInsets.all(16.0)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateNoteState(note);
          Navigator.pop(context);
        },
        child: Icon(note.completed == 0 ? Icons.done : Icons.redo),
      ),
    );
  }

  void _removeNote(int id) async {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);
    bloc.deleteNote(id);
  }

  void _updateNoteContent(Note note, String text) async {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);
    Note clone = note.clone();
    clone.content = text;
    bloc.updateNote(clone);
  }

  void _updateNoteState(Note note) async {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);
    Note clone = note.clone();
    clone.completed = note.completed == 0 ? 1 : 0;
    bloc.updateNote(clone);
  }

  void _promptRemoveNote(int id) {
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
                      _removeNote(id);
                      final nav = Navigator.of(context);
                      nav.pop();
                      nav.pop();
                    })
              ]);
        });
  }
}
