import 'package:path/path.dart';
import 'package:short_note/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:short_note/constants/database.dart';

class NoteSqlite {
  Database db;

  openSqlite() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbFileName);

    //根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $dbTableName (
            $dbColumnId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $dbColumnContent TEXT, 
            $dbColumnCreateTime TEXT)
          ''');
    });
  }

  // 插入一条便签数据
  Future<Note> insert(Note note) async {
    note.id = await db.insert(dbTableName, note.toMap());
    return note;
  }

  // 查找所有便签信息
  Future<List<Note>> queryAll() async {
    List<Map> maps = await db.query(dbTableName, columns: [
      dbColumnId,
      dbColumnContent,
      dbColumnCreateTime,
    ]);

    if (maps == null || maps.length == 0) {
      return [];
    }

    List<Note> notes = [];
    for (int i = 0; i < maps.length; i++) {
      notes.add(Note.fromMap(maps[i]));
    }
    return notes;
  }

  // 根据ID查找便签信息
  Future<Note> find(int id) async {
    List<Map> maps = await db.query(dbTableName,
        columns: [
          dbColumnId,
          dbColumnContent,
          dbColumnCreateTime,
        ],
        where: '$dbColumnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // 根据ID删除便签信息
  Future<int> delete(int id) async {
    return await db
        .delete(dbTableName, where: '$dbColumnId = ?', whereArgs: [id]);
  }

  // 更新便签信息
  Future<int> update(Note note) async {
    return await db.update(dbTableName, note.toMap(),
        where: '$dbColumnId = ?', whereArgs: [note.id]);
  }

  // 记得及时关闭数据库，防止内存泄漏
  close() async {
    await db.close();
  }
}
