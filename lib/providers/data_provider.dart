// Provider untuk mengelola data transaksi, jadwal, dan goals
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/schedule_model.dart';
import '../models/goal_model.dart';
import '../services/db_service.dart';

class DataProvider extends ChangeNotifier {
  // Koleksi data yang dipegang di memory untuk UI
  List<TransactionModel> transactions = [];
  List<ScheduleModel> schedules = [];
  List<GoalModel> goals = [];

  // Muat semua data dari database ke dalam provider
  // Dipanggil saat aplikasi atau halaman butuh sinkron awal
  Future<void> loadAll() async {
    final t = await DBService.queryAll('transactions');
    transactions = t.map((e) => TransactionModel.fromMap(e)).toList();

    final s = await DBService.queryAll('schedules');
    schedules = s.map((e) => ScheduleModel.fromMap(e)).toList();

    final g = await DBService.queryAll('goals');
    goals = g.map((e) => GoalModel.fromMap(e)).toList();

    // Beritahu UI bahwa data berubah
    notifyListeners();
  }

  // Tambah transaksi baru: simpan di DB, update id, dan masukkan ke list
  Future<void> addTransaction(TransactionModel tx) async {
    final id = await DBService.insert('transactions', tx.toMap());
    tx.id = id;
    // Masukkan di depan supaya item terbaru tampil paling atas
    transactions.insert(0, tx);
    notifyListeners();
  }

  // Update transaksi: update di DB lalu reload semua data
  // (pilihan sederhana untuk menjaga konsistensi)
  Future<void> updateTransaction(TransactionModel tx) async {
    await DBService.update('transactions', tx.toMap());
    await loadAll();
  }

  // Hapus transaksi: hapus di DB dan di list lokal
  Future<void> deleteTransaction(int id) async {
    await DBService.delete('transactions', id);
    transactions.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // Tambah jadwal (schedule)
  Future<void> addSchedule(ScheduleModel s) async {
    final id = await DBService.insert('schedules', s.toMap());
    s.id = id;
    schedules.insert(0, s);
    notifyListeners();
  }

  // Update jadwal dan reload data
  Future<void> updateSchedule(ScheduleModel s) async {
    await DBService.update('schedules', s.toMap());
    await loadAll();
  }

  // Hapus jadwal
  Future<void> deleteSchedule(int id) async {
    await DBService.delete('schedules', id);
    schedules.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // CRUD Goals
  // Tambah goal baru
  Future<void> addGoal(GoalModel goal) async {
    final id = await DBService.insert('goals', goal.toMap());
    goal.id = id;
    goals.insert(0, goal);
    notifyListeners();
  }

  // Update goal dan reload
  Future<void> updateGoal(GoalModel goal) async {
    await DBService.update('goals', goal.toMap());
    await loadAll();
  }

  // Hapus goal
  Future<void> deleteGoal(int id) async {
    await DBService.delete('goals', id);
    goals.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // Deposit ke goal tertentu: tambahkan currentAmount dan simpan
  Future<void> depositToGoal(int id, double amount) async {
    final idx = goals.indexWhere((g) => g.id == id);
    if (idx == -1) return;
    final g = goals[idx];
    g.currentAmount += amount;
    await DBService.update('goals', g.toMap());
    notifyListeners();
  }
}

