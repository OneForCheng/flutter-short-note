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
        return _buildNoteItem(_noteItems[index], index);
      },
    );
  }

  Widget _buildNoteItem(String text, int index) {
    return new ListTile(
      title: new Text(text),
      trailing: Wrap(
        //列表项的类型是 <Widget>
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => _promptRemoveNoteItem(index),
          ),
          new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () => _promptEditNoteItem(index),
          ),
        ],
      ),
    );
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

  void _removeNoteItem(int index) {
    setState(() => _noteItems.removeAt(index));
  }

  void _promptRemoveNoteItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Remove "${_noteItems[index]}"?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('OK'),
                    onPressed: () {
                      _removeNoteItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _updateNoteItem(int index, String text) {
    setState(() {
      _noteItems[index] = text;
    });
  }

  void _promptEditNoteItem(int index) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final originalText = _noteItems[index];
      return new Scaffold(
          appBar: new AppBar(title: new Text('Edit the note')),
          body: new TextField(
            controller: new TextEditingController(text: originalText),
            autofocus: true,
            onSubmitted: (val) {
              final text = val.trim();
              if (text.length > 0) {
                if (text != originalText) {
                  _updateNoteItem(index, text);
                }
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
