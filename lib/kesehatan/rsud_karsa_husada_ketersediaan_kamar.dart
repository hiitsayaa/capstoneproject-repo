import 'package:flutter/material.dart';
import 'package:flutter_application_1/kesehatan/rsud_karsa_husada_detail_kamar.dart';

class KamarRawatKarsa {
  final String nama;
  final String kategori; // Isolasi, Intensif, Reguler
  final String status; // Tersedia, Terbatas, Penuh
  final String kelas;
  final String jenisKelamin; // Laki-laki, Perempuan
  final int kapasitas;
  final int terisi;
  final int tersedia;

  KamarRawatKarsa({
    required this.nama,
    required this.kategori,
    required this.status,
    required this.kelas,
    required this.jenisKelamin,
    required this.kapasitas,
    required this.terisi,
    required this.tersedia,
  });
}

final List<KamarRawatKarsa> mockKamarKarsa = [
  KamarRawatKarsa(nama: 'AMARILIS A', kategori: 'Isolasi', status: 'Tersedia', kelas: 'Kelas I', jenisKelamin: 'Perempuan', kapasitas: 6, terisi: 1, tersedia: 5),
  KamarRawatKarsa(nama: 'CVCU', kategori: 'Intensif', status: 'Tersedia', kelas: 'Kelas I', jenisKelamin: 'Laki-laki', kapasitas: 6, terisi: 1, tersedia: 5),
  KamarRawatKarsa(nama: 'EDELWEIS', kategori: 'Isolasi', status: 'Terbatas', kelas: 'Kelas I', jenisKelamin: 'Perempuan', kapasitas: 6, terisi: 1, tersedia: 5),
];

class RsudKarsaHusadaKetersediaanKamarPage extends StatefulWidget {
  const RsudKarsaHusadaKetersediaanKamarPage({super.key});

  @override
  State<RsudKarsaHusadaKetersediaanKamarPage> createState() => _RsudKarsaHusadaKetersediaanKamarPageState();
}

