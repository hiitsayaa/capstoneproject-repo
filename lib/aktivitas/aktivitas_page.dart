import 'package:flutter/material.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // TabController untuk mengelola tab "Dalam Proses" dan "Selesai"
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        elevation: 0,
        title: const Text(
          'Aktivitas',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Segmented Control / Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: const Color(0xFF0D6EFD),
                unselectedLabelColor: const Color(0xFF9CA3AF),
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Dalam Proses'),
                  Tab(text: 'Selesai'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab: Dalam Proses
                _buildEmptyState('Belum ada aktivitas yang sedang diproses.'),
                // Tab: Selesai
                _buildSelesaiList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelesaiList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        _buildActivityCard(
          icon: Icons.payments_outlined,
          iconBgColor: const Color(0xFFE0E7FF),
          iconColor: const Color(0xFF0D6EFD),
          title: 'Pembayaran PBB-P2 Berhasil',
          date: '24 Okt 2023',
          time: '10:30 WIB',
          status: 'Selesai',
          infoLabel: 'No. Tagihan',
          infoValue: '327310000214',
        ),
        const SizedBox(height: 16),
        _buildActivityCard(
          icon: Icons.health_and_safety_outlined,
          iconBgColor: const Color(0xFFFFE0B2),
          iconColor: const Color(0xFFE65100),
          title: 'Skrining E-Tibi Selesai',
          date: '22 Okt 2023',
          time: '14:15 WIB',
          status: 'Selesai',
          infoLabel: '',
          infoValue: 'Hasil telah dikirim ke Email',
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String date,
    required String time,
    required String status,
    required String infoLabel,
    required String infoValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$date • $time',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5), // Light green background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF059669), size: 12),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    infoLabel.isNotEmpty ? '$infoLabel: $infoValue' : infoValue,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Aksi ketika tombol detail diklik
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF0D6EFD), // Typical Majadigi blue
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 16, color: Color(0xFF0D6EFD)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
