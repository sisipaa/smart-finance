// Service untuk autentikasi user (login, register, logout)
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Key untuk menyimpan status login di SharedPreferences
  static const String _keyLoggedIn = 'logged_in';
  // Key untuk menyimpan email user yang login
  static const String _keyUser = 'user_email';
  // Prefix untuk key menyimpan password (mis. 'pass_user@email.com')
  // NOTE: Ini hanya untuk demo. Tidak aman untuk produksi!
  static const String _keyPassPrefix = 'pass_';

  // Daftar user baru dengan email dan password
  // Menyimpan password secara plain text (hanya untuk demo)
  static Future<void> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Simpan password dengan key yang dikombinasikan dengan email
    await prefs.setString('$_keyPassPrefix$email', password);
  }

  // Login user dengan email dan password
  // Return true jika login berhasil, false jika gagal
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Ambil password yang tersimpan untuk email ini
    final stored = prefs.getString('$_keyPassPrefix$email');
    // Cek apakah password cocok
    if (stored != null && stored == password) {
      // Set status login menjadi true
      await prefs.setBool(_keyLoggedIn, true);
      // Simpan email user yang sedang login
      await prefs.setString(_keyUser, email);
      return true;
    }
    return false;
  }

  // Logout user dan hapus data session
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Set status login menjadi false
    await prefs.setBool(_keyLoggedIn, false);
    // Hapus email user yang tersimpan
    await prefs.remove(_keyUser);
    // Hapus halaman terakhir yang dikunjungi saat logout
    await prefs.remove('last_visited_page');
    print('AuthService.logout -> cleared last_visited_page');
  }

  // Cek apakah user saat ini sudah login atau belum
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    // Return status login, default false jika belum pernah login
    return prefs.getBool(_keyLoggedIn) ?? false;
  }
}

