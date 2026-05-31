import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/kesehatan/rsud_haji_detail_kamar.dart';

// ─────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────

class KamarData {
  final String nama;
  final String kategoriMedis; // 'Isolasi', 'Intensif', 'Reguler'
  final String kelas; // 'Kelas I', 'Kelas II', 'Kelas III', 'VIP', 'VVIP'
  final String jenisKelamin; // 'Laki-laki', 'Perempuan', 'Campuran'
  final int kapasitas;
  final int terisi;
  final String tarif;
  final List<String> fasilitas;

  const KamarData({
    required this.nama,
    required this.kategoriMedis,
    required this.kelas,
    required this.jenisKelamin,
    required this.kapasitas,
    required this.terisi,
    required this.tarif,
    required this.fasilitas,
  });

  int get tersedia => kapasitas - terisi;

  String get statusKetersediaan {
    if (tersedia == 0) return 'Penuh';
    if (tersedia <= 2) return 'Terbatas';
    return 'Tersedia';
  }
}

// ─────────────────────────────────────────────
// Sample Data
// ─────────────────────────────────────────────

final List<KamarData> daftarKamar = [
  KamarData(
    nama: 'AMARILIS A',
    kategoriMedis: 'Isolasi',
    kelas: 'Kelas I',
    jenisKelamin: 'Perempuan',
    kapasitas: 6,
    terisi: 1,
    tarif: 'Rp 500.000/malam',
    fasilitas: [
      '2 Tempat Tidur',
      '1 TV LED 24 inci',
      '1 Kamar Mandi/WC',
      '1 Pendingin Ruangan (AC)',
      '1 Toilet Duduk & Shower',
    ],
  ),
  KamarData(
    nama: 'DAHLIA B',
    kategoriMedis: 'Intensif',
    kelas: 'Kelas II',
    jenisKelamin: 'Laki-laki',
    kapasitas: 6,
    terisi: 1,
    tarif: 'Rp 350.000/malam',
    fasilitas: [
      '2 Tempat Tidur',
      '1 TV LED 24 inci',
      '1 Pendingin Ruangan (AC)',
      '1 Toilet Duduk & Shower',
    ],
  ),
  KamarData(
    nama: 'EDELWEIS',
    kategoriMedis: 'Reguler',
    kelas: 'Kelas III',
    jenisKelamin: 'Campuran',
    kapasitas: 6,
    terisi: 1,
    tarif: 'Rp 200.000/malam',
    fasilitas: [
      '3 Tempat Tidur',
      '1 Pendingin Ruangan (AC)',
      '1 Toilet Duduk',
    ],
  ),
  KamarData(
    nama: 'MAWAR VIP',
    kategoriMedis: 'Reguler',
    kelas: 'VIP',
    jenisKelamin: 'Laki-laki',
    kapasitas: 4,
    terisi: 4,
    tarif: 'Rp 750.000/malam',
    fasilitas: [
      '1 Tempat Tidur',
      '1 TV LED 32 inci',
      '1 Sofa Panjang',
      '1 Pendingin Ruangan (AC)',
      '1 Toilet Duduk & Shower',
      '1 Kulkas Mini',
    ],
  ),
  KamarData(
    nama: 'MELATI VVIP',
    kategoriMedis: 'Reguler',
    kelas: 'VVIP',
    jenisKelamin: 'Perempuan',
    kapasitas: 2,
    terisi: 1,
    tarif: 'Rp 1.500.000/malam',
    fasilitas: [
      '1 Tempat Tidur Premium',
      '1 TV LED 43 inci',
      '1 Sofa Panjang',
      '2 Pendingin Ruangan (AC)',
      '1 Toilet Duduk & Shower',
      '1 Kulkas Mini',
      '1 Meja Makan',
    ],
  ),
  KamarData(
    nama: 'ANGGREK C',
    kategoriMedis: 'Isolasi',
    kelas: 'Kelas I',
    jenisKelamin: 'Laki-laki',
    kapasitas: 4,
    terisi: 2,
    tarif: 'Rp 500.000/malam',
    fasilitas: [
      '2 Tempat Tidur',
      '1 TV LED 24 inci',
      '1 Pendingin Ruangan (AC)',
      '1 Toilet Duduk & Shower',
    ],
  ),
  KamarData(
    nama: 'KENANGA D',
    kategoriMedis: 'Intensif',
    kelas: 'Kelas II',
    jenisKelamin: 'Perempuan',
    kapasitas: 8,
    terisi: 7,
    tarif: 'Rp 350.000/malam',
    fasilitas: [
      '4 Tempat Tidur',
      '1 TV LED 24 inci',
      '1 Pendingin Ruangan (AC)',
      '2 Toilet Duduk',
    ],
  ),
  KamarData(
    nama: 'FLAMBOYAN E',
    kategoriMedis: 'Reguler',
    kelas: 'Kelas III',
    jenisKelamin: 'Campuran',
    kapasitas: 10,
    terisi: 5,
    tarif: 'Rp 200.000/malam',
    fasilitas: [
      '5 Tempat Tidur',
      '2 Pendingin Ruangan (AC)',
      '2 Toilet Duduk',
    ],
  ),
];

