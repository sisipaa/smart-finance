// Library untuk mengakses API browser HTML pada platform web
import 'dart:html' as html;
import '../services/last_page_service.dart';

// Fungsi untuk memasang listener pada perubahan hash URL
// Hanya digunakan di platform web
void attachWebHashListener() {
  // Dengarkan event saat URL hash berubah
  // (mis. user navigasi via address bar atau SPA mengubah route)
  html.window.onHashChange.listen((event) {
    // Ambil fragment dari URL (contoh: '/finance' dari http://.../#/finance)
    final frag = Uri.base.fragment; // e.g. '/finance'
    // Daftar halaman yang dikenal dalam aplikasi
    final known = {'/finance', '/schedule', '/goals', '/dashboard', '/'};
    // Hanya simpan jika fragment valid dan termasuk halaman yang dikenal
    if (frag.isNotEmpty && known.contains(frag)) {
      LastPageService.setLastPage(frag);
      // ignore: avoid_print
      print('web_hash_listener: saved fragment -> $frag');
    }
  });

  // Dengarkan event sebelum halaman di-unload (tab ditutup / refresh)
  // Untuk memastikan halaman terakhir tersimpan sebelum session berakhir
  html.window.onBeforeUnload.listen((event) {
    final frag = Uri.base.fragment;
    if (frag.isNotEmpty) {
      LastPageService.setLastPage(frag);
      // ignore: avoid_print
      print('web_hash_listener: beforeUnload saved -> $frag');
    }
  });
}

