// Widget kartu jadwal yang menampilkan event/jadwal dengan waktu
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatelessWidget {
  // Judul atau nama jadwal/event
  final String title;
  // Tanggal dan waktu jadwal
  final DateTime datetime;
  // Callback ketika tombol hapus ditekan
  final VoidCallback? onDelete;
  // Callback ketika tombol edit ditekan
  final VoidCallback? onEdit;

  const ScheduleCard({
    super.key,
    required this.title,
    required this.datetime,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Format tanggal dan waktu menjadi string yang mudah dibaca
    final formattedDate = DateFormat('dd MMM yyyy HH:mm').format(datetime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Ikon event dengan background berwarna biru
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.event, color: Colors.blue.shade600),
            ),
            const SizedBox(width: 12),

            // Bagian utama: judul jadwal dan tanggal/waktu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul jadwal dengan ellipsis jika terlalu panjang
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Tanggal dan waktu dalam format lokal
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),

            // Tombol edit (opsional)
            if (onEdit != null)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue.shade400),
                onPressed: onEdit,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                splashRadius: 20,
              ),
            // Tombol hapus (opsional)
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red.shade400),
                onPressed: onDelete,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                splashRadius: 20,
              ),
          ],
        ),
      ),
    );
  }
}
