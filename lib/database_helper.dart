import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calculator_history.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT,
            result TEXT,
            date TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertHistory(String expression, String result) async {
    final db = await database;
    await db.insert(
      'history',
      {'expression': expression, 'result': result, 'date': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}

