// Import paket Flutter dan paket pendukung
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import tema aplikasi
import 'theme.dart';

// Import provider untuk manajemen state
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'providers/theme_provider.dart';

// Import halaman (pages)
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/finance_page.dart';
import 'pages/schedule_page.dart';
import 'pages/goals_page.dart';

// Import service untuk database dan penyimpanan halaman terakhir
import 'services/db_service.dart';
import 'services/last_page_service.dart';
import 'services/last_route_observer.dart';

// Utilitas khusus web untuk mendengarkan perubahan hash URL
import 'utils/web_hash_listener.dart';

// Komponen widget global
import 'widgets/app_bottom_nav.dart';
import 'widgets/app_drawer.dart';

// Titik masuk aplikasi
void main() async {
  // Pastikan binding Flutter sudah diinisialisasi (penting untuk kode async sebelum runApp)
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database secara non-blocking. Pada web ini bisa gagal,
  // jadi kita tangani error tanpa menghentikan startup aplikasi.
  DBService.initDB().catchError((e) {
    print("Database init error: $e");
  });

  // Khusus web: ambil fragment (hash) awal dari URL dan simpan sebagai
  // 'last page' agar navigasi yang berasal dari address bar tetap dikenali.
  try {
    final frag = Uri.base.fragment; // contoh: '/finance' untuk http://.../#/finance
    if (frag != null && frag.isNotEmpty) {
      final known = {'/finance', '/schedule', '/goals', '/dashboard', '/'};
      if (known.contains(frag)) {
        // Upaya menyimpan halaman terakhir sebelum aplikasi benar-benar dimulai
        await LastPageService.setLastPage(frag);
        print('main(): persisted initial fragment -> $frag');
      }
    }
  } catch (e) {
    // Abaikan error di sini — tidak kritis untuk jalannya aplikasi
  }

  // Jalankan aplikasi Flutter
  runApp(const MyApp());

  // Untuk platform web: pasang listener yang akan menyimpan fragment saat user
  // mengubah hash atau menutup halaman, sehingga last-page tetap konsisten.
  attachWebHashListener();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      // Consumer untuk memantau perubahan tema dari ThemeProvider
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) => MaterialApp(
          // Judul aplikasi
          title: 'Cute Finance & Schedule',
          // Tema terang dan gelap yang didefinisikan di theme.dart
          theme: appTheme,
          darkTheme: appDarkTheme,
          // Gunakan moda tema dari ThemeProvider (System/Light/Dark)
          themeMode: themeProv.themeMode,
          debugShowCheckedModeBanner: false,
          // Definisi route statis; root ('/') akan menampilkan widget Root
          routes: {
            '/': (_) => const Root(),
            '/dashboard': (_) => const DashboardPage(),
            '/finance': (_) => const FinancePage(),
            '/schedule': (_) => const SchedulePage(),
            '/goals': (_) => const GoalsPage(),
          },
          // Observer untuk menyimpan rute terakhir ketika navigasi terjadi
          navigatorObservers: [LastRouteObserver()],
        ),
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late Future<void> _initFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Ambil provider Auth tanpa listen untuk inisialisasi awal (check login)
    final auth = Provider.of<AuthProvider>(context, listen: false);
    // _initFuture akan dipakai oleh FutureBuilder untuk menunggu proses pengecekan
    _initFuture = auth.checkLoggedIn();
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.isLoggedIn) {
          // Jika user sudah login, susun daftar halaman utama sesuai tab
          final pages = [
            const DashboardPage(),
            const FinancePage(),
            const SchedulePage(),
            const GoalsPage(),
          ];

          // Tampilkan Scaffold utama dengan drawer dan bottom navigation
          return Scaffold(
            drawer: AppDrawer(selectedIndex: _selectedIndex, onTap: _onNavTap),
            // Konten utama bergantung pada tab yang dipilih
            body: pages[_selectedIndex],
            bottomNavigationBar: AppBottomNav(
              currentIndex: _selectedIndex,
              onTap: _onNavTap,
            ),
          );
        } else {
          // Jika belum login, tampilkan halaman login
          return const LoginPage();
        }
      },
    );
  }
}
