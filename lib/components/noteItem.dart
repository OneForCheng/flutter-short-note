import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:short_note/models/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function onTapCallback;
  final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd hh:mm');

  NoteItem(this.note, this.onTapCallback);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: InkWell(
        onTap: onTapCallback,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 10,
                    decoration: note.completed == 0 ? TextDecoration.none : TextDecoration.lineThrough,
                    color: note.completed == 0 ? Colors.black : Colors.grey[500],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    _dateTimeFormat.format(DateTime.parse(note.createTime)),
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
