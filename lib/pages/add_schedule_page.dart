// Import library Flutter untuk material design UI
import 'package:flutter/material.dart';
// Import Provider untuk akses state management (DataProvider)
import 'package:provider/provider.dart';
// Import DataProvider untuk CRUD operasi jadwal
import '../providers/data_provider.dart';
// Import ScheduleModel untuk data class jadwal
import '../models/schedule_model.dart';

// Class AddSchedulePage adalah StatefulWidget untuk menambah atau edit jadwal kegiatan
class AddSchedulePage extends StatefulWidget {
  // Parameter schedule opsional untuk mode edit (jika null = mode tambah)
  final ScheduleModel? schedule;

  const AddSchedulePage({super.key, this.schedule});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

// State class untuk AddSchedulePage yang mengelola form jadwal dan date/time picker
class _AddSchedulePageState extends State<AddSchedulePage> {
  // Controller untuk TextField judul kegiatan
  late TextEditingController titleC;
  // Controller untuk TextField catatan/deskripsi kegiatan
  late TextEditingController noteC;
  // State untuk menyimpan tanggal dan waktu yang dipilih
  late DateTime picked;

  // initState dipanggil saat widget pertama kali dimount
  @override
  void initState() {
    super.initState();
    // Cek apakah ini mode edit (widget.schedule bukan null)
    if (widget.schedule != null) {
      // Mode edit: isi controller dan state dengan data jadwal yang ada
      titleC = TextEditingController(text: widget.schedule!.title);
      noteC = TextEditingController(text: widget.schedule!.note);
      picked = widget.schedule!.datetime;
    } else {
      // Mode tambah baru: buat controller kosong dan set default tanggal/waktu hari ini
      titleC = TextEditingController();
      noteC = TextEditingController();
      picked = DateTime.now();
    }
  }

  // dispose dipanggil saat widget dihapus dari tree untuk cleanup
  @override
  void dispose() {
    // Bersihkan TextEditingController untuk menghindari memory leak
    titleC.dispose();
    noteC.dispose();
    super.dispose();
  }

  // Method build yang membangun UI form untuk tambah/edit jadwal
  @override
  Widget build(BuildContext context) {
    // Ambil DataProvider untuk akses method addSchedule dan updateSchedule
    final dp = Provider.of<DataProvider>(context);
    // Tentukan apakah ini mode edit atau mode tambah baru
    final isEdit = widget.schedule != null;

    return Scaffold(
      // AppBar dengan judul dinamis sesuai mode (edit atau tambah)
      appBar: AppBar(title: Text(isEdit ? "Edit Jadwal" : "Tambah Jadwal")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// ===== FIELD JUDUL KEGIATAN =====
            TextField(
              controller: titleC,
              decoration: const InputDecoration(labelText: "Judul Kegiatan"),
            ),
            const SizedBox(height: 12),

            /// ===== FIELD CATATAN =====
            TextField(
              controller: noteC,
              decoration: const InputDecoration(labelText: "Catatan"),
            ),
            const SizedBox(height: 12),

            /// ===== BUTTON DATE & TIME PICKER =====
            ElevatedButton(
              onPressed: () async {
                // Tampilkan date picker untuk memilih tanggal
                final dt = await showDatePicker(
                  context: context,
                  // Tanggal minimum yang bisa dipilih: tahun 2022
                  firstDate: DateTime(2022),
                  // Tanggal maksimum yang bisa dipilih: tahun 2035
                  lastDate: DateTime(2035),
                  // Tanggal yang ditampilkan pertama kali di date picker
                  initialDate: picked,
                );

                // Jika user memilih tanggal (bukan dibatalkan)
                if (dt != null) {
                  // Tampilkan time picker untuk memilih waktu
                  final tm = await showTimePicker(
                    context: context,
                    // Waktu yang ditampilkan pertama kali di time picker
                    initialTime: TimeOfDay.fromDateTime(picked),
                  );

                  // Jika user memilih waktu (bukan dibatalkan)
                  if (tm != null) {
                    // Gabungkan tanggal dari date picker dengan waktu dari time picker
                    picked = DateTime(
                      dt.year, dt.month, dt.day, tm.hour, tm.minute
                    );
                    // Rebuild widget untuk menampilkan tanggal/waktu yang baru dipilih
                    setState(() {});
                  }
                }
              },
              child: const Text("Pilih Tanggal & Waktu"),
            ),

            const SizedBox(height: 8),
            // Tampilkan string representasi dari DateTime yang dipilih
            Text(picked.toString()),

            const SizedBox(height: 24),

            /// ===== BUTTON SUBMIT (TAMBAH/UPDATE) =====
            ElevatedButton(
              onPressed: () {
                // Cek apakah mode edit atau tambah
                if (isEdit) {
                  // Mode edit: update jadwal dengan ID lama
                  dp.updateSchedule(
                    ScheduleModel(
                      id: widget.schedule!.id,
                      title: titleC.text,
                      note: noteC.text,
                      datetime: picked,
                    ),
                  );
                } else {
                  // Mode tambah: buat jadwal baru
                  dp.addSchedule(
                    ScheduleModel(
                      title: titleC.text,
                      note: noteC.text,
                      datetime: picked,
                    ),
                  );
                }
                // Tutup halaman dan kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              child: Text(isEdit ? "Update Jadwal" : "Tambah Jadwal"),
            ),
          ],
        ),
      ),
    );
  }
}

