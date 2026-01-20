// Service untuk menyimpan dan mengambil halaman terakhir yang dikunjungi
import 'package:shared_preferences/shared_preferences.dart';

class LastPageService {
  // Key untuk menyimpan halaman terakhir di SharedPreferences
  static const _key = 'last_visited_page';

  // Simpan nama rute/halaman yang sedang dikunjungi
  // Jika routeName null, hapus data (clear)
  static Future<void> setLastPage(String? routeName) async {
    final prefs = await SharedPreferences.getInstance();
    if (routeName == null) {
      // Hapus data halaman terakhir jika null
      await prefs.remove(_key);
      print('LastPageService.setLastPage -> cleared');
    } else {
      // Simpan halaman baru
      await prefs.setString(_key, routeName);
      print('LastPageService.setLastPage -> $routeName');
    }
  }

  // Ambil nama rute halaman terakhir yang dikunjungi
  // Return null jika belum pernah ada data
  static Future<String?> getLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
