import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'user_database.db';
  static const _databaseVersion = 1;
  static const table = 'user_table';
  static const columnId = '_id';
  static const columnEmail = 'email';
  static const columnPassword = 'password';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database connection
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnEmail TEXT NOT NULL,
        $columnPassword TEXT NOT NULL
      )
    ''');
  }

  // Insert a new user
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Get user by email and password
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    Database db = await instance.database;
    var res = await db.query(table,
        where: '$columnEmail = ? AND $columnPassword = ?',
        whereArgs: [email, password]);
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  // Delete user by email
  Future<int> delete(String email) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnEmail = ?', whereArgs: [email]);
  }
}
