// Observer untuk menangkap perubahan rute/halaman dan menyimpannya
import 'package:flutter/widgets.dart';
import 'last_page_service.dart';

class LastRouteObserver extends NavigatorObserver {
  // Method untuk menyimpan rute saat ini ke persistent storage
  void _saveRoute(Route? route) {
    if (route == null) return;
    
    // Ambil nama rute dari settings, jika kosong gunakan tipe rute
    String? name = route.settings.name;
    if (name == null || name.isEmpty) {
      name = route.runtimeType.toString();
    }
    
    // Hanya simpan rute-rute yang dikenal (halaman utama aplikasi)
    // Jangan simpan form atau rute temporary lainnya
    final known = {'/finance', '/schedule', '/goals', '/dashboard', '/'};
    if (known.contains(name)) {
      print('LastRouteObserver._saveRoute -> $name');
      LastPageService.setLastPage(name);
    }
  }

  // Callback saat rute baru di-push (navigasi ke halaman baru)
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _saveRoute(route);
  }

  // Callback saat rute di-replace (mengganti rute saat ini)
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _saveRoute(newRoute);
  }

  // Callback saat user pop/kembali dari halaman (back)
  // Simpan rute sebelumnya sebagai rute yang sedang dilihat
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _saveRoute(previousRoute);
  }
}
