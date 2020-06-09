import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/bloc/state.dart';
import 'package:short_note/components/noteItem.dart';
import 'package:short_note/models/note.dart';

import 'editNote.dart';

class SearchNotePage extends StatefulWidget {
  @override
  createState() => SearchNotePageState();
}

class SearchNotePageState extends State<SearchNotePage> {
  String searched = '';

  @override
  Widget build(BuildContext context) {
    NoteBloc bloc = BlocProvider.of<NoteBloc>(context);

    return BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, NoteState state) {
          List<Note> notes = searched == ''
              ? []
              : state.notes
                  .where((element) => element.content.contains(searched))
                  .toList();

          return Scaffold(
              appBar: AppBar(
                title: TextField(
                  autofocus: true,
                  onChanged: (value) => {
                    setState(() {
                      searched = value;
                    })
                  },
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0.0),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "搜索",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  ),
                ),
              ),
              body: _buildNoteList(notes));
        });
  }

  Widget _buildNoteList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        Note note = notes[notes.length - 1 - index];
        // 倒序显示
        return NoteItem(note, () => _gotoEditNotePage(note));
      },
    );
  }

  void _gotoEditNotePage(Note note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        bloc: NoteBloc.instance,
        child: EditNotePage(note),
      );
    }));
  }
}
