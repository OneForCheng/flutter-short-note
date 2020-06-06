import 'package:short_note/models/note.dart';

class NoteState {
  int current = -1;
  List<Note> notes = [];

  NoteState(this.current, this.notes);
}