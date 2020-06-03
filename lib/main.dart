import 'package:flutter/material.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Note List',
      home: new NoteList(),
    );
  }
}

class NoteList extends StatefulWidget {
  @override
  createState() => new NoteListState();
}

class NoteListState extends State<NoteList> {
  List<String> _noteItems = [];

  Widget _buildNoteList() {
    return new ListView.builder(
      itemCount: _noteItems.length,
      itemBuilder: (context, index) {
        return _buildNoteItem(_noteItems[index]);
      },
    );
  }

  Widget _buildNoteItem(String text) {
    return new ListTile(title: new Text(text));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Note List')),
      body: _buildNoteList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddNoteScreen,
          tooltip: 'Add note',
          child: new Icon(Icons.add)),
    );
  }

  void _addNoteItem(String text) {
    setState(() => _noteItems.add(text));
  }

  void _pushAddNoteScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new note')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              final text = val.trim();
              if (text.length > 0) {
                _addNoteItem(text);
                Navigator.pop(context);
              }
            },
            decoration: new InputDecoration(
                hintText: 'Enter something...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
