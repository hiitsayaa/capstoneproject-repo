import 'package:flutter/material.dart';
import 'package:flutter_application_1/account/visitorterdaftar.dart';
import 'package:flutter_application_1/auth/views/register_view.dart';
import 'package:flutter_application_1/auth/views/lupa_sandi_view.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _sandiCtrl = TextEditingController();
  bool _autoValidate = false;
  bool _obscure = true;
  bool _ingatSaya = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _sandiCtrl.dispose();
    _authController.dispose();
    super.dispose();
  }

  void _onMasuk() async {
    setState(() => _autoValidate = true);
    if (_formKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _sandiCtrl.text;

      final success = await _authController.login(email, password);
      
      if (!mounted) return;
      
      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const VisitorTerdaftarPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.cancel, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(_authController.errorMessage ?? 'Gagal login', style: const TextStyle(fontFamily: 'Poppins')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Login', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/logomajadigitext.jpeg', width: 120),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(20)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.language, size: 14, color: Colors.black54),
                        SizedBox(width: 4),
                        Text('Bahasa Indonesia', style: TextStyle(fontSize: 11)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text('Login', style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Buat akun untuk nikmati semua fitur layanan publik dalam satu aplikasi',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280), height: 1.4)),
                const SizedBox(height: 28),

                // Email
                const Text('Email', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Masukkan email',
                  validator: (v) {
                    if (v!.trim().isEmpty) return 'Email tidak boleh kosong';
                    if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v.trim())) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kata Sandi
                const Text('Kata Sandi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: _sandiCtrl,
                  obscureText: _obscure,
                  hintText: 'Masukkan kata sandi',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF6B7280), size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) => v!.isEmpty ? 'Kata Sandi tidak boleh kosong' : null,
                ),
                const SizedBox(height: 8),

                // Ingat saya & Lupa kata sandi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24, height: 24,
                          child: Checkbox(
                            value: _ingatSaya,
                            onChanged: (v) => setState(() => _ingatSaya = v!),
                            activeColor: const Color(0xFF2979FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('Ingat saya', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LupaSandiPage())),
                      child: const Text('Lupa kata sandi?', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Masuk button
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ListenableBuilder(
                    listenable: _authController,
                    builder: (context, _) {
                      return ElevatedButton(
                        onPressed: _authController.isLoading ? null : _onMasuk,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2979FF), foregroundColor: Colors.white, elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        child: _authController.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Masuk'),
                      );
                    }
                  ),
                ),
                const SizedBox(height: 20),


                // Belum memiliki akun?
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum memiliki akun? ', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280))),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                        child: const Text('Daftar', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Terms
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF9CA3AF)),
                      children: [
                        TextSpan(text: 'Dengan login ke Akun Majadigi, Anda telah menyetujui\n'),
                        TextSpan(text: 'Syarat dan Ketentuan', style: TextStyle(color: Color(0xFF2979FF), fontWeight: FontWeight.w500)),
                        TextSpan(text: ' kami.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
