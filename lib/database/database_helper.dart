import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        title TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<int> registerUser(String username, String email, String password) async {
    final db = await database;
    String hashedPassword = _hashPassword(password);
    try {
      return await db.insert('users', {
        'username': username,
        'email': email,
        'password': hashedPassword,
      });
    } catch (e) {
      // Handle error, e.g., username or email already exists
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    String hashedPassword = _hashPassword(password);
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null; // Invalid credentials
    }
  }

  Future<int> addTask(int userId, String title, String description) async {
    final db = await database;
    return await db.insert('tasks', {
      'user_id': userId,
      'title': title,
      'description': description,
    });
  }

  Future<List<Map<String, dynamic>>> getTasks(int userId) async {
    final db = await database;
    return await db.query('tasks', where: 'user_id = ?', whereArgs: [userId]);
  }
}
