// Widget kartu transaksi yang menampilkan informasi singkat transaksi
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  // Judul atau deskripsi transaksi
  final String title;
  // Tanggal transaksi
  final DateTime date;
  // Jumlah uang transaksi
  final double amount;
  // Tipe: 'income' untuk pemasukan, 'expense' untuk pengeluaran
  final String type; // 'income' atau 'expense'
  // Kategori opsional (mis. 'makanan', 'transport')
  final String? category;
  // Callback ketika tombol hapus ditekan
  final VoidCallback? onDelete;
  // Callback ketika tombol edit ditekan
  final VoidCallback? onEdit;
  // Warna khusus untuk pemasukan (opsional)
  final Color? incomeColor;
  // Warna khusus untuk pengeluaran (opsional)
  final Color? expenseColor;

  const TransactionCard({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    this.category,
    this.onDelete,
    this.onEdit,
    this.incomeColor,
    this.expenseColor,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan apakah ini pemasukan berdasarkan properti type
    final isIncome = type == 'income';
    // Background card berbeda untuk income/expense agar mudah dibedakan
    final bgColor = isIncome ? Colors.green.shade50 : Colors.red.shade50;
    // Warna untuk menampilkan jumlah
    final amountColor = isIncome ? (incomeColor ?? Colors.green) : (expenseColor ?? Colors.red);
    // Ikon kecil yang mewakili tipe transaksi
    final icon = isIncome ? Icons.add_circle : Icons.remove_circle;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Kotak kecil dengan ikon yang berwarna sesuai tipe
            Container(
              decoration: BoxDecoration(
                color: amountColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: amountColor, size: 20),
            ),
            const SizedBox(width: 12),
            // Bagian utama: judul dan tanggal (+ kategori bila ada)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      // Format tanggal lokal (dd MMM yyyy)
                      Text(
                        DateFormat('dd MMM yyyy').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      // Jika kategori ada, tampilkan di sebelah tanggal
                      if (category != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            category!,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            // Bagian kanan: jumlah, tombol edit/hapus jika tersedia
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Tampilkan jumlah dengan simbol +/-, dan format rupiah lokal
                Text(
                  '${isIncome ? '+' : '-'} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: amountColor,
                  ),
                ),
                // Tombol edit (opsional)
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(Icons.edit, size: 16, color: Colors.blue.shade400),
                  ),
                if (onEdit != null && onDelete != null) const SizedBox(width: 8),
                // Tombol hapus (opsional)
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(Icons.delete, size: 16, color: Colors.red.shade400),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
