// Import library Flutter untuk material design UI
import 'package:flutter/material.dart';
// Import Provider untuk akses state management (DataProvider)
import 'package:provider/provider.dart';
// Import DataProvider untuk CRUD operasi transaksi
import '../providers/data_provider.dart';
// Import TransactionModel untuk data class transaksi
import '../models/transaction_model.dart';

// Class AddTransactionPage adalah StatefulWidget untuk menambah atau edit transaksi
class AddTransactionPage extends StatefulWidget {
  // Parameter transaction opsional untuk mode edit (jika null = mode tambah)
  final TransactionModel? transaction;

  const AddTransactionPage({super.key, this.transaction});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

// State class untuk AddTransactionPage yang mengelola form dan input transaksi
class _AddTransactionPageState extends State<AddTransactionPage> {
  // Controller untuk TextField judul transaksi
  late TextEditingController titleC;
  // Controller untuk TextField jumlah uang transaksi
  late TextEditingController amountC;
  // State untuk jenis transaksi (income atau expense)
  late String type;
  // State untuk kategori pengeluaran
  late String category;

  // Daftar kategori pengeluaran yang tersedia untuk dropdown
  final categories = [
    "makan",
    "main",
    "transport",
    "kebutuhan kos",
    "kebutuhan dapur",
    "obat",
    "belanja pakaian",
    "keperluan kerja/kuliah"
  ];

  // initState dipanggil saat widget pertama kali dimount
  @override
  void initState() {
    super.initState();
    // Cek apakah ini mode edit (widget.transaction bukan null)
    if (widget.transaction != null) {
      // Mode edit: isi controller dan state dengan data transaksi yang ada
      titleC = TextEditingController(text: widget.transaction!.title);
      amountC = TextEditingController(text: widget.transaction!.amount.toString());
      type = widget.transaction!.type;
      category = widget.transaction!.category;
    } else {
      // Mode tambah baru: buat controller kosong dan set default values
      titleC = TextEditingController();
      amountC = TextEditingController();
      type = "income"; // Default tipe adalah pemasukan
      category = "makan"; // Default kategori adalah makan
    }
  }

  // dispose dipanggil saat widget dihapus dari tree untuk cleanup
  @override
  void dispose() {
    // Bersihkan TextEditingController untuk menghindari memory leak
    titleC.dispose();
    amountC.dispose();
    super.dispose();
  }

  // Method build yang membangun UI form untuk tambah/edit transaksi
  @override
  Widget build(BuildContext context) {
    // Ambil DataProvider untuk akses method addTransaction dan updateTransaction
    final dp = Provider.of<DataProvider>(context);
    // Tentukan apakah ini mode edit atau mode tambah baru
    final isEdit = widget.transaction != null;

    return Scaffold(
      // AppBar dengan judul dinamis sesuai mode (edit atau tambah)
      appBar: AppBar(title: Text(isEdit ? "Edit Transaksi" : "Tambah Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// ===== FIELD JUDUL TRANSAKSI =====
            TextField(
              controller: titleC,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            const SizedBox(height: 12),

            /// ===== FIELD JUMLAH UANG =====
            TextField(
              controller: amountC,
              // Set keyboard type number untuk input angka saja
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
            ),
            const SizedBox(height: 12),

            /// ===== DROPDOWN TIPE TRANSAKSI (INCOME/EXPENSE) =====
            DropdownButtonFormField(
              value: type,
              decoration: const InputDecoration(labelText: "Tipe"),
              items: const [
                DropdownMenuItem(value: "income", child: Text("Pemasukan")),
                DropdownMenuItem(value: "expense", child: Text("Pengeluaran")),
              ],
              // Ketika tipe berubah, update state dan rebuild widget
              onChanged: (v) => setState(() => type = v.toString()),
            ),

            /// ===== DROPDOWN KATEGORI (HANYA TAMPIL JIKA TIPE = EXPENSE) =====
            if (type == "expense") ...[
              const SizedBox(height: 12),
              // Dropdown kategori pengeluaran dengan list dari variable categories
              DropdownButtonFormField(
                value: category,
                decoration: const InputDecoration(labelText: "Kategori Pengeluaran"),
                // Map daftar kategori menjadi dropdown items
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                // Ketika kategori berubah, update state
                onChanged: (v) => setState(() => category = v.toString()),
              ),
            ],

            const SizedBox(height: 24),

            /// ===== BUTTON SUBMIT (TAMBAH/UPDATE) =====
            ElevatedButton(
              onPressed: () {
                // Cek apakah mode edit atau tambah
                if (isEdit) {
                  // Mode edit: update transaksi dengan ID lama dan tanggal lama
                  dp.updateTransaction(
                    TransactionModel(
                      id: widget.transaction!.id,
                      title: titleC.text,
                      // Parse jumlah dari TextField, default 0 jika parsing gagal
                      amount: double.tryParse(amountC.text) ?? 0,
                      type: type,
                      // Jika income, kategori tidak perlu (set "-"), jika expense gunakan kategori yang dipilih
                      category: type == "income" ? "-" : category,
                      date: widget.transaction!.date,
                    ),
                  );
                } else {
                  // Mode tambah: buat transaksi baru dengan tanggal hari ini
                  dp.addTransaction(
                    TransactionModel(
                      title: titleC.text,
                      // Parse jumlah dari TextField, default 0 jika parsing gagal
                      amount: double.tryParse(amountC.text) ?? 0,
                      type: type,
                      // Jika income, kategori tidak perlu (set "-"), jika expense gunakan kategori yang dipilih
                      category: type == "income" ? "-" : category,
                      date: DateTime.now(),
                    ),
                  );
                }
                // Tutup halaman dan kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              child: Text(isEdit ? "Update" : "Tambah"),
            ),
          ],
        ),
      ),
    );
  }
}

