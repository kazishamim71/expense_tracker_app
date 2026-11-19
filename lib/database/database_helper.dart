import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'expense_tracker.db';
  static const _dbVersion = 1;
  static const table = 'expenses';

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL
          )
        ''');
      },
    );
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert(table, expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final rows = await db.query(table, orderBy: 'id DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotal() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(amount) AS total FROM $table');
    final total = result.first['total'];
    return total == null ? 0.0 : (total as num).toDouble();
  }
}
