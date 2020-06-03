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

  void _addShortNoteItem() {
    setState(() {
      int index = _shortNoteItems.length;
      _shortNoteItems.add('Item ' + index.toString());
    });
  }

  Widget _buildShortNoteList() {
    return new ListView.builder(
       itemCount: _shortNoteItems.length,
      itemBuilder: (context, index) {
        return _buildShortNoteItem(_shortNoteItems[index]);
      },
    );
  }

  Widget _buildShortNoteItem(String shortNoteText) {
    return new ListTile(
      title: new Text(shortNoteText)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ShortNote List')
      ),
      body: _buildShortNoteList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addShortNoteItem,
        tooltip: 'Add note',
        child: new Icon(Icons.add)
      ),
    );
  }
}