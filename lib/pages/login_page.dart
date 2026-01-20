// Halaman login untuk masuk ke akun
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk input email
  final emailC = TextEditingController();
  // Controller untuk input password
  final passC = TextEditingController();
  // Flag untuk menunjukkan apakah sedang loading
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Akses AuthProvider untuk proses login
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          // SingleChildScrollView untuk menghandle keyboard yang muncul
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Judul halaman
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

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

                // Tombol login
                ElevatedButton(
                  // Disable button saat loading
                  onPressed: loading ? null : () async {
                    // Set loading menjadi true saat proses dimulai
                    setState(() => loading = true);
                    // Panggil method login dari AuthProvider
                    final ok = await auth.login(emailC.text, passC.text);
                    // Set loading menjadi false setelah selesai
                    setState(() => loading = false);

                    if (ok) {
                      // Jika login berhasil, navigasi ke dashboard
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const DashboardPage()),
                      );
                    } else {
                      // Jika login gagal, tampilkan error snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email atau password salah")),
                      );
                    }
                  },
                  // Tampilkan loading indicator saat loading, teks biasa saat tidak
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),

                const SizedBox(height: 16),

                // Tombol untuk navigasi ke halaman registrasi
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()));
                  },
                  child: const Text("Belum punya akun? Daftar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


