import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:short_note/database/noteSqlite.dart';
import 'package:short_note/models/note.dart';

class NoteList extends StatefulWidget {
  @override
  createState() => new NoteListState();
}

class NoteListState extends State<NoteList> {
  final DateFormat _dateTimeFormat = new DateFormat('yyyy-MM-dd hh:mm');
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    List<Note> notes = await NoteSqlite.queryAll();

    setState(() {
      _notes = notes;
    });
  }

  @override
  dispose() async {
    super.dispose();
    await NoteSqlite.close();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('便签'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.note_add),
            onPressed: _pushAddNoteScreen,
            tooltip: '添加便签',
          ),
        ],
      ),
      body: _buildNoteList(),
    );
  }

  Widget _buildNoteList() {
    return new ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        return _buildNote(_notes[index], index);
      },
    );
  }

  Widget _buildNote(Note note, int index) {
    return new Card(
      child: new InkWell(
        onTap: () => _promptEditNote(index),
        child: new Padding(
          padding: EdgeInsets.all(8.0),
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  note.content,
                  style: TextStyle(fontSize: 10),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
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
    Note note = await NoteSqlite.insert(new Note(text, DateTime.now().toString()));

    setState(() => _notes.add(note));
  }

  void _removeNote(int index) async {
    int id = _notes[index].id;

    await NoteSqlite.delete(id);

    setState(() => _notes.removeAt(index));
  }

  void _updateNote(int index, String text) async {
    Note target = _notes[index];
    Note newNote = new Note(text, DateTime.now().toString(), target.id);

    await NoteSqlite.update(newNote);

    setState(() {
      _notes[index] = newNote;
    });
  }

  void _pushAddNoteScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('添加便签')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              final text = val.trim();
              if (text.length > 0) {
                _addNote(text);
                Navigator.pop(context);
              }
            },
            decoration: new InputDecoration(
                hintText: '记事', contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  void _promptRemoveNote(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
              content: Text("是否要删除？"),
              actions: <Widget>[
                new CupertinoDialogAction(
                    child: new Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                new CupertinoDialogAction(
                    child: new Text(
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

  void _promptEditNote(int index) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final originalText = _notes[index].content;
      return new Scaffold(
          appBar: new AppBar(
            title: new Text('编辑便签'),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _promptRemoveNote(index),
                tooltip: '移除便签',
              ),
            ],
          ),
          body: new TextField(
            controller: new TextEditingController(text: originalText),
            onSubmitted: (val) {
              final text = val.trim();
              if (text.length > 0) {
                if (text != originalText) {
                  _updateNote(index, text);
                }
                Navigator.pop(context);
              }
            },
            decoration: new InputDecoration(
                hintText: '记事', contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
