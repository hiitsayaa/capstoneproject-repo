import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter_application_1/auth/views/login_view.dart';

class RegisterStep2Page extends StatefulWidget {
  final String namaDepan;
  final String namaBelakang;
  final String nomorHP;
  final String email;

  const RegisterStep2Page({
    super.key,
    required this.namaDepan,
    required this.namaBelakang,
    required this.nomorHP,
    required this.email,
  });

  @override
  State<RegisterStep2Page> createState() => _RegisterStep2PageState();
}

class _RegisterStep2PageState extends State<RegisterStep2Page> {
  final _formKey = GlobalKey<FormState>();
  final _alamatCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _tglLahirCtrl = TextEditingController();
  final _kataSandiCtrl = TextEditingController();
  final _ulangiSandiCtrl = TextEditingController();

  final _authController = AuthController();
  final _jenisKelaminCtrl = TextEditingController();
  bool _autoValidate = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _alamatCtrl.dispose();
    _nikCtrl.dispose();
    _tglLahirCtrl.dispose();
    _kataSandiCtrl.dispose();
    _ulangiSandiCtrl.dispose();
    _jenisKelaminCtrl.dispose();
    _authController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 6, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        _tglLahirCtrl.text = DateFormat('d MMMM yyyy', 'id').format(picked);
      });
    }
  }

  Future<void> _pickJenisKelamin() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Opsi Jenis Kelamin', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Laki-laki', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                onTap: () => Navigator.pop(context, 'Laki-laki'),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Perempuan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                onTap: () => Navigator.pop(context, 'Perempuan'),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      setState(() => _jenisKelaminCtrl.text = selected);
    }
  }

  void _onDaftar() async {
    setState(() => _autoValidate = true);
    if (_formKey.currentState!.validate()) {
      final success = await _authController.register(
        email: widget.email,
        password: _kataSandiCtrl.text,
        namaDepan: widget.namaDepan,
        namaBelakang: widget.namaBelakang,
        nomorHp: widget.nomorHP,
        alamat: _alamatCtrl.text,
        nik: _nikCtrl.text,
        tanggalLahir: _tglLahirCtrl.text,
        jenisKelamin: _jenisKelaminCtrl.text,
      );
      
      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan login.'), backgroundColor: Colors.green),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authController.errorMessage ?? 'Gagal daftar', style: const TextStyle(fontFamily: 'Poppins')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  InputDecoration _inputDeco(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFFADB5BD)),
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF), width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      errorStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.red),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
    );
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
                      const SizedBox(height: 24),
                      const Text('Daftar', style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Buat akun untuk nikmati semua fitur layanan publik dalam satu aplikasi',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280), height: 1.4)),
                      const SizedBox(height: 28),

                      // Alamat
                      _label('Alamat'),
                      TextFormField(
                        controller: _alamatCtrl,
                        maxLines: 2,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: _inputDeco('Masukkan alamat'),
                        validator: (v) => v!.trim().isEmpty ? 'Alamat tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),

                      // NIK
                      _label('NIK'),
                      TextFormField(
                        controller: _nikCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: _inputDeco('Masukkan NIK'),
                        validator: (v) {
                          if (v!.trim().isEmpty) return 'NIK tidak boleh kosong';
                          if (v.trim().length != 16) return 'NIK harus 16 digit';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Lahir
                      _label('Tanggal Lahir'),
                      TextFormField(
                        controller: _tglLahirCtrl,
                        readOnly: true,
                        onTap: _pickDate,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: _inputDeco('Masukkan tanggal lahir',
                          suffixIcon: const Icon(Icons.calendar_today, size: 20, color: Color(0xFF6B7280)),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Tanggal lahir tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),

                      // Jenis Kelamin
                      _label('Jenis Kelamin'),
                      TextFormField(
                        controller: _jenisKelaminCtrl,
                        readOnly: true,
                        onTap: _pickJenisKelamin,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: _inputDeco('Masukkan jenis kelamin',
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF6B7280)),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Jenis kelamin tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),

                      // Kata Sandi
                      _label('Kata Sandi'),
                      TextFormField(
                        controller: _kataSandiCtrl,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: _inputDeco('Masukkan kata sandi',
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF6B7280), size: 20),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return 'Kata Sandi tidak boleh kosong';
                          if (v.length < 8) return 'Kata Sandi minimal 8 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Ulangi Kata Sandi
                      _label('Ulangi Kata Sandi'),
                      TextFormField(
                        controller: _ulangiSandiCtrl,
                        obscureText: _obscureConfirm,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: _inputDeco('Masukkan kata sandi',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF6B7280), size: 20),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return 'Kata Sandi tidak boleh kosong';
                          if (v != _kataSandiCtrl.text) return 'Kata Sandi tidak cocok';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ListenableBuilder(
                      listenable: _authController,
                      builder: (context, _) {
                        return ElevatedButton(
                          onPressed: _authController.isLoading ? null : _onDaftar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2979FF), foregroundColor: Colors.white, elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          child: _authController.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Daftar'),
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
