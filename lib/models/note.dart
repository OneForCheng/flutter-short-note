import 'package:flutter/cupertino.dart';
import 'package:short_note/constants/database.dart';

class Note {
  int id;
  String content;
  String createTime;
  int completed;

  Note({this.id, this.createTime, this.completed = 0, @required this.content}) {
    createTime = createTime == null || createTime.length == 0 ? DateTime.now().toString() : createTime;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      dbColumnId: id,
      dbColumnContent: content,
      dbColumnCreateTime: createTime,
      dbColumnCompleted: completed,
    };
    return map;
  }

  Note clone() {
    return Note(
      id: id,
      content: content, 
      createTime: createTime,
      completed: completed,
    );
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map[dbColumnId];
    content = map[dbColumnContent];
    createTime = map[dbColumnCreateTime];
    completed = map[dbColumnCompleted];
  }
}

