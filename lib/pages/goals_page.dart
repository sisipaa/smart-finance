// Halaman untuk menampilkan dan mengelola goals/target tabungan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../models/goal_model.dart';
import '../widgets/goals_card.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  // Form key untuk validasi form dialog
  final _formKey = GlobalKey<FormState>();

  // Menampilkan dialog untuk menambah atau edit goal
  Future<void> _showAddDialog(BuildContext context, {GoalModel? edit}) async {
    // Controller untuk input judul
    final titleCtrl = TextEditingController(text: edit?.title ?? '');
    // Controller untuk input target nominal
    final targetCtrl = TextEditingController(text: edit?.targetAmount.toString() ?? '0');
    // Controller untuk input saldo saat ini
    final currentCtrl = TextEditingController(text: edit?.currentAmount.toString() ?? '0');
    // Tanggal target (jika edit, ambil dari data lama)
    DateTime? targetDate = edit?.targetDate != null ? DateTime.tryParse(edit!.targetDate!) : null;

    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          // Judul berbeda apakah tambah atau edit
          title: Text(edit == null ? 'Tambah Goal' : 'Edit Goal'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Input field judul goal
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Judul'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul diperlukan' : null,
                  ),
                  // Input field target nominal
                  TextFormField(
                    controller: targetCtrl,
                    decoration: const InputDecoration(labelText: 'Target Nominal'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || double.tryParse(v) == null || double.parse(v) <= 0) ? 'Masukkan angka > 0' : null,
                  ),
                  // Input field saldo saat ini
                  TextFormField(
                    controller: currentCtrl,
                    decoration: const InputDecoration(labelText: 'Saldo Saat Ini'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  // Row untuk menampilkan dan set tanggal target
                  Row(
                    children: [
                      Expanded(
                        // Tampilkan tanggal atau pesan "tidak ada"
                        child: Text(targetDate == null ? 'Target date not set' : DateFormat('dd MMM yyyy').format(targetDate!)),
                      ),
                      // Tombol untuk membuka date picker
                      TextButton(
                        onPressed: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: targetDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 3650)),
                            lastDate: DateTime.now().add(const Duration(days: 3650)),
                          );
                          if (d != null) {
                            // Update tanggal target
                            setState(() => targetDate = d);
                          }
                        },
                        child: const Text('Set Tanggal'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: [
            // Tombol batal
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            // Tombol simpan
            ElevatedButton(
              onPressed: () async {
                // Validasi form sebelum simpan
                if (!_formKey.currentState!.validate()) return;
                // Buat atau update object goal
                final g = GoalModel(
                  id: edit?.id,
                  title: titleCtrl.text.trim(),
                  targetAmount: double.parse(targetCtrl.text),
                  currentAmount: double.tryParse(currentCtrl.text) ?? 0,
                  targetDate: targetDate?.toIso8601String(),
                );
                final dp = Provider.of<DataProvider>(context, listen: false);
                // Tambah goal baru atau update goal yang sudah ada
                if (edit == null) await dp.addGoal(g); else await dp.updateGoal(g);
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Akses DataProvider untuk mendapatkan list goals
    final dp = Provider.of<DataProvider>(context);
    final goals = dp.goals;

    return Scaffold(
      appBar: AppBar(title: const Text('Goals Nabung')),
      // Tombol floating action untuk menambah goal baru
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Jika tidak ada goals, tampilkan pesan kosong
        child: goals.isEmpty
            ? const Center(child: Text('Belum ada goals. Tekan + untuk menambah.'))
            // Jika ada goals, tampilkan dalam ListView
            : ListView.separated(
                itemCount: goals.length,
                // Separator antar item
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final g = goals[i];
                  return GoalsCard(
                    title: g.title,
                    currentAmount: g.currentAmount,
                    targetAmount: g.targetAmount,
                    targetDate: g.targetDate,
                    // Callback saat tombol setor ditekan
                    onDeposit: () async {
                      // Buat controller untuk input nominal setoran
                      final amountCtrl = TextEditingController();
                      // Tampilkan dialog untuk input nominal
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Setor ke goal'),
                          content: TextField(
                            controller: amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Nominal'),
                          ),
                          actions: [
                            // Tombol batal
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            // Tombol OK
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      // Jika user klik OK, lakukan deposit
                      if (ok == true) {
                        final amt = double.tryParse(amountCtrl.text) ?? 0;
                        if (amt > 0) {
                          await Provider.of<DataProvider>(context, listen: false)
                              .depositToGoal(g.id!, amt);
                        }
                      }
                    },
                    // Callback saat tombol edit ditekan
                    onEdit: () => _showAddDialog(context, edit: g),
                    // Callback saat tombol hapus ditekan
                    onDelete: () async {
                      // Tampilkan confirmation dialog
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hapus goal?'),
                          actions: [
                            // Tombol batal
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            // Tombol hapus
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                      // Jika user klik hapus, lakukan delete
                      if (ok == true) {
                        await Provider.of<DataProvider>(context, listen: false)
                            .deleteGoal(g.id!);
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
