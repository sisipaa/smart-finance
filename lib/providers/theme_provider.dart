// Provider untuk mengelola preferensi tema (terang/gelap)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Kunci yang digunakan untuk menyimpan preferensi ke SharedPreferences
  static const _prefKey = 'isDarkMode';

  // Menyimpan status tema saat ini (true = dark, false = light)
  bool _isDark = false;

  // Konstruktor memanggil pemuatan preferensi dari storage
  ThemeProvider() {
    _loadFromPrefs();
  }

  // Getter sederhana untuk status dark
  bool get isDark => _isDark;

  // Konversi status ke ThemeMode yang dipakai MaterialApp
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  // Toggle tema: ubah nilai, beri tahu listener, dan simpan ke prefs
  Future<void> toggle() async {
    _isDark = !_isDark;
    // Beri tahu UI untuk rebuild sesuai perubahan tema
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isDark);
  }

  // Muat preferensi tema dari SharedPreferences saat objek dibuat
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_prefKey) ?? false;
    // Setelah nilai dimuat, beri tahu listener agar UI menyesuaikan
    notifyListeners();
  }
}
