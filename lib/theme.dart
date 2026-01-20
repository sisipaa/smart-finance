import 'package:flutter/material.dart';

// File ini: `theme.dart`
// Deskripsi singkat: Mendefinisikan seluruh konfigurasi tema aplikasi.
// - Palet warna (konstanta Color)
// - Tipografi (TextTheme bernama `appTextTheme`)
// - ThemeData untuk mode terang (`appTheme`) dan mode gelap (`appDarkTheme`)
// Tujuan: memusatkan pengaturan tampilan agar konsisten di seluruh aplikasi.

// ===== PALET WARNA =====
// Variabel warna berikut digunakan berulang di seluruh ThemeData.
// Beri nama deskriptif supaya mudah dipakai kembali dan konsisten.
final Color softPink = Color(0xFFFFE4E9); // latar ringan untuk mode terang
final Color pink = Color(0xFFFFA3B1); // warna primer aksen (terpilih)
final Color softGreen = Color(0xFFE8F8F3); // warna latar/aksen hijau lembut
final Color green = Color(0xFF66CDAA); // hijau utama untuk FAB/ikon
final Color softBlue = Color(0xFFE0F7FF); // latar/aksen biru lembut
final Color blue = Color(0xFF4FC3F7); // aksen biru untuk elemen sekunder
final Color darkText = Color(0xFF1F1F1F); // warna teks gelap (kontras di terang)
final Color lightText = Color(0xFF666666); // warna teks sekunder (lebih lembut)

// ===== TYPOGRAPHY =====
// ===== TIPOGRAFI (TextTheme) =====
// `appTextTheme` mendefinisikan gaya teks standar yang digunakan pada
// berbagai widget: judul, sub-judul, isi, dan label kecil. Memisahkan
// TextTheme memudahkan konsistensi dan perubahan global gaya teks.
final TextTheme appTextTheme = TextTheme(
  // Judul utama besar, contoh dipakai di halaman dashboard sebagai heading
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkText,
  ),
  // Judul besar di card atau app bar
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: darkText,
  ),
  // Judul menengah untuk sub-section atau label penting
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: darkText,
  ),
  // Teks isi utama (body) untuk konten biasa
  bodyLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: darkText,
  ),
  // Teks isi sekunder, mis. deskripsi atau placeholder
  bodyMedium: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: lightText,
  ),
  // Label kecil untuk tombol kecil, helper text, atau badge
  labelSmall: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: lightText,
  ),
);

// ===== MAIN THEME =====
// ===== TEMA UTAMA (MODE TERANG) =====
// `appTheme` adalah konfigurasi ThemeData untuk tampilan terang.
// Di sini kita mengatur skema warna, tipografi, dan gaya default komponen.
final ThemeData appTheme = ThemeData(
  useMaterial3: true, // pakai Material 3 (jika didukung) untuk styling modern
  primaryColor: pink, // warna primer aplikasi
  scaffoldBackgroundColor: softPink, // latar utama halaman
  
  // ColorScheme: sumber kebenaran untuk warna komponen Material
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: pink,
    secondary: green,
    tertiary: blue,
    surface: Colors.white,
    background: softPink,
  ),
  
  // Gunakan TextTheme yang sudah didefinisikan sebelumnya
  textTheme: appTextTheme,
  
  // AppBar: style default untuk semua AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: pink,
    elevation: 0, // tanpa bayangan agar terlihat datar
    foregroundColor: Colors.white, // warna ikon dan teks
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  
  // Floating Action Button: gaya tombol aksi mengambang
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: green,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  
  // ElevatedButton: gaya tombol utama (radius, padding, dan teks)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  
  // InputDecoration: style untuk TextField / Input
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // field terisi putih agar kontras di latar softPink
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: TextStyle(color: lightText, fontSize: 13),
  ),
  
  // Card: gaya kartu (dipakai oleh widget seperti Card)
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    color: Colors.white,
  ),
  
  // BottomNavigationBar: gaya navigasi bawah
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 8,
    selectedItemColor: pink,
    unselectedItemColor: Colors.grey.shade400,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

// ===== DARK THEME =====
// ===== TEMA GELAP (MODE DARK) =====
// `appDarkTheme` menyesuaikan warna dan kontras untuk tampilan gelap.
// Perhatikan perbedaan: brightness, warna latar, dan aksen agar tetap
// terbaca dan nyaman di mata saat mode gelap dipakai.
final ThemeData appDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Colors.tealAccent.shade200,
  // scaffoldBackgroundColor dan colorScheme dipilih gelap agar
  // konten menonjol dan mengurangi silau pada layar.
  scaffoldBackgroundColor: Color(0xFF0F1720),
  colorScheme: ColorScheme.dark().copyWith(
    primary: Colors.tealAccent.shade200,
    secondary: Colors.greenAccent.shade200,
    tertiary: Colors.lightBlueAccent.shade100,
    surface: Color(0xFF111827),
    background: Color(0xFF0B1220),
  ),
  // Terapkan warna putih untuk teks agar kontras terhadap latar gelap
  textTheme: appTextTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF081018),
    elevation: 0,
    foregroundColor: Colors.white,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.greenAccent.shade400,
    foregroundColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.tealAccent.shade200,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    // Field berwarna gelap agar blending dengan background mode gelap
    fillColor: Color(0xFF0B1220),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13),
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    color: Color(0xFF0B1220),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF081018),
    elevation: 8,
    selectedItemColor: Colors.tealAccent.shade200,
    unselectedItemColor: Colors.grey.shade500,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

