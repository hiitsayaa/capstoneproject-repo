import 'package:flutter/material.dart';

class RsudDahaHusadaAntrianPage extends StatefulWidget {
  const RsudDahaHusadaAntrianPage({super.key});

  @override
  State<RsudDahaHusadaAntrianPage> createState() => _RsudDahaHusadaAntrianPageState();
}

class _RsudDahaHusadaAntrianPageState extends State<RsudDahaHusadaAntrianPage> {
  int _selectedMainTab = 0; // 0: Cek Antrian, 1: Ambil Nomor Antrian

  // States for Cek Antrian
  String? _cekPoli;
  String? _cekDokter;
  bool _showCekResult = false;

  // States for Ambil Nomor Antrian (Wizard)
  int _wizardStep = 0; // 0: Pendaftaran, 1: Pilih Jadwal, 2: Konfirmasi, 3: Nomor Antrian
  
  // Step 1 Data
  final TextEditingController _namaCtrl = TextEditingController();
  String? _daftarPoli;
  String? _daftarTanggal;

  // Step 2 Data
  int _selectedScheduleIndex = -1;

  final List<String> _poliList = [
    'IGD', 'Klinik Mata', 'Klinik Penyakit Dalam', 'Klinik Kulit Kelamin', 
    'Klinik Bedah', 'Klinik Jantung', 'Klinik Kusta', 'Klinik Kebidanan', 
    'Klinik Anak', 'Klinik Umum', 'Klinik THT-KL', 'Klinik Gigi Umum'
  ];

  final List<String> _dokterList = [
    'dr. Darwan Triyono, Sp.M',
    'Dr. Richard'
  ];

