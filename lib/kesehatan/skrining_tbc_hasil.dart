import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/kesehatan/skrining_tbc_detail_faskes.dart';

// ─────────────────────────────────────────────
// Faskes Data
// ─────────────────────────────────────────────

class FaskesData {
  final String nama;
  final String tipe; // 'Puskesmas', 'Klinik', 'Rumah Sakit', 'Dokter Praktik'
  final String kota;
  final String alamat;
  final String telepon;

  const FaskesData({
    required this.nama,
    required this.tipe,
    required this.kota,
    required this.alamat,
    required this.telepon,
  });
}

final List<FaskesData> daftarFaskes = [
  const FaskesData(nama: 'Puskesmas Kedungkandang', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. Kimpulan Ulu Sucipto 45 Malang 65134', telepon: '0341-4056178'),
  const FaskesData(nama: 'Puskesmas Arjuno', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. Simpang Arjuno No. 22 Malang', telepon: '0341-362813'),
  const FaskesData(nama: 'Puskesmas Kendalsari', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. Candi Panggung No. 8 Malang', telepon: '0341-551296'),
  const FaskesData(nama: 'Puskesmas Dinoyo', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. MT Haryono IX No. 149 Malang', telepon: '0341-561823'),
  const FaskesData(nama: 'Puskesmas Janti', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. Janti Barat No. 35 Malang', telepon: '0341-801256'),
  const FaskesData(nama: 'Klinik Pratama Husada', tipe: 'Klinik', kota: 'Kota Malang', alamat: 'Jl. Soekarno-Hatta No. 10 Malang', telepon: '0341-710823'),
  const FaskesData(nama: 'Klinik Sehat Medika', tipe: 'Klinik', kota: 'Kota Malang', alamat: 'Jl. Ijen No. 55 Malang', telepon: '0341-445712'),
  const FaskesData(nama: 'RSU Saiful Anwar', tipe: 'Rumah Sakit', kota: 'Kota Malang', alamat: 'Jl. Jaksa Agung Suprapto No.2 Malang', telepon: '0341-362101'),
  const FaskesData(nama: 'RS Lavalette', tipe: 'Rumah Sakit', kota: 'Kota Malang', alamat: 'Jl. WR. Supratman No. 10 Malang', telepon: '0341-350233'),
  const FaskesData(nama: 'Dokter Praktik dr. Susanto', tipe: 'Dokter Praktik', kota: 'Kota Malang', alamat: 'Jl. Veteran No. 12 Malang', telepon: '0341-823461'),
  const FaskesData(nama: 'Puskesmas Cisadea', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. Kebalen Wetan No. 2 Malang', telepon: '0341-367903'),
  const FaskesData(nama: 'Puskesmas Pandanwangi', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. L.A Sucipto Gg 18 Malang', telepon: '0341-718623'),
  const FaskesData(nama: 'Puskesmas Mulyorejo', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. Raya Mulyorejo Malang', telepon: '0341-801945'),
  const FaskesData(nama: 'Puskesmas Ciptomulyo', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. S. Supriadi No.140 Malang', telepon: '0341-803715'),
  const FaskesData(nama: 'Puskesmas Rampal Celaket', tipe: 'Puskesmas', kota: 'Kota Malang', alamat: 'Jl. Simpang Panji Suroso 30 Malang', telepon: '0341-491703'),
];

// ─────────────────────────────────────────────
// Hasil Skrining Page
// ─────────────────────────────────────────────

class SkriningTbcHasilPage extends StatefulWidget {
  final bool terindikasi;
  final String namaLengkap;
  final DateTime waktuSkrining;

  const SkriningTbcHasilPage({
    super.key,
    required this.terindikasi,
    required this.namaLengkap,
    required this.waktuSkrining,
  });

  @override
  State<SkriningTbcHasilPage> createState() => _SkriningTbcHasilPageState();
}

class _SkriningTbcHasilPageState extends State<SkriningTbcHasilPage> {
  String _searchFaskes = '';
  String _selectedTipe = 'Semua Tipe';

  final List<String> _tipeOptions = ['Semua Tipe', 'Puskesmas', 'Klinik', 'Rumah Sakit', 'Dokter Praktik'];

  List<FaskesData> get _filteredFaskes {
    return daftarFaskes.where((f) {
      if (_selectedTipe != 'Semua Tipe' && f.tipe != _selectedTipe) return false;
      if (_searchFaskes.isNotEmpty && !f.nama.toLowerCase().contains(_searchFaskes.toLowerCase())) return false;
      return true;
    }).toList();
  }

  void _showPilihFaskesDialog(FaskesData faskes) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Pilih Faskes',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Anda yakin ingin memilih faskes ini?',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SkriningTbcDetailFaskesPage(
                          faskes: faskes,
                          namaLengkap: widget.namaLengkap,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Ya, lanjutkan', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy (HH.mm)', 'id_ID');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Hasil Skrining', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Result illustration + message
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  // Illustration placeholder
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: widget.terindikasi ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Icon(
                      widget.terindikasi ? Icons.warning_amber_rounded : Icons.verified_user,
                      size: 80,
                      color: widget.terindikasi ? const Color(0xFFFF8F00) : const Color(0xFF43A047),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Result message
                  Text(
                    widget.terindikasi
                        ? 'Yuk segera periksakan diri ke Puskesmas / Faskes terdekat, kemungkinan ada bakteri TBC di tubuh anda.'
                        : 'Anda tidak menunjukkan gejala TBC. Tetap waspada, dan periksa diri bila ada keluhan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.terindikasi ? const Color(0xFFE65100) : const Color(0xFF1A1A1A),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.terindikasi
                        ? 'Segera periksakan diri ke Puskesmas atau fasilitas kesehatan terdekat untuk deteksi dini TBC.'
                        : 'Kunjungi Puskesmas atau fasilitas kesehatan terdekat untuk memastikan kemungkinan adanya penyakit lain.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Nama Lengkap', widget.namaLengkap),
                        const SizedBox(height: 8),
                        _buildInfoRow('Waktu Skrining', dateFormat.format(widget.waktuSkrining)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Selesai button (for non-terindikasi) or Faskes section
            if (!widget.terindikasi) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Selesai', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  ),
                ),
              ),
            ],

            if (widget.terindikasi) ...[
              // Pilih Faskes Terdekat Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pilih Faskes Terdekat', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 12),

                    // Search
                    TextField(
                      onChanged: (v) => setState(() => _searchFaskes = v),
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari nama faskes...',
                        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                        prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF00897B))),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter chips
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tipeOptions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final tipe = _tipeOptions[index];
                          final isSelected = _selectedTipe == tipe;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedTipe = tipe),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF00897B) : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: isSelected ? const Color(0xFF00897B) : const Color(0xFFE5E7EB)),
                              ),
                              child: Text(
                                tipe,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Reset filter
                    if (_selectedTipe != 'Semua Tipe' || _searchFaskes.isNotEmpty)
                      Center(
                        child: TextButton(
                          onPressed: () => setState(() {
                            _selectedTipe = 'Semua Tipe';
                            _searchFaskes = '';
                          }),
                          child: const Text('Reset Filter', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFEF4444))),
                        ),
                      ),

                    const SizedBox(height: 4),
                    Text(
                      'Ditemukan ${_filteredFaskes.length} faskes',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 12),

                    // Faskes list
                    ..._filteredFaskes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final faskes = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              // Number
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00897B)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      faskes.nama,
                                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(faskes.tipe, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9CA3AF))),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.location_on, size: 10, color: Color(0xFF9CA3AF)),
                                        const SizedBox(width: 2),
                                        Text(faskes.kota, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9CA3AF))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () => _showPilihFaskesDialog(faskes),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  child: const Text('Pilih Faskes ❯', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    if (_filteredFaskes.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            Icon(Icons.search_off, size: 40, color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            const Text('Tidak ada faskes ditemukan', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9CA3AF))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
        const Text(' : ', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
        Expanded(
          child: Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
        ),
      ],
    );
  }
}
