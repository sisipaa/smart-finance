// Import library Flutter untuk material design UI
import 'package:flutter/material.dart';
// Import Provider untuk mengakses state management (DataProvider, AuthProvider, ThemeProvider)
import 'package:provider/provider.dart';
// Import fl_chart untuk membuat pie chart dan visualisasi data
import 'package:fl_chart/fl_chart.dart';
// Import intl untuk format tanggal dan mata uang dalam Bahasa Indonesia
import 'package:intl/intl.dart';
// Import DataProvider untuk mengakses data transaksi, jadwal, dan goals
import '../providers/data_provider.dart';
// Import AuthProvider untuk mengakses status login dan fungsi logout
import '../providers/auth_provider.dart';
// Import ThemeProvider untuk toggle dark/light mode
import '../providers/theme_provider.dart';
// Import widget StatCard untuk menampilkan kartu statistik ringkasan
import '../widgets/stat_card.dart';

// Class DashboardPage adalah StatefulWidget yang menampilkan halaman dashboard/ringkasan keuangan
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// State untuk DashboardPage yang mengelola data dashboard dan pie chart
class _DashboardPageState extends State<DashboardPage> {
  // initState dipanggil saat pertama kali widget dimount
  @override
  void initState() {
    super.initState();

    // Gunakan Future.microtask untuk load data setelah build selesai
    // Ini aman karena menghindari error provider access during build
    Future.microtask(() {
      Provider.of<DataProvider>(context, listen: false).loadAll();
    });
  }

