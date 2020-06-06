import 'package:short_note/constants/database.dart';

class Note {
  int id;
  String content;
  String createTime;

  Note(this.content, this.createTime, [this.id]);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      dbColumnContent: content,
      dbColumnCreateTime: createTime,
    };

    if(id != null) {
      map[dbColumnId] = id;
    }

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map[dbColumnId];
    content = map[dbColumnContent];
    createTime = map[dbColumnCreateTime];
  }
}

