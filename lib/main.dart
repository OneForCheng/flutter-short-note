import 'package:flutter/material.dart';

void main() {
  runApp(ShortNoteApp());
}

class ShortNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Short Note List',
      home: new ShortNoteList(),
    );
  }
}

class ShortNoteList extends StatefulWidget {
  @override
  createState() => new ShortNoteListState();
}

class ShortNoteListState extends State<ShortNoteList> {
  List<String> _shortNoteItems = [];

  Widget _buildShortNoteList() {
    return new ListView.builder(
      itemCount: _shortNoteItems.length,
      itemBuilder: (context, index) {
        return _buildShortNoteItem(_shortNoteItems[index]);
      },
    );
  }

  Widget _buildShortNoteItem(String shortNoteText) {
    return new ListTile(title: new Text(shortNoteText));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('ShortNote List')),
      body: _buildShortNoteList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddShortNoteScreen,
          tooltip: 'Add note',
          child: new Icon(Icons.add)),
    );
  }

  void _addShortNoteItem(String item) {
    setState(() => _shortNoteItems.add(item));
  }

  void _pushAddShortNoteScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new note')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              final trimStr = val.trim();
              if (trimStr.length > 0) {
                _addShortNoteItem(trimStr);
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
