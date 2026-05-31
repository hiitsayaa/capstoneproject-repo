import 'package:flutter/material.dart';

class OperasiDaha {
  final String waktu;
  final String namaOperasi;
  final String klinik;
  final String dokter;
  final String status; // 'Sedang Berjalan', 'Terjadwal', 'Dibatalkan'
  final String tanggal;

  OperasiDaha({
    required this.waktu,
    required this.namaOperasi,
    required this.klinik,
    required this.dokter,
    required this.status,
    required this.tanggal,
  });
}

final List<OperasiDaha> mockOperasi = [
  OperasiDaha(
    tanggal: 'Rabu, 1 April 2026',
    waktu: '09.00',
    namaOperasi: 'Amputasi Digiti',
    klinik: 'IGD',
    dokter: 'dr. DEDDY ARYANDA PUTRA, Sp.B. M.Ked.Klin',
    status: 'Sedang Berjalan',
  ),
  OperasiDaha(
    tanggal: 'Rabu, 1 April 2026',
    waktu: '12.00',
    namaOperasi: 'Phaco',
    klinik: 'Klinik Mata',
    dokter: 'dr. DARWAN TRIYONO, Sp.M',
    status: 'Terjadwal',
  ),
  OperasiDaha(
    tanggal: 'Kamis, 2 April 2026',
    waktu: '09.00',
    namaOperasi: 'Amputasi Digiti',
    klinik: 'IGD',
    dokter: 'dr. DEDDY ARYANDA PUTRA, Sp.B. M.Ked.Klin',
    status: 'Dibatalkan',
  ),
  OperasiDaha(
    tanggal: 'Kamis, 2 April 2026',
    waktu: '12.00',
    namaOperasi: 'Phaco',
    klinik: 'Klinik Mata',
    dokter: 'dr. DARWAN TRIYONO, Sp.M',
    status: 'Terjadwal',
  ),
];

class RsudDahaHusadaJadwalOperasiPage extends StatefulWidget {
  const RsudDahaHusadaJadwalOperasiPage({super.key});

  @override
  State<RsudDahaHusadaJadwalOperasiPage> createState() => _RsudDahaHusadaJadwalOperasiPageState();
}

