// Widget drawer (menu samping) navigasi aplikasi
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  // Index menu yang sedang dipilih (untuk highlight)
  final int selectedIndex;
  // Callback ketika menu dipilih
  final ValueChanged<int>? onTap;

  const AppDrawer({
    super.key,
    this.selectedIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // SafeArea untuk menghindari notch dan status bar
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header drawer dengan nama aplikasi
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Cute Finance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),

            // Menu Dashboard
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              // Highlight jika index 0 (Dashboard) yang dipilih
              selected: selectedIndex == 0,
              onTap: () {
                Navigator.pop(context);
                onTap?.call(0);
              },
            ),

            // Menu Keuangan (Finance)
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Keuangan'),
              selected: selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
                onTap?.call(1);
              },
            ),

            // Menu Jadwal (Schedule)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Jadwal'),
              selected: selectedIndex == 2,
              onTap: () {
                Navigator.pop(context);
                onTap?.call(2);
              },
            ),

            // Menu Tabungan (Goals)
            ListTile(
              leading: const Icon(Icons.savings),
              title: const Text('Tabungan'),
              selected: selectedIndex == 3,
              onTap: () {
                Navigator.pop(context);
                onTap?.call(3);
              },
            ),

            // Spacer untuk mendorong logout ke bawah
            const Spacer(),
            const Divider(height: 1),

            // Menu Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                // Panggil logout dari AuthProvider
                await Provider.of<AuthProvider>(context, listen: false).logout();
                // Redirect ke halaman login
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
