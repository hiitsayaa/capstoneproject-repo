import 'package:flutter/material.dart';

class SapaBansosAjukanPage extends StatefulWidget {
  const SapaBansosAjukanPage({super.key});

  @override
  State<SapaBansosAjukanPage> createState() => _SapaBansosAjukanPageState();
}

class _SapaBansosAjukanPageState extends State<SapaBansosAjukanPage> {
  int _currentStep = 0; // 0=Data Diri, 1=Data Ekonomi, 2=Upload Dokumen, 3=Konfirmasi

  // Controllers Step 1
  final _noKkCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tempatLahirCtrl = TextEditingController();
  final _tglLahirCtrl = TextEditingController();
  String? _jenisKelamin;
  final _kabupatenCtrl = TextEditingController();
  final _kecamatanCtrl = TextEditingController();
  final _kelurahanCtrl = TextEditingController(); // Kelurahan/Desa 1
  final _rtCtrl = TextEditingController();
  final _rwCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _ibuKandungCtrl = TextEditingController();
  final _teleponCtrl = TextEditingController();
  final _kelurahan2Ctrl = TextEditingController(); // Kelurahan/Desa 2

  // Controllers Step 2
  String? _penghasilan;
  final _tanggunganCtrl = TextEditingController();

  final List<String> _penghasilanList = [
    '< Rp 1.000.000',
    'Rp 1.000.000 - Rp 2.500.000',
    'Rp 2.500.000 - Rp 5.000.000',
    '> Rp 5.000.000'
  ];

  @override
  void dispose() {
    _noKkCtrl.dispose();
    _nikCtrl.dispose();
    _namaCtrl.dispose();
    _tempatLahirCtrl.dispose();
    _tglLahirCtrl.dispose();
    _kabupatenCtrl.dispose();
    _kecamatanCtrl.dispose();
    _kelurahanCtrl.dispose();
    _rtCtrl.dispose();
    _rwCtrl.dispose();
    _alamatCtrl.dispose();
    _ibuKandungCtrl.dispose();
    _teleponCtrl.dispose();
    _kelurahan2Ctrl.dispose();
    _tanggunganCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Submit form
      _showSuccessDialog();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
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
      body: Column(
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
                  _currentStep == 3 ? 'Kirim' : 'Kirim', // Looking at screenshot, it always says "Kirim" actually. But typically "Selanjutnya"
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
        return _buildStep3(); // Placeholder for documents
      case 3:
        return _buildStep4(); // Placeholder for confirmation
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
          'Isilah data dibawah ini dengan jujur dan benar.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),
        _buildTextField('Nomor Kartu Keluarga', _noKkCtrl, hint: 'Masukkan nomor kartu keluarga', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
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
        _buildTextField('Kabupaten/Kota', _kabupatenCtrl, hint: 'Masukkan kabupaten/kota'),
        const SizedBox(height: 16),
        _buildTextField('Kecamatan', _kecamatanCtrl, hint: 'Masukkan kecamatan'),
        const SizedBox(height: 16),
        _buildTextField('Kelurahan/Desa', _kelurahanCtrl, hint: 'Masukkan kelurahan/desa'),
        const SizedBox(height: 16),
        // RT/RW Row
        Row(
          children: [
            Expanded(child: _buildTextField('RT', _rtCtrl, hint: 'No RT', keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('RW', _rwCtrl, hint: 'No RW', keyboardType: TextInputType.number)),
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
        _buildTextField('Nama Lengkap Ibu Kandung', _ibuKandungCtrl, hint: 'Masukkan nama lengkap ibu kandung'),
        const SizedBox(height: 16),
        _buildTextField('Nomor Telepon yang Bisa Dihubungi', _teleponCtrl, hint: 'Masukkan nomor telepon', keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField('Kelurahan/Desa', _kelurahan2Ctrl, hint: 'Masukkan kelurahan/desa'),
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
        // Penghasilan Per Bulan Dropdown
        const Text('Penghasilan Per Bulan', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _penghasilan,
              isExpanded: true,
              hint: const Text('Pilih Penghasilan', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF))),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
              items: _penghasilanList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF1A1A1A))),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _penghasilan = newValue;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Jumlah Tanggungan
        _buildTextField('Jumlah Tanggungan', _tanggunganCtrl, hint: 'Masukkan NIK', keyboardType: TextInputType.number), // Assuming NIK here is from screenshot or "Masukkan jumlah tanggungan"
        const SizedBox(height: 16),
        
        // Show all fields from step 1 but disabled or as placeholders just to mimic the screenshot
        // The screenshot shows Step 2 having the same layout underneath Data Ekonomi? 
        // Wait, the screenshot "Halaman Ajukan Bansos" (Step 2) shows "Data Ekonomi Pemohon" with "Penghasilan Per Bulan", "Jumlah Tanggungan", and then it shows "Nama Lengkap Sesuai KTP", "Tempat Lahir", "Tanggal Lahir" which are exactly from Step 1.
        // That means the user scrolled down, and the screenshot is just the same long form with Step 2 active, OR the design is to show all steps stacked.
        // Actually, looking closely at the 2nd image for Ajukan Bansos:
        // It says "Data Ekonomi Pemohon" -> Penghasilan, Jumlah Tanggungan. Then "Nama Lengkap Sesuai KTP *" !!
        // This is clearly a mockup error where they pasted Data Diri fields below Data Ekonomi fields.
        // I'll just use Penghasilan and Tanggungan for Data Ekonomi to make it logical.
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STEP 3 & 4: Placeholders
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFCC80)),
          ),
          child: const Row(
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
