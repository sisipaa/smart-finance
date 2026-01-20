// Service penyimpanan data khusus web menggunakan SharedPreferences
// Menggantikan sqflite yang tidak didukung di platform web
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service penyimpanan untuk platform web menggunakan SharedPreferences
/// Menyediakan operasi CRUD untuk transactions, schedules, dan goals
class WebStorageService {
  // Key untuk menyimpan data transactions di SharedPreferences
  static const String _keyTransactions = 'transactions_data';
  // Key untuk menyimpan data schedules di SharedPreferences
  static const String _keySchedules = 'schedules_data';
  // Prefix key untuk menyimpan ID terakhir setiap tabel
  static const String _keyLastId = 'last_id_';

  /// Simpan daftar transactions ke SharedPreferences dalam format JSON
  static Future<void> saveTransactions(List<Map<String, dynamic>> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    // Konversi list ke JSON string
    final json = jsonEncode(transactions);
    await prefs.setString(_keyTransactions, json);
  }

  /// Muat daftar transactions dari SharedPreferences
  static Future<List<Map<String, dynamic>>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyTransactions);
    // Jika data tidak ada, return list kosong
    if (json == null) return [];
    // Parse JSON string kembali menjadi list
    final decoded = jsonDecode(json) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Simpan daftar schedules ke SharedPreferences dalam format JSON
  static Future<void> saveSchedules(List<Map<String, dynamic>> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    // Konversi list ke JSON string
    final json = jsonEncode(schedules);
    await prefs.setString(_keySchedules, json);
  }

  /// Muat daftar schedules dari SharedPreferences
  static Future<List<Map<String, dynamic>>> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keySchedules);
    // Jika data tidak ada, return list kosong
    if (json == null) return [];
    // Parse JSON string kembali menjadi list
    final decoded = jsonDecode(json) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Simpan daftar goals ke SharedPreferences dalam format JSON
  static Future<void> saveGoals(List<Map<String, dynamic>> goals) async {
    final prefs = await SharedPreferences.getInstance();
    // Konversi list ke JSON string
    final json = jsonEncode(goals);
    await prefs.setString('goals_data', json);
  }

  /// Muat daftar goals dari SharedPreferences
  static Future<List<Map<String, dynamic>>> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('goals_data');
    // Jika data tidak ada, return list kosong
    if (json == null) return [];
    // Parse JSON string kembali menjadi list
    final decoded = jsonDecode(json) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Generate ID baru untuk setiap tabel (auto-increment)
  /// Menyimpan ID terakhir yang digunakan untuk setiap tabel
  static Future<int> getNextId(String table) async {
    final prefs = await SharedPreferences.getInstance();
    // Buat key unik berdasarkan nama tabel (mis. 'last_id_transactions')
    final key = '$_keyLastId$table';
    // Ambil ID terakhir, default 0 jika belum ada
    final lastId = prefs.getInt(key) ?? 0;
    // Increment ID sebesar 1
    final nextId = lastId + 1;
    // Simpan ID baru ke SharedPreferences
    await prefs.setInt(key, nextId);
    return nextId;
  }
}


