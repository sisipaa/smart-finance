// Widget kartu goals yang menampilkan progress mencapai target tabungan
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalsCard extends StatelessWidget {
  // Judul atau nama goals
  final String title;
  // Jumlah uang yang sudah terkumpul
  final double currentAmount;
  // Target jumlah uang yang ingin dicapai
  final double targetAmount;
  // Tanggal target pencapaian goals (opsional)
  final String? targetDate;
  // Callback untuk mengedit goals
  final VoidCallback? onEdit;
  // Callback untuk menghapus goals
  final VoidCallback? onDelete;
  // Callback untuk menambah uang ke goals
  final VoidCallback? onDeposit;

  const GoalsCard({
    super.key,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    this.targetDate,
    this.onEdit,
    this.onDelete,
    this.onDeposit,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung persentase progress (0-100%)
    final pct = targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0.0;
    // Konversi persentase ke nilai 0.0-1.0 untuk LinearProgressIndicator
    final progressValue = (pct / 100).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris judul dan tombol aksi
            Row(
              children: [
                // Ikon dengan background ungu
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.savings, color: Colors.purple.shade600),
                ),
                const SizedBox(width: 12),

                // Judul goals dengan ellipsis jika terlalu panjang
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Menu popup untuk setor/edit/hapus
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'deposit') onDeposit?.call();
                    else if (v == 'edit') onEdit?.call();
                    else if (v == 'delete') onDelete?.call();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'deposit', child: Text('Setor')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                  constraints: const BoxConstraints(minWidth: 120),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Progress bar dengan warna yang berubah sesuai progress
            // Biru (<50%), Orange (50-80%), Hijau (>80%)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progressValue,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  progressValue < 0.5
                      ? Colors.blue.shade400
                      : progressValue < 0.8
                          ? Colors.orange.shade400
                          : Colors.green.shade400,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Informasi jumlah saat ini, target, dan persentase progress
            Text(
              '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(currentAmount)} / ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(targetAmount)}  •  ${pct.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),

            // Tampilkan target date jika tersedia
            if (targetDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                // Tampilkan tanggal target dalam format lokal
                child: Text(
                  'Target: ${DateFormat('dd MMM yyyy').format(DateTime.parse(targetDate!))}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
