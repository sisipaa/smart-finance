// Implementasi database untuk mobile menggunakan sqflite (SQLite)
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBService {
  // Instance database yang diakses secara global
  static Database? _db;

  // Inisialisasi database dan membuat tabel jika belum ada
  static Future<void> initDB() async {
    // Dapatkan path folder database default
    final databasesPath = await getDatabasesPath();
    // Buat path file database dengan nama 'cute_app.db'
    final path = join(databasesPath, 'cute_app.db');

    // Buka database atau buat jika belum ada
    _db = await openDatabase(
      path,
      version: 1,
      // onCreate dipanggil saat database pertama kali dibuat
      onCreate: (db, version) async {
        // Buat tabel transactions untuk menyimpan data transaksi
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            type TEXT,
            category TEXT,
            date TEXT
          )
        ''');

        // Buat tabel schedules untuk menyimpan data jadwal/event
        await db.execute('''
          CREATE TABLE schedules(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            note TEXT,
            datetime TEXT
          )
        ''');
        
        // Buat tabel goals untuk menyimpan data tabungan/goals
        await db.execute('''
          CREATE TABLE goals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            targetAmount REAL,
            currentAmount REAL,
            targetDate TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  // Insert data baru ke dalam tabel
  static Future<int> insert(String table, Map<String, dynamic> map) async {
    // Jika database belum diinisialisasi, return -1 (error)
    return _db == null ? -1 : await _db!.insert(table, map);
  }

  // Update data yang sudah ada di dalam tabel berdasarkan ID
  static Future<int> update(String table, Map<String, dynamic> map) async {
    return _db == null ? -1 : await _db!.update(
      table,
      map,
      // WHERE clause untuk mencocokan ID
      where: 'id = ?',
      whereArgs: [map['id']],
    );
  }

  // Hapus data dari tabel berdasarkan ID
  static Future<int> delete(String table, int id) async {
    return _db == null ? -1 : await _db!.delete(
      table,
      // WHERE clause untuk mencocokan ID
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Ambil semua data dari tabel dengan pengurutan
  static Future<List<Map<String, dynamic>>> queryAll(String table) async {
    return _db == null
        ? []
        : await _db!.query(
            table,
            // Order by DESC (terbaru di atas) berdasarkan jenis tabel
            orderBy: table == 'transactions' ? 'date DESC' : 'datetime DESC',
          );
  }
}

