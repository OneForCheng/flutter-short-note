import 'package:bloc/bloc.dart';
import 'package:short_note/database/noteSqlite.dart';
import 'package:short_note/models/note.dart';
import 'state.dart';
import 'event.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  // Singleton for multiple widget
  static final NoteBloc _bloc = NoteBloc._internal();

  static NoteBloc get instance => _bloc;

  NoteBloc._internal() {
    getAllNotes();
  }

  @override
  NoteState get initialState => NoteState(-1, []);

  @override
  Stream<NoteState> mapEventToState(NoteState state, NoteEvent event) {
    return _stateHandler(state, event);
  }

  void getAllNotes() {
    this.dispatch(new GetAllNotesEvent());
  }

  void deleteNote(int id) {
    this.dispatch(new DeleteNoteEvent(id));
  }

  void addNote(Note item) {
    this.dispatch(new AddNoteEvent(item));
  }

  void updateNote(Note item) {
    this.dispatch(new UpdateNoteEvent(item));
  }

  Stream<NoteState> _stateHandler(NoteState state, NoteEvent event) async* {
    NoteState newState = state;
    if (event is GetAllNotesEvent) {
      newState = NoteState(-1, await NoteSqlite.getAll());
    }

    if (event is DeleteNoteEvent) {
      await NoteSqlite.delete(event.id);
      List<Note> notes = state.notes;
      notes.removeWhere((item) => item.id == event.id);
      newState = NoteState(-1, notes);
    }

    if (event is AddNoteEvent) {
      await NoteSqlite.insert(event.item);
      newState = NoteState(-1, await NoteSqlite.getAll());
    }

    if (event is UpdateNoteEvent) {
      await NoteSqlite.update(event.item);
      newState = NoteState(-1, await NoteSqlite.getAll());
    }

    yield newState;
  }
}
