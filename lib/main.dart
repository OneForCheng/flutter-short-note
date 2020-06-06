import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_note/pages/noteList.dart';

import 'bloc/bloc.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '便签',
      home: BlocProvider(
          bloc:  NoteBloc.instance,
          child: NoteList(),
        )
    );
  }
}

