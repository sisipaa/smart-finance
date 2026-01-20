// Widget bottom navigation bar untuk navigasi antar halaman utama
import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  // Index tab yang sedang aktif/terpilih
  final int currentIndex;
  // Callback ketika tab ditekan, menerima index tab baru
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Menunjukkan tab mana yang sedang aktif
      currentIndex: currentIndex,
      // Callback saat user menekan tab
      onTap: onTap,
      // Daftar item navigation di bottom bar
      items: const [
        // Tab Dashboard
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        // Tab Keuangan (Finance)
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Keuangan',
        ),
        // Tab Jadwal (Schedule)
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Jadwal',
        ),
        // Tab Tabungan (Goals)
        BottomNavigationBarItem(
          icon: Icon(Icons.savings),
          label: 'Tabungan',
        ),
      ],
    );
  }
}
