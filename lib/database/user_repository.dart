import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'user.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> registerUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}