// ─────────────────────────────────────────────
// Filter State
// ─────────────────────────────────────────────

class FilterState {
  String jenisKelamin; // 'Semua', 'Laki-laki', 'Perempuan'
  String kategoriMedis; // 'Semua kategori', 'Isolasi', 'Intensif', 'Reguler'
  String kelasRuangan; // 'Semua kelas', 'Kelas I', 'Kelas II', 'Kelas III', 'VIP', 'VVIP'

  FilterState({
    this.jenisKelamin = 'Semua',
    this.kategoriMedis = 'Semua kategori',
    this.kelasRuangan = 'Semua kelas',
  });

  FilterState copy() => FilterState(
    jenisKelamin: jenisKelamin,
    kategoriMedis: kategoriMedis,
    kelasRuangan: kelasRuangan,
  );

  bool get isActive =>
      jenisKelamin != 'Semua' ||
      kategoriMedis != 'Semua kategori' ||
      kelasRuangan != 'Semua kelas';

  void reset() {
    jenisKelamin = 'Semua';
    kategoriMedis = 'Semua kategori';
    kelasRuangan = 'Semua kelas';
  }

  int get activeFilterCount {
    int count = 0;
    if (jenisKelamin != 'Semua') count++;
    if (kategoriMedis != 'Semua kategori') count++;
    if (kelasRuangan != 'Semua kelas') count++;
    return count;
  }
}

// ─────────────────────────────────────────────
// Main Page
// ─────────────────────────────────────────────

class RsudHajiKetersediaanKamarPage extends StatefulWidget {
  const RsudHajiKetersediaanKamarPage({super.key});

  @override
  State<RsudHajiKetersediaanKamarPage> createState() =>
      _RsudHajiKetersediaanKamarPageState();
}

