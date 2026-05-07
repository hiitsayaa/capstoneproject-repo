import 'package:flutter/material.dart';
import 'register_step2.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaDepanCtrl = TextEditingController();
  final _namaBelakangCtrl = TextEditingController();
  final _nomorHPCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _autoValidate = false;

  @override
  void dispose() {
    _namaDepanCtrl.dispose();
    _namaBelakangCtrl.dispose();
    _nomorHPCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onNext() {
    setState(() => _autoValidate = true);
    if (_formKey.currentState!.validate()) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => RegisterStep2Page(
          namaDepan: _namaDepanCtrl.text.trim(),
          namaBelakang: _namaBelakangCtrl.text.trim(),
          nomorHP: _nomorHPCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        ),
      ));
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
        title: const Text('Daftar', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 24),
                      const Text('Daftar', style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Buat akun untuk nikmati semua fitur layanan publik dalam satu aplikasi',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280), height: 1.4)),
                      const SizedBox(height: 28),
                      _field('Nama Depan', 'Masukkan nama depan', _namaDepanCtrl, (v) => v!.trim().isEmpty ? 'Nama tidak boleh kosong' : null),
                      const SizedBox(height: 16),
                      _field('Nama Belakang', 'Masukkan nama belakang', _namaBelakangCtrl, (v) => v!.trim().isEmpty ? 'Nama belakang tidak boleh kosong' : null),
                      const SizedBox(height: 16),
                      _field('Nomor HP', 'Masukkan nomor hp', _nomorHPCtrl, (v) {
                        if (v!.trim().isEmpty) return 'No HP tidak boleh kosong';
                        if (v.trim().length < 10) return 'No HP minimal 10 digit';
                        return null;
                      }, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _field('Email', 'Masukkan email', _emailCtrl, (v) {
                        if (v!.trim().isEmpty) return 'Email tidak boleh kosong';
                        if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v.trim())) return 'Format email tidak valid';
                        return null;
                      }, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF), foregroundColor: Colors.white, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  child: const Text('Selanjutnya'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController ctrl, String? Function(String?)? validator, {TextInputType keyboardType = TextInputType.text}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl, keyboardType: keyboardType, validator: validator,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFFADB5BD)),
          filled: true, fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF), width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
          errorStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.red),
        ),
      ),
    ]);
  }
}
