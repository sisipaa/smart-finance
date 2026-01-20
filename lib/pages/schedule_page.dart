// Halaman untuk menampilkan dan mengelola daftar jadwal
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/schedule_card.dart';
import 'add_schedule_page.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Akses DataProvider untuk mendapatkan list schedules
    final dp = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal")),
      // Tombol floating action untuk menambah jadwal baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah jadwal
          Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddSchedulePage()));
        },
        child: const Icon(Icons.add),
      ),
      // Daftar jadwal ditampilkan dalam ListView
      body: ListView.builder(
        itemCount: dp.schedules.length,
        itemBuilder: (context, i) {
          final s = dp.schedules[i];
          return ScheduleCard(
            title: s.title,
            datetime: s.datetime,
            // Callback saat tombol edit ditekan
            onEdit: () {
              // Navigasi ke halaman edit jadwal dengan membawa data jadwal
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddSchedulePage(schedule: s),
                ),
              );
            },
            // Callback saat tombol hapus ditekan
            onDelete: () => dp.deleteSchedule(s.id!),
          );
        },
      ),
    );
  }
}