  @override
  void dispose() {
    _namaCtrl.dispose();
    super.dispose();
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
          'Informasi Antrian Pasien',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Segmented Tab
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF2979FF)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMainTab = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedMainTab == 0 ? const Color(0xFF2979FF) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cek Antrian',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _selectedMainTab == 0 ? Colors.white : const Color(0xFF2979FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMainTab = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedMainTab == 1 ? const Color(0xFF2979FF) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Ambil Nomor Antrian',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _selectedMainTab == 1 ? Colors.white : const Color(0xFF2979FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: _selectedMainTab == 0 ? _buildCekAntrianView() : _buildAmbilAntrianView(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // VIEW: CEK ANTRIAN
  // ─────────────────────────────────────────────
  Widget _buildCekAntrianView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Text('Cek Antrian Saat Ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 24),
          
          // Dropdown Poli
          _buildDropdown('Pilih Poli', _cekPoli, _poliList, (val) => setState(() => _cekPoli = val)),
          const SizedBox(height: 16),
          // Dropdown Dokter
          _buildDropdown('Pilih Dokter', _cekDokter, _dokterList, (val) => setState(() => _cekDokter = val)),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_cekPoli != null && _cekDokter != null) {
                  setState(() => _showCekResult = true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih poli dan dokter terlebih dahulu')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Cek Antrian', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 32),

          if (!_showCekResult)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'Belum ada data antrian. Silakan pilih poli\ndan dokter lalu tekan Cek Antrian.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Data Antrian Saat Ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                const Text('Terakhir diperbarui: 2 April 2026, 08:45:00', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                const SizedBox(height: 16),
                
                // Table
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('No. Antrian', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            Expanded(child: Text('Jam Perkiraan', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            Expanded(child: Text('Status', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                          ],
                        ),
                      ),
                      // Row 1
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(child: Text('A-001', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)))),
                            const Expanded(child: Text('08:00 - 08:15', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF374151)))),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFF43A047)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text('Terlayani', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF43A047))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row 2
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(child: Text('A-002', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)))),
                            const Expanded(child: Text('08:15 - 08:30', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF374151)))),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFF57C00)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text('Menunggu', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFFF57C00))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                const Center(
                  child: Text('Menampilkan 1-2 dari 2 hasil', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chevron_left, color: Color(0xFFD1D5DB)),
                    const SizedBox(width: 16),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle),
                      child: const Center(child: Text('1', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // VIEW: AMBIL NOMOR ANTRIAN (WIZARD)
  // ─────────────────────────────────────────────
  Widget _buildAmbilAntrianView() {
    return Column(
      children: [
        // Stepper Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepIcon(0, 'Pendaftaran'),
              _buildStepDivider(),
              _buildStepIcon(1, 'Pilih Jadwal'),
              _buildStepDivider(),
              _buildStepIcon(2, 'Konfirmasi'),
              _buildStepDivider(),
              _buildStepIcon(3, 'Nomor Antrian'),
            ],
          ),
        ),
        
        // Wizard Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _buildWizardStepContent(),
          ),
        ),
        
        // Bottom Button
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_wizardStep == 0) {
                  if (_namaCtrl.text.isEmpty || _daftarPoli == null || _daftarTanggal == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi form terlebih dahulu')));
                    return;
                  }
                  setState(() => _wizardStep = 1);
                } else if (_wizardStep == 1) {
                  if (_selectedScheduleIndex == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih jadwal terlebih dahulu')));
                    return;
                  }
                  setState(() => _wizardStep = 2);
                } else if (_wizardStep == 2) {
                  setState(() => _wizardStep = 3);
                } else {
                  // Selesai -> reset to Cek Antrian
                  setState(() {
                    _selectedMainTab = 0;
                    _wizardStep = 0;
                    _showCekResult = true; // Show result directly to simulate finding it
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _wizardStep == 3 ? 'Selesai' : 'Selanjutnya', 
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIcon(int step, String label) {
    bool isCompleted = _wizardStep > step;
    bool isActive = _wizardStep == step;
    
    Color bgColor = isCompleted || isActive ? const Color(0xFF2979FF) : Colors.white;
    Color borderCol = isCompleted || isActive ? const Color(0xFF2979FF) : const Color(0xFFD1D5DB);
    Color textColor = isCompleted || isActive ? Colors.white : const Color(0xFFD1D5DB);
    Color labelColor = isCompleted || isActive ? const Color(0xFF1A1A1A) : const Color(0xFF9CA3AF);

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderCol),
          ),
          child: Center(
            child: isCompleted 
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text('${step + 1}', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: labelColor)),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 1,
        color: const Color(0xFFE5E7EB),
        margin: const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 14), // push up to align with circles
      ),
    );
  }

  Widget _buildWizardStepContent() {
    switch (_wizardStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pendaftaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 4),
            const Text('Lakukan pendaftaran untuk pilih poli', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
            const SizedBox(height: 24),
            
            const Text('Nama', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 6),
            TextField(
              controller: _namaCtrl,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Masukkan nama',
                hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildDropdown('Pilih Poli', _daftarPoli, _poliList, (val) => setState(() => _daftarPoli = val)),
            const SizedBox(height: 16),
            
            const Text('Pilih Tanggal Daftar', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                setState(() => _daftarTanggal = '1 April 2026'); // Mock date picker
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_daftarTanggal ?? 'Pilih tanggal', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: _daftarTanggal == null ? const Color(0xFF9CA3AF) : const Color(0xFF1A1A1A))),
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF9CA3AF)),
                  ],
                ),
              ),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Jadwal', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 4),
            const Text('Pilih jadwal sesuai kebutuhan Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
            const SizedBox(height: 24),
            
            _buildRadioOption(0, 'Dr. Richard', '08:00 - 12:00'),
            _buildRadioOption(1, 'Dr. Richard', '08:30 - 12:00'),
            _buildRadioOption(2, 'Dr. Richard', '09:00 - 12:00'),
            _buildRadioOption(3, 'Dr. Richard', '09:30 - 12:00'),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Konfirmasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 4),
            const Text('Pastikan data yang Anda masukkan sudah benar', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
            const SizedBox(height: 24),
            
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildConfItem(Icons.person_outline, 'Nama Pasien', _namaCtrl.text.isEmpty ? 'Ahmad Putra' : _namaCtrl.text),
                  const Divider(height: 1),
                  _buildConfItem(Icons.local_hospital_outlined, 'Poli', _daftarPoli ?? 'Umum'),
                  const Divider(height: 1),
                  _buildConfItem(Icons.calendar_today_outlined, 'Tanggal', _daftarTanggal ?? '1 April 2026'),
                  const Divider(height: 1),
                  _buildConfItem(Icons.person_outline, 'Nama Dokter', 'Dr. Richard'),
                  const Divider(height: 1),
                  _buildConfItem(Icons.access_time, 'Jadwal', '08:00 - 12:00'),
                ],
              ),
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            const Text('Pendaftaran Berhasil', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 24),
            const Text('Nomor Antrian Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('A-005', style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            ),
            const SizedBox(height: 24),
            const Text('Perkiraan Dipanggil:', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
            const SizedBox(height: 4),
            const Text('09:00 - 09:30', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildDropdown(String label, String? value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
          decoration: InputDecoration(
            hintText: 'Pilih ${label.toLowerCase().split(' ')[1]}',
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: options.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildRadioOption(int index, String doctor, String time) {
    bool isSelected = _selectedScheduleIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedScheduleIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFD1D5DB), width: 2),
              ),
              child: isSelected
                  ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle)))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(doctor, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF1A1A1A)))),
            Text(time, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          ],
        ),
      ),
    );
  }

  Widget _buildConfItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: const Color(0xFF2979FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
