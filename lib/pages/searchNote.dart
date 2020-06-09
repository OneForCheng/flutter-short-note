import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/bloc/state.dart';
import 'package:short_note/components/noteList.dart';
import 'package:short_note/models/note.dart';

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
              body: NoteList(notes));
        });
  }
}
