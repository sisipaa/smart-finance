// Widget kartu statistik yang menampilkan label dan jumlah dengan styling
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatCard extends StatelessWidget {
  // Label atau judul statistik
  final String label;
  // Nilai/jumlah yang akan ditampilkan
  final double amount;
  // Warna background kartu (opsional, default putih)
  final Color? backgroundColor;
  // Warna label (opsional)
  final Color? labelColor;
  // Warna untuk menampilkan nilai (opsional)
  final Color? amountColor;
  // Ikon yang akan ditampilkan di sebelah kiri (opsional)
  final IconData? icon;

  const StatCard({
    super.key,
    required this.label,
    required this.amount,
    this.backgroundColor,
    this.labelColor,
    this.amountColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Buat container dengan background, border-radius, dan shadow
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Shadow untuk memberikan kedalaman visual
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Jika ada ikon, tampilkan dengan background berwarna
          if (icon != null) ...[
            Container(
              decoration: BoxDecoration(
                color: (labelColor ?? Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: labelColor ?? Colors.blue, size: 24),
            ),
            const SizedBox(width: 12),
          ],
          // Bagian utama: label dan nilai
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label/judul statistik
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: labelColor ?? Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Nilai dengan format rupiah lokal
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
                      .format(amount),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: amountColor ?? Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
