import 'package:flutter/material.dart';
import 'sapa_bansos_penerima.dart';
import 'sapa_bansos_ajukan.dart';

class SapaBansosPage extends StatefulWidget {
  const SapaBansosPage({super.key});

  @override
  State<SapaBansosPage> createState() => _SapaBansosPageState();
}

class _SapaBansosPageState extends State<SapaBansosPage> {
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
          'SAPA BANSOS',
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
                  // Logo Placeholder (Jatim logo)
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // Use a placeholder icon for the logo
                    child: const Icon(
                      Icons.shield,
                      size: 100,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Informasi Bantuan Sosial',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Badge
                  Container(
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
                      'Dinas Sosial',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2979FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Sistem Aplikasi Pelayanan Administrasi Bantuan Sosial',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
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
            icon: Icons.article_outlined,
            title: 'Data Penerima & Info Program Bansos',
            description: 'Lihat informasi terkait program',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SapaBansosPenerimaPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildLayananItem(
            icon: Icons.assignment_outlined,
            title: 'Ajukan Bansos',
            description: 'Lihat informasi terkait program',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SapaBansosAjukanPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildLayananItem(
            icon: Icons.assignment_late_outlined,
            title: 'Sanggahan Bansos',
            description: 'Lihat informasi terkait program',
            onTap: () {},
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
            subtitle: 'Kunjungi website resmi Sapa Bansos',
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
                        'Jl. Gayung Kebonsari No.56b, Gayungan, Kec. Gayungan, Kota Surabaya, Jawa Timur 60235',
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
                      _buildJamRow('Senin', '24 Jam'),
                      _buildJamRow('Selasa', '24 Jam'),
                      _buildJamRow('Rabu', '24 Jam'),
                      _buildJamRow('Kamis', '24 Jam'),
                      _buildJamRow('Jumat', '24 Jam'),
                      _buildJamRow('Sabtu', '24 Jam'),
                      _buildJamRow('Minggu', '24 Jam'),
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
                          _buildSocialIcon(Icons.play_arrow, Colors.red),
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
                  child: const Icon(
                    Icons.apps,
                    color: Color(0xFF2979FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aplikasi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Google Play',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
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
        children: [
          Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle)),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: Text(hari, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A)))),
          Text(jam, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
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
          _BansosExpandableCard(
            title: 'Manfaat',
            content: 'Bantuan sosial berfungsi sebagai jaring pengaman sosial untuk membantu masyarakat yang kurang mampu agar dapat memenuhi kebutuhan dasar hidup mereka.',
          ),
          const SizedBox(height: 12),
          _BansosExpandableCard(
            title: 'Sistem, Mekanisme, dan Prosedur',
            content: '1. Pemohon mendaftar secara online melalui Sapa Bansos.\n'
                '2. Mengisi formulir dan mengunggah dokumen yang dipersyaratkan.\n'
                '3. Proses verifikasi data oleh Dinas Sosial.\n'
                '4. Pemohon dapat mengecek status permohonan melalui fitur cek bansos.\n'
                '5. Apabila lolos, bansos akan disalurkan sesuai ketentuan.',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Expandable Card Widget
// ─────────────────────────────────────────────
class _BansosExpandableCard extends StatefulWidget {
  final String title;
  final String content;

  const _BansosExpandableCard({required this.title, required this.content});

  @override
  State<_BansosExpandableCard> createState() => _BansosExpandableCardState();
}

class _BansosExpandableCardState extends State<_BansosExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _isExpanded ? const Color(0xFFF9FAFB) : Colors.white,
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
