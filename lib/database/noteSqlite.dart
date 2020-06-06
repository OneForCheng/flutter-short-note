import 'package:path/path.dart';
import 'package:short_note/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:short_note/constants/database.dart';

class NoteSqliteManager {

  // Singleton for multiple widget
  static final NoteSqliteManager _manager = NoteSqliteManager._internal();
  
  static NoteSqliteManager get instance => _manager;

  NoteSqliteManager._internal();

  Database _db;

  Future<void> _init() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbFileName);

    //根据数据库文件路径和数据库版本号创建数据库表
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $dbTableName (
            $dbColumnId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $dbColumnContent TEXT, 
            $dbColumnCreateTime TEXT)
          ''');
    });
  }

  Future<Database> getDatabase() async {
    if (_db == null) await _init();
    return _db;
  }

  Future<void> close() async {
    if (_db == null) return
    _db.close();
    _db = null;
  }
}

class NoteSqlite {
  // 插入一条便签数据
  static Future<Note> insert(Note note) async {
    Database db = await NoteSqliteManager.instance.getDatabase();
    note.id = await db.insert(dbTableName, note.toMap());
    return note;
  }

  // 查找所有便签信息
  static Future<List<Note>> getAll() async {
    Database db = await NoteSqliteManager.instance.getDatabase();
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
  static Future<Note> find(int id) async {
    Database db = await NoteSqliteManager.instance.getDatabase();
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
  static Future<int> delete(int id) async {
    Database db = await NoteSqliteManager.instance.getDatabase();
    return await db
        .delete(dbTableName, where: '$dbColumnId = ?', whereArgs: [id]);
  }

  // 更新便签信息
  static Future<int> update(Note note) async {
    Database db = await NoteSqliteManager.instance.getDatabase();
    return await db.update(dbTableName, note.toMap(),
        where: '$dbColumnId = ?', whereArgs: [note.id]);
  }

  static Future<void> close() async {
    await NoteSqliteManager.instance.close();
  }
}
