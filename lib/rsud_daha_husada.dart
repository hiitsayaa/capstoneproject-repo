import 'package:flutter/material.dart';
import 'rsud_daha_husada_ketersediaan_kamar.dart';
import 'rsud_daha_husada_jadwal_operasi.dart';
import 'rsud_daha_husada_antrian.dart';

class RsudDahaHusadaPage extends StatefulWidget {
  const RsudDahaHusadaPage({super.key});

  @override
  State<RsudDahaHusadaPage> createState() => _RsudDahaHusadaPageState();
}

class _RsudDahaHusadaPageState extends State<RsudDahaHusadaPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'RSUD Daha Husada',
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
            // Header Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  // Logo Placeholder
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_hospital,
                        size: 80,
                        color: Color(0xFF4CAF50), // Green for Daha Husada
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'RSUD',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Text(
                    'DAHA HUSADA',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RSUD Daha Husada',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Badge
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2979FF)),
                      ),
                      child: const Text(
                        'Rumah Sakit Umum Daerah Daha Husada',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2979FF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Penyedia layanan kesehatan unggulan dari Pemprov Jatim yang menghadirkan perawatan medis profesional, bermutu, dan terjangkau bagi seluruh lapisan masyarakat.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF1A1A1A),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTabItem(0, 'Layanan'),
                  const SizedBox(width: 24),
                  _buildTabItem(1, 'Operasional'),
                  const SizedBox(width: 24),
                  _buildTabItem(2, 'Ketentuan Umum'),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // Tab Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildTabContent(),
            ),

            const SizedBox(height: 32),
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

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildTabLayanan();
      case 1:
        return _buildTabOperasional();
      case 2:
        return _buildTabKetentuanUmum();
      default:
        return const SizedBox();
    }
  }

  // ─────────────────────────────────────────────
  // TAB 1: LAYANAN
  // ─────────────────────────────────────────────
  Widget _buildTabLayanan() {
    return Padding(
      key: const ValueKey('layanan'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _buildLayananItem(
            icon: Icons.bed,
            title: 'Ketersediaan Kamar Rawat',
            description: 'Lihat informasi ketersediaan kamar rawat',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RsudDahaHusadaKetersediaanKamarPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildLayananItem(
            icon: Icons.monitor_heart,
            title: 'Jadwal Operasi',
            description: 'Lihat informasi jadwal operasi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RsudDahaHusadaJadwalOperasiPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildLayananItem(
            icon: Icons.event_note,
            title: 'Informasi Antrian Pasien',
            description: 'Lihat informasi antrian pasien',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RsudDahaHusadaAntrianPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLayananItem({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF1F2937), size: 24),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 2: OPERASIONAL
  // ─────────────────────────────────────────────
  Widget _buildTabOperasional() {
    return Padding(
      key: const ValueKey('operasional'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Website Resmi
          _buildInfoCard(
            icon: Icons.language,
            title: 'Website Resmi',
            subtitle: 'Kunjungi website resmi RSUD Daha Husada',
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ),
          const SizedBox(height: 12),

          // Alamat
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.location_on_outlined, color: Color(0xFF2979FF), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alamat',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Jl. Veteran No.48, Mojoroto, Kec. Mojoroto, Kota Kediri 64112',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280), height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF2979FF)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Lihat di maps',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF2979FF), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Jam Operasional
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.access_time, color: Color(0xFF2979FF), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Jam Operasional', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                      const SizedBox(height: 8),
                      _buildJamRow('Senin', '07:00 - 21:00 WIB'),
                      _buildJamRow('Selasa', '07:00 - 21:00 WIB'),
                      _buildJamRow('Rabu', '07:00 - 21:00 WIB'),
                      _buildJamRow('Kamis', '07:00 - 21:00 WIB'),
                      _buildJamRow('Jumat', '07:00 - 21:00 WIB'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Media Sosial
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.share_outlined, color: Color(0xFF2979FF), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Media Sosial', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildSocialIcon(Icons.camera_alt, const Color(0xFFE1306C)),
                          const SizedBox(width: 10),
                          _buildSocialIcon(Icons.facebook, const Color(0xFF1877F2)),
                          const SizedBox(width: 10),
                          _buildSocialIcon(Icons.play_arrow, const Color(0xFFFF0000)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Aplikasi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.grid_view, color: Color(0xFF2979FF), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Aplikasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                      const SizedBox(height: 8),
                      Container(
                        height: 36,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('GET IT ON', style: TextStyle(color: Colors.white, fontSize: 6)),
                                Text('Google Play', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle, Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2979FF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _buildJamRow(String hari, String jam) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(hari, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
            ],
          ),
          Text(jam, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF1A1A1A))),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 16),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 3: KETENTUAN UMUM
  // ─────────────────────────────────────────────
  Widget _buildTabKetentuanUmum() {
    return Padding(
      key: const ValueKey('ketentuan'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _RsudExpandableCard(
            title: 'Manfaat',
            content: 'RSUD Daha Husada mempunyai tugas melaksanakan sebagian tugas Dinas Kesehatan di bidang promotif, preventif, kuratif, rehabilitatif, penelitian pengembangan, dan melaksanakan UKM Strata II di wilayah kerjanya. Untuk melaksanakan tugas tersebut, RSUD Daha Husada mempunyai fungsi, diantaranya:\n\n'
                '1. Penyusunan rencana dan program RSUD Daha Husada\n'
                '2. Pelaksanaan ketatausahaan\n'
                '3. Pengawasan dan pengendalian operasional rumah sakit\n'
                '4. Pelayanan medis\n'
                '5. Penyelenggaraan pelayanan penunjang medis dan non medis\n'
                '6. Pelaksanaan pelayanan kesehatan umum masyarakat\n'
                '7. Penyelenggaraan pelayanan dan asuhan keperawatan\n'
                '8. Penyelenggaraan pelayanan rujukan pasien, spesimen, IPTEK dan program\n'
                '9. Penyelenggaraan koordinasi dan kemitraan kegiatan Rumah Sakit Umum Daha Husada\n'
                '10. Penyelenggaraan penelitian, pengembangan dan diklat\n'
                '11. Pelaksanaan monitoring dan evaluasi program\n'
                '12. Pelaksanaan pembinaan wilayah di bidang teknis\n'
                '13. Pelaksanaan pelayanan kesehatan masyarakat (promotif, preventif, kuratif dan rehabilitatif) baik UKP maupun UKM di dalam gedung maupun di luar gedung di wilayah kerjanya\n'
                '14. Pelaksanaan tugas lain yang diberikan oleh kepala dinas',
          ),
          const SizedBox(height: 12),
          _RsudExpandableCard(
            title: 'Sistem, Mekanisme, dan Prosedur',
            content: 'Pendaftaran online di poli RSUD Daha Husada\n\n'
                '1. Bagi pasien BPJS Kesehatan, pendaftaran menggunakan aplikasi Mobile JKN\n\n'
                '2. Untuk pasien umum dan asuransi lain, bisa daftar melalui WhatsApp. Caranya, kunjungi web resmi RSUD Daha Husada, pilih menu informasi, dan klik layanan pendaftaran online\n\n'
                '3. Pengguna akan diarahkan ke pesan WhatsApp admin RSUD Daha Husada\n\n'
                'Pendaftaran online via Mobile JKN (khusus pasien BPJS Kesehatan)\n\n'
                '1. Silakan download aplikasi Mobile JKN di Playstore/Appstore\n\n'
                '2. Bagi pengguna baru, silakan buat akun Mobile JKN terlebih dahulu. Siapkan NIK, no HP dan pastikan Anda punya pulsa reguler minimal 5 ribu.\n\n'
                '3. Setelah membuat akun dan sudah terverifikasi, berikutnya ambil antrian di menu "Ambil antrian". Pastikan Anda punya surat rujukan dari FKTP atau memiliki jadwal kontrol di poli RSUD Daha Husada.',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Expandable Card Widget
// ─────────────────────────────────────────────
class _RsudExpandableCard extends StatefulWidget {
  final String title;
  final String content;

  const _RsudExpandableCard({required this.title, required this.content});

  @override
  State<_RsudExpandableCard> createState() => _RsudExpandableCardState();
}

class _RsudExpandableCardState extends State<_RsudExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _isExpanded ? const Color(0xFFF0F5FF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded ? const Color(0xFF2979FF) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  ),
                  Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF6B7280), size: 20),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(widget.content, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF374151), height: 1.5)),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
