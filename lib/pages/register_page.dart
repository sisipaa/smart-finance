// Halaman untuk registrasi/mendaftar akun baru
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk input email
  final emailC = TextEditingController();
  // Controller untuk input password
  final passC = TextEditingController();
  // Flag untuk menunjukkan apakah sedang loading
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Akses AuthProvider untuk proses registrasi
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Input field untuk email
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),

            // Input field untuk password (hidden)
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 24),

            // Tombol daftar
            ElevatedButton(
              // Disable button saat loading
              onPressed: loading ? null : () async {
                // Set loading menjadi true saat proses dimulai
                setState(() => loading = true);
                // Panggil method register dari AuthProvider
                await auth.register(emailC.text, passC.text);
                // Set loading menjadi false setelah selesai
                setState(() => loading = false);

                // Tampilkan snackbar pesan sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Berhasil daftar! Silakan login")),
                );

                // Navigasi ke halaman login dan hapus halaman ini dari stack
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              // Tampilkan loading indicator saat loading, teks biasa saat tidak
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}


