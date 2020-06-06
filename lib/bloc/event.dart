import 'package:short_note/models/note.dart';

abstract class BasicEvent {}

/// Note event
class NoteEvent extends BasicEvent {}

class GetAllNotesEvent extends NoteEvent {}

class AddNoteEvent extends NoteEvent {
  Note item;
  AddNoteEvent(this.item);
}

class DeleteNoteEvent extends NoteEvent {
  int id;
  DeleteNoteEvent(this.id);
}

class UpdateNoteEvent extends NoteEvent {
  Note item;
  UpdateNoteEvent(this.item);
}