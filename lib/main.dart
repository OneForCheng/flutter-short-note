import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '便签',
      home: new NoteList(),
    );
  }
}

class NoteItem {
  NoteItem(this.text, this.createTime);

  final String text;
  final DateTime createTime;
}

class NoteList extends StatefulWidget {
  @override
  createState() => new NoteListState();
}

class NoteListState extends State<NoteList> {
  final _dateTimeFormat = new DateFormat('yyyy-MM-dd hh:mm');
  List<NoteItem> _noteItems = [];

  Widget _buildNoteList() {
    return new ListView.builder(
      itemCount: _noteItems.length,
      itemBuilder: (context, index) {
        return _buildNoteItem(_noteItems[index], index);
      },
    );
  }

  Widget _buildNoteItem(NoteItem noteItem, int index) {
    return new Card(
      child: new InkWell(
        onTap: () => _promptEditNoteItem(index),
        child: new Padding(
          padding: EdgeInsets.all(8.0),
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  noteItem.text,
                  style: TextStyle(fontSize: 10),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    _dateTimeFormat.format(noteItem.createTime),
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  ),
                ),
              ]),
        ),
      ),
    );
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

  void _addNoteItem(String text) {
    setState(() => _noteItems.add(new NoteItem(text, DateTime.now())));
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
                _addNoteItem(text);
                Navigator.pop(context);
              }
            },
            decoration: new InputDecoration(
                hintText: '记事', contentPadding: const EdgeInsets.all(16.0)),
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
                      _removeNoteItem(index);
                      final nav = Navigator.of(context);
                      nav.pop();
                      nav.pop();
                    })
              ]);
        });
  }

  void _updateNoteItem(int index, String text) {
    setState(() {
      _noteItems[index] = new NoteItem(text, DateTime.now());
    });
  }

  void _promptEditNoteItem(int index) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final originalText = _noteItems[index].text;
      return new Scaffold(
          appBar: new AppBar(
            title: new Text('编辑便签'),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _promptRemoveNoteItem(index),
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
                  _updateNoteItem(index, text);
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
