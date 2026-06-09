import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/hoaks/services/hoaks_service.dart';
import 'lacak_tiket.dart';

class LaporanHoaksPage extends StatefulWidget {
  const LaporanHoaksPage({super.key});

  @override
  State<LaporanHoaksPage> createState() => _LaporanHoaksPageState();
}

class _LaporanHoaksPageState extends State<LaporanHoaksPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _laporanController = TextEditingController();
  final _linkController = TextEditingController();
  final _captchaController = TextEditingController();

  String _captchaCode = '';
  String? _uploadedFileName;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _laporanController.dispose();
    _linkController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    setState(() {
      _captchaCode = String.fromCharCodes(
        Iterable.generate(
          6,
          (_) => chars.codeUnitAt(random.nextInt(chars.length)),
        ),
      );
    });
  }

  void _simulateFilePick() {
    // Simulate file pick since we don't have file_picker dependency
    setState(() {
      _uploadedFileName = 'bukti_hoaks.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File berhasil dipilih',
            style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_captchaController.text.toUpperCase() != _captchaCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode captcha tidak sesuai',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final deskripsi = _laporanController.text;
    String judul = deskripsi.length > 50 ? '${deskripsi.substring(0, 50)}...' : deskripsi;
    
    String status = await HoaksService.reportHoax(
      judulLaporan: judul,
      deskripsiKejadian: deskripsi,
      urlBukti: _linkController.text,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (status == 'success') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF2979FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                'Laporan Berhasil Dikirim',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Terima kasih telah melaporkan informasi mencurigakan. Kami akan segera memproses laporanmu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LacakTiketPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Lacak Tiket Saya', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _formKey.currentState?.reset();
                    _namaController.clear();
                    _emailController.clear();
                    _teleponController.clear();
                    _laporanController.clear();
                    _linkController.clear();
                    _captchaController.clear();
                    setState(() => _uploadedFileName = null);
                    _generateCaptcha();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2979FF),
                    side: const BorderSide(color: Color(0xFF2979FF)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kirim Laporan Lainnya', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (status == 'duplicate') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2979FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.priority_high, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                'Konten Ini Sudah Pernah Dilaporkan Sebagai Hoaks!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Laporan yang Anda kirimkan sudah teridentifikasi sebagai hoaks berdasarkan data kami',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _formKey.currentState?.reset();
                    _namaController.clear();
                    _emailController.clear();
                    _teleponController.clear();
                    _laporanController.clear();
                    _linkController.clear();
                    _captchaController.clear();
                    setState(() => _uploadedFileName = null);
                    _generateCaptcha();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2979FF),
                    side: const BorderSide(color: Color(0xFF2979FF)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kirim Laporan Lainnya', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      String errorMessage = 'Gagal mengirim laporan, silakan coba lagi';
      if (status.startsWith('error:')) {
        errorMessage = status;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage,
              style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
        title: const Text(
          'Laporan Hoaks',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),

              // Header
              const Center(
                child: Text(
                  'Lapor Hoaks',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Laporkan temuan hoaks yang Anda temukan untuk di verifikasi kebenaran informasinya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Nama
              _buildLabel('Nama'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _namaController,
                hint: 'Masukkan nama',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 18),

              // Email
              _buildLabel('Email'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _emailController,
                hint: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Nomor Telepon
              _buildLabel('Nomor Telepon'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _teleponController,
                hint: 'Masukkan nomor telepon',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nomor telepon wajib diisi' : null,
              ),
              const SizedBox(height: 18),

              // Isi Laporan
              _buildLabel('Isi Laporan'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _laporanController,
                hint: 'Masukkan isi laporan',
                maxLines: 5,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Isi laporan wajib diisi' : null,
              ),
              const SizedBox(height: 18),

              // Link/sumber
              _buildLabel('Link/sumber'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _linkController,
                hint: 'Contoh: https://...',
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 22),

              // Upload File
              GestureDetector(
                onTap: _simulateFilePick,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _uploadedFileName != null
                            ? Icons.check_circle
                            : Icons.cloud_upload_outlined,
                        size: 28,
                        color: _uploadedFileName != null
                            ? const Color(0xFF43A047)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Color(0xFF1A1A1A),
                          ),
                          children: [
                            const TextSpan(
                              text: 'Upload File ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: _uploadedFileName != null
                                  ? ''
                                  : '(Opsional)',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _uploadedFileName ?? 'Maks. 5 Mb',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: _uploadedFileName != null
                              ? const Color(0xFF43A047)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Captcha
              Row(
                children: [
                  // Captcha display
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _captchaCode.split('').map((char) {
                        final random = Random(char.codeUnitAt(0));
                        final colors = [
                          const Color(0xFFE53935),
                          const Color(0xFF43A047),
                          const Color(0xFF1565C0),
                          const Color(0xFFFF6F00),
                          const Color(0xFF7B1FA2),
                          const Color(0xFF00897B),
                        ];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            char,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colors[random.nextInt(colors.length)],
                              fontStyle: random.nextBool()
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Refresh captcha
                  GestureDetector(
                    onTap: _generateCaptcha,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.refresh,
                          color: Color(0xFF2979FF), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Captcha input
              _buildLabel('Kode Captcha'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _captchaController,
                hint: 'Masukkan kode captcha',
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v == null || v.isEmpty
                    ? 'Kode captcha wajib diisi'
                    : null,
              ),
              const SizedBox(height: 28),

              // Kirim Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF90CAF9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Kirim'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: Color(0xFFADB5BD),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2979FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          color: Color(0xFFE53935),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
