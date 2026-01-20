// Import Flutter foundation untuk ChangeNotifier
import 'package:flutter/material.dart';
// Service yang berisi metode autentikasi (login, logout, register, dll.)
import '../services/auth_service.dart';

// Provider sederhana untuk status autentikasi user
class AuthProvider extends ChangeNotifier {
  // Menyimpan apakah user saat ini sudah login atau belum
  bool isLoggedIn = false;

  // Periksa status login saat inisialisasi aplikasi.
  // Mengembalikan Future sehingga bisa dipakai oleh FutureBuilder.
  Future<void> checkLoggedIn() async {
    // Memanggil AuthService untuk mengetahui status login
    isLoggedIn = await AuthService.isLoggedIn();
    // Beritahu pendengar (UI) bahwa status berubah
    notifyListeners();
  }

  // Melakukan proses login dengan email dan password.
  // Mengembalikan boolean yang menandakan keberhasilan login.
  Future<bool> login(String email, String pass) async {
    final ok = await AuthService.login(email, pass);
    // Update state dan notify listener jika berubah
    isLoggedIn = ok;
    notifyListeners();
    return ok;
  }

  // Mendaftarkan user baru. Tidak mengubah state isLoggedIn secara otomatis.
  Future<void> register(String email, String pass) async {
    await AuthService.register(email, pass);
  }

  // Logout: panggil service lalu set state menjadi logged out.
  Future<void> logout() async {
    await AuthService.logout();
    isLoggedIn = false;
    notifyListeners();
  }
}