class _RsudKarsaHusadaKetersediaanKamarPageState extends State<RsudKarsaHusadaKetersediaanKamarPage> {
  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const _FilterModalContent();
      },
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
          'Ketersediaan Kamar Rawat',
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timestamp and Refresh
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Terakhir diperbarui: 20 Maret 2026 10:05:23',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280)),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 14, color: Color(0xFF2979FF)),
                    label: const Text('Refresh', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2979FF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      minimumSize: const Size(0, 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Ringkasan Keseluruhan
              const Text('Ringkasan Keseluruhan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildSummaryBox('18', 'Kapasitas', const Color(0xFFE3F2FD), const Color(0xFF1976D2)),
                  const SizedBox(width: 12),
                  _buildSummaryBox('3', 'Terisi', const Color(0xFFFFEBEE), const Color(0xFFD32F2F)),
                  const SizedBox(width: 12),
                  _buildSummaryBox('15', 'Tersedia', const Color(0xFFE8F5E9), const Color(0xFF388E3C)),
                ],
              ),
              const SizedBox(height: 32),

              // Daftar Kamar Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftar Kamar', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  OutlinedButton.icon(
                    onPressed: _showFilterModal,
                    icon: const Icon(Icons.tune, size: 14, color: Color(0xFF2979FF)),
                    label: const Text('Tambahkan filter', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2979FF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List of Rooms
              ...mockKamarKarsa.map((kamar) => _buildRoomCard(kamar)),
              
              const SizedBox(height: 16),
              // Pagination Placeholder
              const Center(
                child: Text('Menampilkan 1-3 dari 3 hasil', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String count, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(KamarRawatKarsa kamar) {
    Color badgeColor;
    Color badgeBg;
    Color statusColor;
    Color statusBg;

    // Set badge style
    if (kamar.kategori == 'Isolasi') {
      badgeColor = const Color(0xFF1E88E5);
      badgeBg = const Color(0xFFE3F2FD);
    } else if (kamar.kategori == 'Intensif') {
      badgeColor = const Color(0xFFE53935);
      badgeBg = const Color(0xFFFFEBEE);
    } else {
      badgeColor = const Color(0xFF43A047);
      badgeBg = const Color(0xFFE8F5E9);
    }

    // Set status style
    if (kamar.status == 'Tersedia') {
      statusColor = const Color(0xFF43A047);
      statusBg = const Color(0xFFF1F8E9);
    } else if (kamar.status == 'Terbatas') {
      statusColor = const Color(0xFFF57C00);
      statusBg = const Color(0xFFFFF3E0);
    } else {
      statusColor = const Color(0xFFE53935);
      statusBg = const Color(0xFFFFEBEE);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RsudKarsaHusadaDetailKamarPage(kamar: kamar),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(kamar.nama, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)),
                        child: Text(kamar.kategori, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: badgeColor)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                        child: Text(kamar.status, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: statusColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${kamar.kelas} • ${kamar.jenisKelamin}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatItem(kamar.kapasitas.toString(), 'Kapasitas'),
                      Container(width: 1, height: 30, color: const Color(0xFFE5E7EB), margin: const EdgeInsets.symmetric(horizontal: 16)),
                      _buildStatItem(kamar.terisi.toString(), 'Terisi'),
                      Container(width: 1, height: 30, color: const Color(0xFFE5E7EB), margin: const EdgeInsets.symmetric(horizontal: 16)),
                      _buildStatItem(kamar.tersedia.toString(), 'Tersedia'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Filter Modal Content
// ─────────────────────────────────────────────
class _FilterModalContent extends StatefulWidget {
  const _FilterModalContent();

  @override
  State<_FilterModalContent> createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<_FilterModalContent> {
  String _selectedGender = 'Semua';
  final List<String> _genders = ['Semua', 'Laki-laki', 'Perempuan'];

  List<String> _selectedMedis = ['Semua kategori'];
  final List<String> _medisOptions = ['Semua kategori', 'Isolasi', 'Intensif', 'Reguler'];

  List<String> _selectedKelas = ['Semua kelas'];
  final List<String> _kelasOptions = ['Semua kelas', 'Kelas I', 'Kelas II', 'VIP', 'VVIP'];

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Filter', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda ingin mereset semua filter?', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280))),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2979FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedGender = 'Semua';
                      _selectedMedis = ['Semua kategori'];
                      _selectedKelas = ['Semua kelas'];
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Reset', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24), // balance
                const Text(
                  'Filter',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis Kelamin
                  const Text('Jenis Kelamin', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  const Text('Pilih jenis kelamin pasien', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  Row(
                    children: _genders.map((g) {
                      final isSelected = g == _selectedGender;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGender = g),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFD1D5DB)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              g,
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: isSelected ? const Color(0xFF2979FF) : const Color(0xFF1A1A1A)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Kategori Medis
                  const Text('Kategori Medis', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  const Text('Pilih salah satu atau beberapa kategori medis', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  Column(
                    children: _medisOptions.map((m) {
                      final isSelected = _selectedMedis.contains(m);
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: const Color(0xFFD1D5DB)),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(m, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
                          value: isSelected,
                          activeColor: const Color(0xFF2979FF),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (m == 'Semua kategori') {
                                  _selectedMedis = ['Semua kategori'];
                                } else {
                                  _selectedMedis.remove('Semua kategori');
                                  _selectedMedis.add(m);
                                }
                              } else {
                                _selectedMedis.remove(m);
                                if (_selectedMedis.isEmpty) {
                                  _selectedMedis = ['Semua kategori'];
                                }
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Kelas Ruangan
                  const Text('Kelas Ruangan', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  const Text('Pilih salah satu atau beberapa kelas', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  Column(
                    children: _kelasOptions.map((k) {
                      final isSelected = _selectedKelas.contains(k);
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: const Color(0xFFD1D5DB)),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(k, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
                          value: isSelected,
                          activeColor: const Color(0xFF2979FF),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (k == 'Semua kelas') {
                                  _selectedKelas = ['Semua kelas'];
                                } else {
                                  _selectedKelas.remove('Semua kelas');
                                  _selectedKelas.add(k);
                                }
                              } else {
                                _selectedKelas.remove(k);
                                if (_selectedKelas.isEmpty) {
                                  _selectedKelas = ['Semua kelas'];
                                }
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _showResetDialog,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2979FF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Reset', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Terapkan Filter', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
