import 'package:flutter/material.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  String _selectedFilter = 'Semua';

  final List<Map<String, dynamic>> _dummyNotif = [
    {
      'dateGroup': 'HARI INI',
      'title': 'Pembayaran Berhasil',
      'time': '12.05',
      'desc': 'Pembayaran PBB-P2 dengan nomor objek pajak 32.73.010.001.002.0003.0 telah berhasil diproses.',
      'badge': 'Transaksi',
      'badgeColor': const Color(0xFF10B981),
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'dateGroup': 'HARI INI',
      'title': 'Status Laporan Diperbarui',
      'time': '09.35',
      'desc': 'Laporan kerusakan jalan di Jl. Merdeka sedang dalam tahap peninjauan oleh dinas terkait.',
      'badge': 'Laporan',
      'badgeColor': const Color(0xFFEC4899),
      'icon': Icons.campaign_outlined,
    },
    {
      'dateGroup': 'KEMARIN',
      'title': 'Pemeliharaan Sistem',
      'time': '20.12',
      'desc': 'Aplikasi Majadigi akan melakukan pemeliharaan rutin pada pukul 23:00 WIB. Harap simpan pekerjaan Anda.',
      'badge': 'Informasi',
      'badgeColor': const Color(0xFFF59E0B),
      'icon': Icons.info_outline,
    },
    {
      'dateGroup': 'KEMARIN',
      'title': 'Pembayaran Berhasil',
      'time': '10.28',
      'desc': 'Pembayaran PBB-P1 dengan nomor objek pajak 32.73.010.001.002.0001.0 telah berhasil diproses.',
      'badge': 'Transaksi',
      'badgeColor': const Color(0xFF10B981),
      'icon': Icons.account_balance_wallet_outlined,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotif {
    if (_selectedFilter == 'Semua') return _dummyNotif;
    return _dummyNotif.where((n) => n['badge'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                _buildFilterChip('Informasi'),
                _buildFilterChip('Transaksi'),
                _buildFilterChip('Laporan'),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Builder(builder: (context) {
                final filtered = _filteredNotif;
                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: Text('Tidak ada notifikasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
                    ),
                  );
                }

                // Kelompokkan berdasarkan tanggal/hari
                final Map<String, List<Map<String, dynamic>>> grouped = {};
                for (var item in filtered) {
                  grouped.putIfAbsent(item['dateGroup'], () => []).add(item);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...grouped.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(entry.key, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF))),
                          const SizedBox(height: 12),
                          ...entry.value.map((item) => _buildNotifCard(
                            title: item['title'],
                            time: item['time'],
                            desc: item['desc'],
                            badge: item['badge'],
                            badgeColor: item['badgeColor'],
                            icon: item['icon'],
                          )),
                          const SizedBox(height: 12),
                        ],
                      );
                    }),
                    const SizedBox(height: 40),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D6EFD) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard({
    required String title,
    required String time,
    required String desc,
    required String badge,
    required Color badgeColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6B7280), size: 20),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold)),
                    Text(time, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF374151), height: 1.4),
                ),
                const SizedBox(height: 12),
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: badgeColor, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
