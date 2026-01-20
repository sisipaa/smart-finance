// Halaman untuk menampilkan dan mengelola daftar transaksi keuangan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/transaction_card.dart';
import 'add_transaction_page.dart';
import 'goals_page.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Akses DataProvider untuk mendapatkan list transactions
    final dp = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keuangan"),
        // Action button di appbar untuk navigasi ke goals page
        actions: [
          IconButton(
            tooltip: 'Goals Nabung',
            icon: const Icon(Icons.savings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GoalsPage(),
                // Set route name untuk last_page_service
                settings: const RouteSettings(name: '/goals'),
              ),
            ),
          ),
        ],
      ),
      // Tombol floating action untuk menambah transaksi baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah transaksi
          Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()));
        },
        child: const Icon(Icons.add),
      ),
      // Daftar transaksi ditampilkan dalam ListView
      body: ListView.builder(
        itemCount: dp.transactions.length,
        itemBuilder: (context, i) {
          final t = dp.transactions[i];
          return TransactionCard(
            title: t.title,
            date: t.date,
            type: t.type,
            category: t.category,
            amount: t.amount,
            // Callback saat tombol edit ditekan
            onEdit: () {
              // Navigasi ke halaman edit transaksi dengan membawa data transaksi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTransactionPage(transaction: t),
                ),
              );
            },
            // Callback saat tombol hapus ditekan
            onDelete: () => dp.deleteTransaction(t.id!),
          );
        },
      ),
    );
  }
}