class _RsudHajiKetersediaanKamarPageState
    extends State<RsudHajiKetersediaanKamarPage> {
  final FilterState _filter = FilterState();
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();
    _lastUpdated = DateTime.now();
  }

  List<KamarData> get _filteredKamar {
    return daftarKamar.where((kamar) {
      if (_filter.jenisKelamin != 'Semua' &&
          kamar.jenisKelamin != _filter.jenisKelamin) {
        return false;
      }
      if (_filter.kategoriMedis != 'Semua kategori' &&
          kamar.kategoriMedis != _filter.kategoriMedis) {
        return false;
      }
      if (_filter.kelasRuangan != 'Semua kelas' &&
          kamar.kelas != _filter.kelasRuangan) {
        return false;
      }
      return true;
    }).toList();
  }

  int get _totalKapasitas => _filteredKamar.fold(0, (sum, k) => sum + k.kapasitas);
  int get _totalTerisi => _filteredKamar.fold(0, (sum, k) => sum + k.terisi);
  int get _totalTersedia => _filteredKamar.fold(0, (sum, k) => sum + k.tersedia);

  void _refresh() {
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }

  void _showFilterDialog() async {
    final tempFilter = _filter.copy();

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(filter: tempFilter),
    );

    if (result == true) {
      setState(() {
        _filter.jenisKelamin = tempFilter.jenisKelamin;
        _filter.kategoriMedis = tempFilter.kategoriMedis;
        _filter.kelasRuangan = tempFilter.kelasRuangan;
      });
    }
  }

  void _showResetFilterConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Reset Filter',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah Anda ingin mereset semua filter?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _filter.reset());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
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
    final filteredList = _filteredKamar;
    final dateFormat = DateFormat('dd MMMM yyyy HH:mm:ss', 'id_ID');

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last updated
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Terakhir diperbarui: ${dateFormat.format(_lastUpdated)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _refresh,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.refresh,
                            size: 14,
                            color: Color(0xFF43A047),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Refresh',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF43A047),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Summary Card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ringkasan Keseluruhan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildSummaryItem(
                          value: _totalKapasitas.toString(),
                          label: 'Kapasitas',
                          color: const Color(0xFF2979FF),
                          bgColor: const Color(0xFFE3F2FD),
                        ),
                        const SizedBox(width: 12),
                        _buildSummaryItem(
                          value: _totalTerisi.toString(),
                          label: 'Terisi',
                          color: const Color(0xFFEF4444),
                          bgColor: const Color(0xFFFEE2E2),
                        ),
                        const SizedBox(width: 12),
                        _buildSummaryItem(
                          value: _totalTersedia.toString(),
                          label: 'Tersedia',
                          color: const Color(0xFF43A047),
                          bgColor: const Color(0xFFE8F5E9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Daftar Kamar header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Kamar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              _filter.isActive
                                  ? const Color(0xFF43A047)
                                  : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tune,
                            size: 14,
                            color:
                                _filter.isActive
                                    ? const Color(0xFF43A047)
                                    : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tampilkan Filter',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color:
                                  _filter.isActive
                                      ? const Color(0xFF43A047)
                                      : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips (shown when filter is active)
            if (_filter.isActive)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showFilterDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF43A047).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.tune,
                              size: 12,
                              color: Color(0xFF43A047),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ubah filter',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF43A047),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _showResetFilterConfirmation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.close,
                              size: 12,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Reset filter',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Kamar list
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  ...filteredList.map(
                    (kamar) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildKamarCard(kamar),
                    ),
                  ),
                  if (filteredList.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak ada kamar yang sesuai filter',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Footer info
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Menampilkan ${filteredList.length} dari ${daftarKamar.length} kamar',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),

            // FAB spacer
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        backgroundColor: const Color(0xFF2979FF),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKamarCard(KamarData kamar) {
    Color statusColor;
    Color statusBgColor;
    switch (kamar.statusKetersediaan) {
      case 'Tersedia':
        statusColor = const Color(0xFF43A047);
        statusBgColor = const Color(0xFFE8F5E9);
        break;
      case 'Terbatas':
        statusColor = const Color(0xFFFF8F00);
        statusBgColor = const Color(0xFFFFF8E1);
        break;
      default:
        statusColor = const Color(0xFFEF4444);
        statusBgColor = const Color(0xFFFEE2E2);
    }

    Color kategoriColor;
    switch (kamar.kategoriMedis) {
      case 'Isolasi':
        kategoriColor = const Color(0xFF7B1FA2);
        break;
      case 'Intensif':
        kategoriColor = const Color(0xFFEF4444);
        break;
      default:
        kategoriColor = const Color(0xFF2979FF);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RsudHajiDetailKamarPage(kamar: kamar),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: name + badges
            Row(
              children: [
                Expanded(
                  child: Text(
                    kamar.nama,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: kategoriColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    kamar.kategoriMedis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: kategoriColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    kamar.statusKetersediaan,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Sub-info: kelas + jenis kelamin
            Text(
              '${kamar.kelas}  •  ${kamar.jenisKelamin}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 12),
            // Stats row
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        kamar.kapasitas.toString(),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Text(
                        'Kapasitas',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        kamar.terisi.toString(),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Text(
                        'Terisi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        kamar.tersedia.toString(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const Text(
                        'Tersedia',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFD1D5DB),
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter Bottom Sheet
// ─────────────────────────────────────────────

class _FilterBottomSheet extends StatefulWidget {
  final FilterState filter;

  const _FilterBottomSheet({required this.filter});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late FilterState _tempFilter;

  @override
  void initState() {
    super.initState();
    _tempFilter = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFFF3F4F6)),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis Kelamin
                  _buildFilterSection(
                    title: 'Jenis Kelamin',
                    subtitle: 'Pilih berdasarkan jenis kelamin pasien',
                    options: ['Semua', 'Laki-laki', 'Perempuan'],
                    selected: _tempFilter.jenisKelamin,
                    onChanged: (v) => setState(
                      () => _tempFilter.jenisKelamin = v,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kategori Medis
                  _buildFilterSection(
                    title: 'Kategori Medis',
                    subtitle:
                        'Pilih sesuai satu, atau beberapa kategori medis',
                    options: [
                      'Semua kategori',
                      'Isolasi',
                      'Intensif',
                      'Reguler',
                    ],
                    selected: _tempFilter.kategoriMedis,
                    onChanged: (v) => setState(
                      () => _tempFilter.kategoriMedis = v,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kelas Ruangan
                  _buildFilterSection(
                    title: 'Kelas Ruangan',
                    subtitle:
                        'Pilih sesuai satu, atau beberapa kelas kapernya',
                    options: [
                      'Semua kelas',
                      'Kelas I',
                      'Kelas II',
                      'Kelas III',
                      'VIP',
                      'VVIP',
                    ],
                    selected: _tempFilter.kelasRuangan,
                    onChanged: (v) => setState(
                      () => _tempFilter.kelasRuangan = v,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _tempFilter.reset());
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.filter.jenisKelamin =
                            _tempFilter.jenisKelamin;
                        widget.filter.kategoriMedis =
                            _tempFilter.kategoriMedis;
                        widget.filter.kelasRuangan =
                            _tempFilter.kelasRuangan;
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF43A047),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Terapkan Filter',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required String subtitle,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? const Color(0xFF43A047)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected
                            ? const Color(0xFF43A047)
                            : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
