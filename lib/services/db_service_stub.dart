// Implementasi stub untuk platform web menggunakan WebStorageService
// Meniru interface database mobile (sqflite) menggunakan SharedPreferences
import 'web_storage_service.dart';

class DBService {
  static dynamic _db;

  // Inisialisasi database (tidak perlu untuk web)
  static Future<void> initDB() async {
    // Web tidak menggunakan database lokal
    return;
  }

  // Insert data baru ke dalam tabel
  static Future<int> insert(String table, Map<String, dynamic> map) async {
    // Muat data dari tabel yang sesuai
    final list = table == 'transactions'
        ? await WebStorageService.loadTransactions()
        : (table == 'schedules'
            ? await WebStorageService.loadSchedules()
            : await WebStorageService.loadGoals());

    // Generate ID baru untuk record
    final id = await WebStorageService.getNextId(table);
    map['id'] = id;
    // Tambahkan record baru ke list
    list.add(map);

    // Simpan list yang sudah diupdate ke storage
    if (table == 'transactions') {
      await WebStorageService.saveTransactions(list);
    } else if (table == 'schedules') {
      await WebStorageService.saveSchedules(list);
    } else {
      await WebStorageService.saveGoals(list);
    }

    return id;
  }

  // Update data yang sudah ada di dalam tabel
  static Future<int> update(String table, Map<String, dynamic> map) async {
    // Muat data dari tabel yang sesuai
    final list = table == 'transactions'
        ? await WebStorageService.loadTransactions()
        : (table == 'schedules'
            ? await WebStorageService.loadSchedules()
            : await WebStorageService.loadGoals());

    // Cari index record dengan ID yang sama
    final index = list.indexWhere((e) => e['id'] == map['id']);
    if (index != -1) {
      // Replace record lama dengan yang baru
      list[index] = map;
      // Simpan list yang sudah diupdate
      if (table == 'transactions') {
        await WebStorageService.saveTransactions(list);
      } else if (table == 'schedules') {
        await WebStorageService.saveSchedules(list);
      } else {
        await WebStorageService.saveGoals(list);
      }
      return 1;
    }
    return 0;
  }

  // Hapus data dari tabel berdasarkan ID
  static Future<int> delete(String table, int id) async {
    // Muat data dari tabel yang sesuai
    final list = table == 'transactions'
        ? await WebStorageService.loadTransactions()
        : (table == 'schedules'
            ? await WebStorageService.loadSchedules()
            : await WebStorageService.loadGoals());

    // Hapus semua record dengan ID yang cocok
    list.removeWhere((e) => e['id'] == id);

    // Simpan list yang sudah diupdate
    if (table == 'transactions') {
      await WebStorageService.saveTransactions(list);
    } else if (table == 'schedules') {
      await WebStorageService.saveSchedules(list);
    } else {
      await WebStorageService.saveGoals(list);
    }

    return 1;
  }

  // Ambil semua data dari tabel tertentu
  static Future<List<Map<String, dynamic>>> queryAll(String table) async {
    // Muat data dari tabel yang sesuai
    final list = table == 'transactions'
        ? await WebStorageService.loadTransactions()
        : (table == 'schedules'
            ? await WebStorageService.loadSchedules()
            : await WebStorageService.loadGoals());

    // Sort list sesuai dengan perilaku sqflite (descending by date/datetime/createdAt)
    // Menampilkan data terbaru di awal
    list.sort((a, b) {
      final key = table == 'transactions' ? 'date' : (table == 'schedules' ? 'datetime' : 'createdAt');
      return (b[key] as String).compareTo(a[key] as String);
    });

    return list;
  }
}

