import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/services/auth_service.dart';
import 'package:flutter_application_1/bansos/services/bansos_service.dart';

class SapaBansosAjukanPage extends StatefulWidget {
  const SapaBansosAjukanPage({super.key});

  @override
  State<SapaBansosAjukanPage> createState() => _SapaBansosAjukanPageState();
}

class _SapaBansosAjukanPageState extends State<SapaBansosAjukanPage> {
  int _currentStep = 0; // 0=Data Diri, 1=Data Ekonomi, 2=Upload Dokumen, 3=Konfirmasi

  // Services
  final AuthService _authService = AuthService();
  final BansosService _bansosService = BansosService();

  // Controllers Step 1
  final _nikCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tempatLahirCtrl = TextEditingController();
  final _tglLahirCtrl = TextEditingController();
  String? _jenisKelamin;
  final _alamatCtrl = TextEditingController();
  final _teleponCtrl = TextEditingController();
  
  // Field input manual
  final _ibuKandungCtrl = TextEditingController();

  // Controllers Step 2
  final _penghasilanCtrl = TextEditingController();
  final _tanggunganCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _authService.getFullProfile();
      if (profile != null) {
        setState(() {
          _nikCtrl.text = profile['nik']?.toString() ?? '';
          _namaCtrl.text = profile['nama_lengkap']?.toString() ?? '';
          _tempatLahirCtrl.text = profile['tempat_lahir']?.toString() ?? '';
          _tglLahirCtrl.text = profile['tanggal_lahir']?.toString() ?? '';
          _alamatCtrl.text = profile['alamat_lengkap']?.toString() ?? '';
          _teleponCtrl.text = profile['telepon']?.toString() ?? '';
          final jkRaw = profile['jenis_kelamin']?.toString().toLowerCase() ?? '';
          if (jkRaw.startsWith('l') || jkRaw == 'pria') {
            _jenisKelamin = 'Laki-laki';
          } else if (jkRaw.startsWith('p') || jkRaw == 'wanita') {
            _jenisKelamin = 'Perempuan';
          } else {
            _jenisKelamin = null;
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nikCtrl.dispose();
    _namaCtrl.dispose();
    _tempatLahirCtrl.dispose();
    _tglLahirCtrl.dispose();
    _alamatCtrl.dispose();
    _ibuKandungCtrl.dispose();
    _teleponCtrl.dispose();
    _penghasilanCtrl.dispose();
    _tanggunganCtrl.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Submit form
      await _submitApplication();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitApplication() async {
    if (_ibuKandungCtrl.text.isEmpty || _penghasilanCtrl.text.isEmpty || _tanggunganCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _bansosService.apply(
        programId: '40000000-0000-0000-0000-000000000001',
        namaIbuKandung: _ibuKandungCtrl.text,
        penghasilanBulanan: double.tryParse(_penghasilanCtrl.text) ?? 0,
        jumlahTanggungan: int.tryParse(_tanggunganCtrl.text) ?? 0,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengajuan berhasil dikirim!')));
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Color(0xFF43A047), size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Berhasil',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pengajuan bansos Anda telah berhasil dikirim. Silakan cek status secara berkala.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Selesai', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ajukan Bansos',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () {
            if (_currentStep > 0) {
              _prevStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Custom Stepper Header
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: _buildStepperHeader(),
                ),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildStepContent(),
                  ),
                ),

                // Bottom Buttons
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _currentStep == 3 ? 'Kirim' : 'Selanjutnya',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepperHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepIndicator(0, 'Data Diri'),
        _buildLine(0),
        _buildStepIndicator(1, 'Data Ekonomi'),
        _buildLine(1),
        _buildStepIndicator(2, 'Upload Dokumen'),
        _buildLine(2),
        _buildStepIndicator(3, 'Konfirmasi'),
      ],
    );
  }

  Widget _buildStepIndicator(int index, String title) {
    bool isActive = _currentStep == index;
    bool isCompleted = _currentStep > index;

    Color circleColor = isActive || isCompleted ? const Color(0xFF2979FF) : Colors.white;
    Color borderColor = isActive || isCompleted ? const Color(0xFF2979FF) : const Color(0xFF9CA3AF);
    Color textColor = isActive || isCompleted ? Colors.white : const Color(0xFF9CA3AF);

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: circleColor,
              border: Border.all(color: borderColor),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 8,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? const Color(0xFF1A1A1A) : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(int index) {
    bool isCompleted = _currentStep > index;
    return Container(
      width: 20,
      height: 1,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? const Color(0xFF2979FF) : const Color(0xFFE5E7EB),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  // ─────────────────────────────────────────────
  // STEP 1: Data Diri
  // ─────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Diri Pemohon',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Beberapa data diisi secara otomatis dari profil Anda.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),
        _buildTextField('NIK', _nikCtrl, hint: 'Masukkan NIK', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField('Nama Lengkap Sesuai KTP *', _namaCtrl, hint: 'Masukkan nama'),
        const SizedBox(height: 16),
        _buildTextField('Tempat Lahir', _tempatLahirCtrl, hint: 'Masukkan tempat lahir'),
        const SizedBox(height: 16),
        // Tanggal Lahir (with icon)
        const Text('Tanggal Lahir*', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        TextField(
          controller: _tglLahirCtrl,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Masukkan tanggal lahir',
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        // Jenis Kelamin
        const Text('Jenis Kelamin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRadioChip('Laki-laki', _jenisKelamin == 'Laki-laki', () => setState(() => _jenisKelamin = 'Laki-laki')),
            const SizedBox(width: 16),
            _buildRadioChip('Perempuan', _jenisKelamin == 'Perempuan', () => setState(() => _jenisKelamin = 'Perempuan')),
          ],
        ),
        const SizedBox(height: 16),
        // Alamat Text Area
        const Text('Alamat sesuai KTP', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        TextField(
          controller: _alamatCtrl,
          maxLines: 4,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Masukkan alamat lengkap',
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField('Nomor Telepon yang Bisa Dihubungi', _teleponCtrl, hint: 'Masukkan nomor telepon', keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField('Nama Lengkap Ibu Kandung', _ibuKandungCtrl, hint: 'Masukkan nama lengkap ibu kandung'),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STEP 2: Data Ekonomi
  // ─────────────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Ekonomi Pemohon',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Isilah data dibawah ini dengan jujur dan benar.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),
        
        _buildTextField(
          'Penghasilan Per Bulan (Rp)', 
          _penghasilanCtrl, 
          hint: 'Contoh: 1500000', 
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Jumlah Tanggungan', 
          _tanggunganCtrl, 
          hint: 'Contoh: 3', 
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STEP 3: Placeholders
  // ─────────────────────────────────────────────
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Dokumen',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Silakan unggah dokumen persyaratan.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),
        _buildUploadBox('KTP (Kartu Tanda Penduduk)'),
        const SizedBox(height: 16),
        _buildUploadBox('KK (Kartu Keluarga)'),
        const SizedBox(height: 16),
        _buildUploadBox('Foto Rumah Tampak Depan'),
      ],
    );
  }

  Widget _buildUploadBox(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Icon(Icons.cloud_upload_outlined, color: Color(0xFF9CA3AF), size: 32),
              const SizedBox(height: 8),
              const Text('Pilih File', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
              const SizedBox(height: 4),
              const Text('Maks 5 MB (JPG/PNG/PDF)', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9CA3AF))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Konfirmasi',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pastikan semua data yang Anda isi sudah benar.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),

        // Summary Data
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow('NIK', _nikCtrl.text),
              _buildSummaryRow('Nama Lengkap', _namaCtrl.text),
              _buildSummaryRow('Tempat, Tanggal Lahir', '${_tempatLahirCtrl.text}, ${_tglLahirCtrl.text}'),
              _buildSummaryRow('Jenis Kelamin', _jenisKelamin ?? '-'),
              _buildSummaryRow('Telepon', _teleponCtrl.text),
              _buildSummaryRow('Nama Ibu Kandung', _ibuKandungCtrl.text),
              _buildSummaryRow('Penghasilan', 'Rp ${_penghasilanCtrl.text}'),
              _buildSummaryRow('Tanggungan', '${_tanggunganCtrl.text} Orang'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFCC80)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Color(0xFFE65100), size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dengan mengirim form ini, Anda menyatakan bahwa data yang diberikan adalah benar dan dapat dipertanggungjawabkan.',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFFE65100), height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ),
          const Text(':', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Helper Widgets
  // ─────────────────────────────────────────────
  Widget _buildTextField(String label, TextEditingController controller, {String? hint, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFF9CA3AF), width: 2),
            ),
            child: Center(
              child: isSelected ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle)) : null,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }
}
