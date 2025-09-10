import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "EventApp.db";
  static const _databaseVersion = 1;

  static const table = 'favorite_events';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnPoster = 'poster';
  static const columnLocation = 'location';
  static const columnDate = 'date';
  static const columnType = 'type';
  static const columnCategory = 'category';
  static const columnWebsite = 'website';
  static const columnDescription = 'description';
  static const columnRating = 'rating';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnPoster TEXT,
        $columnLocation TEXT,
        $columnDate TEXT,
        $columnType TEXT,
        $columnCategory TEXT,
        $columnWebsite TEXT,
        $columnDescription TEXT,
        $columnRating REAL
      )
    ''');
  }
}