  // Method build yang membangun UI dashboard dengan pie chart dan statistik
  @override
  Widget build(BuildContext context) {
    // Ambil DataProvider untuk akses data transaksi, jadwal, dan goals
    final dp = Provider.of<DataProvider>(context);
    // Ambil AuthProvider untuk info user dan fungsi logout
    final auth = Provider.of<AuthProvider>(context, listen: false);
    // Dapatkan tanggal hari ini untuk filter jadwal mendatang
    final today = DateTime.now();

    // ===== PERHITUNGAN DATA STATISTIK =====
    // Variabel untuk menyimpan total pemasukan (income)
    double totalIncome = 0;
    // Variabel untuk menyimpan total pengeluaran (expense)
    double totalExpense = 0;
    // Map untuk menyimpan total pengeluaran per kategori (key=kategori, value=jumlah)
    Map<String, double> categoryTotal = {};

    // Loop semua transaksi untuk menghitung income, expense, dan total per kategori
    for (var t in dp.transactions) {
      if (t.type == 'income') {
        // Jika tipe income, tambahkan ke totalIncome
        totalIncome += t.amount;
      } else {
        // Jika tipe expense, tambahkan ke totalExpense dan update categoryTotal
        totalExpense += t.amount;
        categoryTotal[t.category] = (categoryTotal[t.category] ?? 0) + t.amount;
      }
    }

    /// ===== KONSTRUKSI DATA PIE CHART (PEMASUKAN VS PENGELUARAN) =====
    // List untuk menyimpan data section pie chart income vs expense
    final List<PieChartSectionData> incomExpenseChart = [];
    
    // Jika ada pemasukan, tambahkan section untuk income (warna hijau)
    if (totalIncome > 0) {
      incomExpenseChart.add(
        PieChartSectionData(
          value: totalIncome,
          // Judul section menampilkan label "Pemasukan" + jumlah dalam format Rp
          title: 'Pemasukan\nRp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(totalIncome).trim()}',
          radius: 60,
          // Style text berwarna putih dan tebal
          titleStyle: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          // Warna section hijau untuk income
          color: Colors.green.shade400,
        ),
      );
    }
    
    // Jika ada pengeluaran, tambahkan section untuk expense (warna merah)
    if (totalExpense > 0) {
      incomExpenseChart.add(
        PieChartSectionData(
          value: totalExpense,
          // Judul section menampilkan label "Pengeluaran" + jumlah dalam format Rp
          title: 'Pengeluaran\nRp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(totalExpense).trim()}',
          radius: 60,
          // Style text berwarna putih dan tebal
          titleStyle: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          // Warna section merah untuk expense
          color: Colors.red.shade400,
        ),
      );
    }

    /// ===== FILTER JADWAL MENDATANG =====
    // Filter jadwal yang tanggalnya lebih besar dari hari ini (jadwal mendatang)
    final upcoming = dp.schedules
        .where((s) => s.datetime.isAfter(today))
        .toList()
      // Sort jadwal dari yang paling dekat ke yang paling jauh
      ..sort((a, b) => a.datetime.compareTo(b.datetime));

    // Ambil hanya 5 jadwal mendatang terdekat untuk ditampilkan di dashboard
    final next5 = upcoming.take(5).toList();

    return Scaffold(
      // AppBar dengan judul dashboard dan action buttons
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          // Button toggle tema (dark/light mode) menggunakan Consumer<ThemeProvider>
          Consumer<ThemeProvider>(
            builder: (context, themeProv, _) => IconButton(
              // Tooltip menunjukkan mode saat ini dan mode yang akan diaktifkan
              tooltip: themeProv.isDark ? 'Switch to light' : 'Switch to dark',
              // Icon berubah sesuai tema: bulan untuk dark mode, matahari untuk light mode
              icon: Icon(themeProv.isDark ? Icons.dark_mode : Icons.light_mode),
              // Ketika ditekan, toggle tema
              onPressed: () => themeProv.toggle(),
            ),
          ),
          // Button logout untuk keluar dari aplikasi
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Panggil logout dari AuthProvider untuk clear session
              await auth.logout();
              // Cek apakah widget masih mounted sebelum navigate
              if (!mounted) return;
              // Navigate ke halaman login (/) mengganti route saat ini
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),

      // Body menggunakan RefreshIndicator untuk pull-to-refresh
      body: RefreshIndicator(
        // onRefresh memanggil loadAll() dari DataProvider untuk refresh data
        onRefresh: dp.loadAll,
        child: SingleChildScrollView(
          // AlwaysScrollableScrollPhysics memastikan list bisa di-scroll bahkan jika konten kurang dari screen height
          physics: const AlwaysScrollableScrollPhysics(),
          // Padding untuk memberi ruang di sekitar konten
          padding: const EdgeInsets.all(16),
          // Column berisi semua elemen dashboard (statistik, charts, jadwal)
          child: Column(
            children: [
              /// ===== KARTU RINGKASAN STATISTIK KEUANGAN =====
              // Row dengan 2 StatCard berdampingan: Pemasukan dan Pengeluaran
              Row(
                children: [
                  // StatCard untuk menampilkan total Pemasukan
                  Expanded(
                    child: StatCard(
                      label: "Pemasukan",
                      amount: totalIncome,
                      backgroundColor: Colors.white,
                      labelColor: Colors.green.shade600,
                      amountColor: Colors.green.shade700,
                      icon: Icons.add_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // StatCard untuk menampilkan total Pengeluaran
                  Expanded(
                    child: StatCard(
                      label: "Pengeluaran",
                      amount: totalExpense,
                      backgroundColor: Colors.white,
                      labelColor: Colors.red.shade600,
                      amountColor: Colors.red.shade700,
                      icon: Icons.remove_circle_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ===== PIE CHART: PEMASUKAN VS PENGELUARAN =====
              // Tampilkan pie chart hanya jika ada data income atau expense
              if (incomExpenseChart.isNotEmpty)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul chart
                        Text(
                          "Pemasukan vs Pengeluaran",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        // Container dengan tinggi 220 untuk pie chart
                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 40,
                              sectionsSpace: 3,
                              sections: incomExpenseChart,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              else
                // Tampilkan pesan jika belum ada data transaksi
                const Center(
                  child: Text(
                    "Belum ada data transaksi",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

              const SizedBox(height: 24),

              /// ===== KATEGORI PENGELUARAN (PIE CHART) =====
              // Tampilkan pie chart kategori pengeluaran hanya jika ada data
              if (categoryTotal.isNotEmpty)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul chart
                        Text(
                          "Pengeluaran per Kategori",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        // Container dengan tinggi 220 untuk pie chart
                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                              // Map setiap kategori menjadi PieChartSectionData
                              sections: categoryTotal.entries.map((e) {
                                // Array warna untuk berbagai kategori
                                final colors = [
                                  Colors.blue.shade400,
                                  Colors.purple.shade400,
                                  Colors.orange.shade400,
                                  Colors.pink.shade400,
                                  Colors.teal.shade400,
                                ];
                                // Tentukan warna berdasarkan index kategori (cycling)
                                final colorIndex = categoryTotal.keys.toList().indexOf(e.key) % colors.length;
                                return PieChartSectionData(
                                  value: e.value,
                                  title: e.key,
                                  radius: 55,
                                  color: colors[colorIndex],
                                  titleStyle: const TextStyle(
                                      color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              /// ===== DAFTAR JADWAL MENDATANG =====
              // Align ke kiri untuk judul "Kegiatan Mendatang"
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kegiatan Mendatang",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              const SizedBox(height: 8),

              // Jika tidak ada jadwal mendatang, tampilkan pesan
              if (next5.isEmpty)
                const Text("Tidak ada jadwal mendatang")
              else
                // Spread operator untuk menampilkan setiap jadwal sebagai ListTile
                ...next5.map((s) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      // Judul dari schedule
                      title: Text(s.title),
                      // Subtitle menampilkan tanggal dan waktu dalam format "dd MMM yyyy - HH:mm"
                      subtitle: Text(
                        DateFormat("dd MMM yyyy - HH:mm").format(s.datetime),
                      ),
                      // Trailing menampilkan catatan (note) dari schedule
                      trailing: Text(
                        s.note,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                })
            ],
          ),
        ),
      ),
    );
  }
}
