import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_note/bloc/bloc.dart';
import 'package:short_note/bloc/state.dart';
import 'package:short_note/components/noteList.dart';
import 'package:short_note/database/noteSqlite.dart';

import 'addNote.dart';
import 'searchNote.dart';

class NoteListPage extends StatefulWidget {
  @override
  createState() => NoteListPageState();
}

class NoteListPageState extends State<NoteListPage> {
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
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: _gotoSearchNotePage,
                  tooltip: '搜索',
                ),
                IconButton(
                  icon: const Icon(Icons.note_add),
                  onPressed: _gotoAddNotePage,
                  tooltip: '添加',
                ),
              ],
            ),
            body: NoteList(state.notes),
          );
        });
  }

  void _gotoAddNotePage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        bloc: NoteBloc.instance,
        child: AddNotePage(),
      );
    }));
  }

  void _gotoSearchNotePage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        bloc: NoteBloc.instance,
        child: SearchNotePage(),
      );
    }));
  }
}