class _RsudDahaHusadaJadwalOperasiPageState extends State<RsudDahaHusadaJadwalOperasiPage> {
  int _selectedTabIndex = 0; // 0 = Semua, 1 = Anda

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const _FilterOperasiModalContent();
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
          'Jadwal Operasi',
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
                    'Terakhir diperbarui: 1 April 2026 10:05:23',
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ringkasan Keseluruhan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildSummaryBox('18', 'Total\nOperasi', const Color(0xFFE3F2FD), const Color(0xFF1976D2)),
                        const SizedBox(width: 12),
                        _buildSummaryBox('3', 'Terjadwal', const Color(0xFFFFEBEE), const Color(0xFFD32F2F)),
                        const SizedBox(width: 12),
                        _buildSummaryBox('15', 'Selesai', const Color(0xFFE8F5E9), const Color(0xFF388E3C)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              TextField(
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Cari operasi',
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
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
                    borderSide: const BorderSide(color: Color(0xFF2979FF)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Daftar Jadwal Operasi Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftar Jadwal Operasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
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
              const SizedBox(height: 16),

              // Tabs
              Row(
                children: [
                  _buildTabItem(0, 'Semua Jadwal Operasi'),
                  const SizedBox(width: 24),
                  _buildTabItem(1, 'Jadwal Operasi Anda'),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 24),

              // List grouped by Tanggal
              _buildJadwalList(),
              
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
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildJadwalList() {
    // Grouping logic for the mock data
    final grouped = <String, List<OperasiDaha>>{};
    for (var op in mockOperasi) {
      if (grouped.containsKey(op.tanggal)) {
        grouped[op.tanggal]!.add(op);
      } else {
        grouped[op.tanggal] = [op];
      }
    }

    return Column(
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                Text('${entry.value.length} Operasi', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
              ],
            ),
            const SizedBox(height: 12),
            // Items
            ...entry.value.map((op) => _buildOperasiCard(op)),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOperasiCard(OperasiDaha op) {
    Color statusColor;
    IconData statusIcon;

    if (op.status == 'Sedang Berjalan') {
      statusColor = const Color(0xFF2979FF);
      statusIcon = Icons.play_arrow_outlined;
    } else if (op.status == 'Terjadwal') {
      statusColor = const Color(0xFFF57C00);
      statusIcon = Icons.access_time;
    } else {
      statusColor = const Color(0xFFE53935);
      statusIcon = Icons.close;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Waktu
          IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Text(
                op.waktu,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
              ),
            ),
          ),
          // Right Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(op.namaOperasi, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(op.klinik, style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Color(0xFF6B7280))),
                  ),
                  const SizedBox(height: 8),
                  Text(op.dokter, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  // Status Badge Outlined
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: statusColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(op.status, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: statusColor)),
                      ],
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
}

// ─────────────────────────────────────────────
// Filter Modal Content
// ─────────────────────────────────────────────
class _FilterOperasiModalContent extends StatefulWidget {
  const _FilterOperasiModalContent();

  @override
  State<_FilterOperasiModalContent> createState() => _FilterOperasiModalContentState();
}

class _FilterOperasiModalContentState extends State<_FilterOperasiModalContent> {
  List<String> _selectedStatus = ['Semua status'];
  final List<String> _statusOptions = ['Semua status', 'Terjadwal', 'Sedang berjalan', 'Selesai', 'Dibatalkan'];

  List<String> _selectedSpesialisasi = ['Semua spesialisasi'];
  final List<String> _spesialisasiOptions = [
    'Semua spesialisasi', 'Klinik Mata', 'Klinik Penyakit Dalam', 'Klinik Kulit Kelamin', 
    'Klinik Bedah', 'Klinik Jantung', 'Klinik Kusta'
  ];

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
                  // Rentang Tanggal
                  const Text('Rentang Tanggal', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Pilih rentang tanggal',
                      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                      suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF9CA3AF), size: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Status Operasi
                  const Text('Status Operasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  const Text('Pilih salah satu atau beberapa status operasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  Column(
                    children: _statusOptions.map((s) {
                      final isSelected = _selectedStatus.contains(s);
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: const Color(0xFFD1D5DB)),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(s, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
                          value: isSelected,
                          activeColor: const Color(0xFF2979FF),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (s == 'Semua status') {
                                  _selectedStatus = ['Semua status'];
                                } else {
                                  _selectedStatus.remove('Semua status');
                                  _selectedStatus.add(s);
                                }
                              } else {
                                _selectedStatus.remove(s);
                                if (_selectedStatus.isEmpty) {
                                  _selectedStatus = ['Semua status'];
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

                  // Spesialisasi
                  const Text('Spesialisasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  const Text('Pilih salah satu atau beberapa spesialisasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  Column(
                    children: _spesialisasiOptions.map((s) {
                      final isSelected = _selectedSpesialisasi.contains(s);
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: const Color(0xFFD1D5DB)),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(s, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
                          value: isSelected,
                          activeColor: const Color(0xFF2979FF),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (s == 'Semua spesialisasi') {
                                  _selectedSpesialisasi = ['Semua spesialisasi'];
                                } else {
                                  _selectedSpesialisasi.remove('Semua spesialisasi');
                                  _selectedSpesialisasi.add(s);
                                }
                              } else {
                                _selectedSpesialisasi.remove(s);
                                if (_selectedSpesialisasi.isEmpty) {
                                  _selectedSpesialisasi = ['Semua spesialisasi'];
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
                    onPressed: () {
                      setState(() {
                        _selectedStatus = ['Semua status'];
                        _selectedSpesialisasi = ['Semua spesialisasi'];
                      });
                    },
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
