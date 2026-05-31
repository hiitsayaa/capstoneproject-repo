import 'package:flutter/material.dart';
import 'package:flutter_application_1/hoaks/semua_berita_hoaks.dart';
import 'package:flutter_application_1/hoaks/laporan_hoaks.dart';
import 'package:flutter_application_1/hoaks/lacak_tiket.dart';

// Data model untuk berita hoaks
class BeritaHoaksItem {
  final String title;
  final String category;
  final String tag; // 'Hoaks', 'Fakta', 'Disinformasi', 'Hate Speech'
  final String date;
  final String? imageAsset;

  const BeritaHoaksItem({
    required this.title,
    required this.category,
    required this.tag,
    required this.date,
    this.imageAsset,
  });
}

// Sample data berita hoaks
const List<BeritaHoaksItem> daftarBeritaHoaks = [
  BeritaHoaksItem(
    title: 'Spanyol Deluar Dari Nato Usai AS Serang Iran',
    category: 'Geopolitik',
    tag: 'Hoaks',
    date: '05 Apr 2026',
  ),
  BeritaHoaksItem(
    title: 'Prabowo Siap Hentikan Program MBG',
    category: 'Pendidikan',
    tag: 'Hoaks',
    date: '02 Apr 2026',
  ),
  BeritaHoaksItem(
    title: 'Kebijakan WFH 1 Hari Dalam Seminggu Mulai 1 April 2026',
    category: 'Karier',
    tag: 'Fakta',
    date: '01 Apr 2026',
  ),
  BeritaHoaksItem(
    title: 'Vaksin COVID-19 Mengandung Microchip Pelacak',
    category: 'Kesehatan',
    tag: 'Hoaks',
    date: '28 Mar 2026',
  ),
  BeritaHoaksItem(
    title: 'Pemerintah Gratiskan Listrik Untuk Seluruh Warga',
    category: 'Ekonomi',
    tag: 'Disinformasi',
    date: '25 Mar 2026',
  ),
  BeritaHoaksItem(
    title: 'Data Pribadi Jutaan Warga Bocor di Dark Web',
    category: 'Teknologi',
    tag: 'Fakta',
    date: '22 Mar 2026',
  ),
  BeritaHoaksItem(
    title: 'Harga BBM Naik 200% Mulai Bulan Depan',
    category: 'Ekonomi',
    tag: 'Hoaks',
    date: '20 Mar 2026',
  ),
  BeritaHoaksItem(
    title: 'Aplikasi X Mencuri Data Pengguna Tanpa Izin',
    category: 'Teknologi',
    tag: 'Disinformasi',
    date: '18 Mar 2026',
  ),
];

class HalamanKlinikHoaks extends StatelessWidget {
  const HalamanKlinikHoaks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Klinik Hoaks',
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ─── Ringkasan Layanan ───
            const Text(
              'Ringkasan Layanan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 14),

            // Stat Cards Grid (2x2)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    value: '420',
                    label: 'Berita Hoaks',
                    description:
                        'Konten rekayasa atau palsu untuk provokasi dan menyesatkan opini publik.',
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFE53935),
                    bgColor: const Color(0xFFFFEBEE),
                    valueColor: const Color(0xFF2979FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    value: '28',
                    label: 'Disinformasi',
                    description:
                        'Informasi salah yang sengaja disebarkan untuk menyesatkan pembaca.',
                    icon: Icons.campaign_outlined,
                    iconColor: const Color(0xFFFF6F00),
                    bgColor: const Color(0xFFFFF3E0),
                    valueColor: const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    value: '24',
                    label: 'Fakta',
                    description:
                        'Informasi benar sesuai data atau bukti.',
                    icon: Icons.fact_check_outlined,
                    iconColor: const Color(0xFF43A047),
                    bgColor: const Color(0xFFE8F5E9),
                    valueColor: const Color(0xFF2979FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    value: '0',
                    label: 'Hate Speech',
                    description:
                        'Ujaran bernada kebencian yang menyerang individu atau kelompok.',
                    icon: Icons.headphones_outlined,
                    iconColor: const Color(0xFF7B1FA2),
                    bgColor: const Color(0xFFF3E5F5),
                    valueColor: const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ─── Program Layanan ───
            const Text(
              'Program Layanan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 14),

            // Laporan Hoaks
            _buildProgramItem(
              icon: Icons.report_outlined,
              iconBgColor: const Color(0xFFE3F2FD),
              iconColor: const Color(0xFF1565C0),
              title: 'Laporan Hoaks',
              subtitle:
                  'Kirim info yang kamu temukan, Kami bantu klarifikasi 1x24 jam.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LaporanHoaksPage()),
                );
              },
            ),
            const SizedBox(height: 12),

            // Lacak Tiket Laporan
            _buildProgramItem(
              icon: Icons.track_changes_outlined,
              iconBgColor: const Color(0xFFFCE4EC),
              iconColor: const Color(0xFFE53935),
              title: 'Lacak Tiket Laporan',
              subtitle:
                  'Pantau status permohonan klarifikasi yang telah diajukan secara real time.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LacakTiketPage()),
                );
              },
            ),
            const SizedBox(height: 28),

            // ─── Baca Berita ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Baca Berita',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SemuaBeritaHoaksPage(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2979FF),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right,
                          color: Color(0xFF2979FF), size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Berita Cards (show first 3)
            ...daftarBeritaHoaks.take(3).map(
                  (berita) => _buildBeritaCard(berita),
                ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Stat Card Widget
  // ─────────────────────────────────────────────
  Widget _buildStatCard({
    required String value,
    required String label,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: Color(0xFF9CA3AF),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Program Layanan Item
  // ─────────────────────────────────────────────
  Widget _buildProgramItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Color(0xFFD1D5DB), size: 22),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Berita Card Widget
  // ─────────────────────────────────────────────
  Widget _buildBeritaCard(BeritaHoaksItem berita) {
    Color tagColor;
    Color tagBgColor;
    switch (berita.tag) {
      case 'Hoaks':
        tagColor = const Color(0xFFE53935);
        tagBgColor = const Color(0xFFFFEBEE);
        break;
      case 'Fakta':
        tagColor = const Color(0xFF43A047);
        tagBgColor = const Color(0xFFE8F5E9);
        break;
      case 'Disinformasi':
        tagColor = const Color(0xFFFF6F00);
        tagBgColor = const Color(0xFFFFF3E0);
        break;
      case 'Hate Speech':
        tagColor = const Color(0xFF7B1FA2);
        tagBgColor = const Color(0xFFF3E5F5);
        break;
      default:
        tagColor = Colors.grey;
        tagBgColor = Colors.grey.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail image placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.article,
                        color: Colors.grey.shade400, size: 28),
                  ),
                  // Tag overlay on thumbnail
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        berita.tag,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: tagColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag + Date Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: tagColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        berita.tag,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: tagColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      berita.date,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  berita.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Category
                Text(
                  berita.category,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 6),

                // Baca Selengkapnya
                GestureDetector(
                  onTap: () {
                    // Navigate to detail berita
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Baca Selengkapnya',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2979FF),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                          color: Color(0xFF2979FF), size: 14),
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
