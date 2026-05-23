import 'package:flutter/material.dart';
import 'halaman_klinik_hoaks.dart';

class KlinikHoaksPage extends StatefulWidget {
  const KlinikHoaksPage({super.key});

  @override
  State<KlinikHoaksPage> createState() => _KlinikHoaksPageState();
}

class _KlinikHoaksPageState extends State<KlinikHoaksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Logo Jawa Timur
            Center(
              child: Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo_jatim.png',
                      width: 100,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Container(
                        width: 100,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance,
                                size: 48, color: Colors.blue.shade700),
                            const SizedBox(height: 4),
                            Text('Jawa Timur',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 9,
                                    color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Klinik Hoaks Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Klinik Hoaks',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Badge Dinas Komunikasi & Informatika
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF43A047), width: 1),
                ),
                child: const Text(
                  'Dinas Komunikasi & Informatika',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF43A047),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Layanan verifikasi terpercaya dari Pemprov Jatim untuk memvalidasi kebenaran informasi dan menangkal penyebaran hoaks secara cepat.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF1A1A1A),
                unselectedLabelColor: const Color(0xFF9CA3AF),
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                indicatorColor: const Color(0xFF2979FF),
                indicatorWeight: 2.5,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                tabs: const [
                  Tab(text: 'Layanan'),
                  Tab(text: 'Operasional'),
                  Tab(text: 'Ketentuan Umum'),
                ],
              ),
            ),

            // Tab Content
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabLayanan(),
                  _buildTabOperasional(),
                  _buildTabKetentuanUmum(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 1: LAYANAN
  // ─────────────────────────────────────────────
  Widget _buildTabLayanan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _buildLayananItem(
            icon: Icons.fact_check_outlined,
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1565C0),
            title: 'Klinik Hoaks',
            subtitle: 'Lihat informasi seputar hoaks yang beredar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HalamanKlinikHoaks()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLayananItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 22),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 2: OPERASIONAL
  // ─────────────────────────────────────────────
  Widget _buildTabOperasional() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Website Resmi
          _buildOperasionalItem(
            icon: Icons.language,
            iconBgColor: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF43A047),
            title: 'Website Resmi',
            child: const Text(
              'Kunjungi website resmi Klinik Hoaks Provinsi Jawa Timur',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            trailing: const Icon(Icons.chevron_right,
                color: Color(0xFFD1D5DB), size: 22),
            onTap: () {
              // Open website
            },
          ),
          const SizedBox(height: 14),

          // Alamat
          _buildOperasionalItem(
            icon: Icons.location_on,
            iconBgColor: const Color(0xFFFCE4EC),
            iconColor: const Color(0xFFE53935),
            title: 'Alamat',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jl. A. Yani 242 - 244, Gayungan, Surabaya',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Open maps
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2979FF)),
                    ),
                    child: const Text(
                      'Lihat di maps',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2979FF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Jam Operasional
          _buildOperasionalItem(
            icon: Icons.access_time,
            iconBgColor: const Color(0xFFF3E5F5),
            iconColor: const Color(0xFF7B1FA2),
            title: 'Jam Operasional',
            child: Column(
              children: [
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
          const SizedBox(height: 14),

          // Media Sosial
          _buildOperasionalItem(
            icon: Icons.share,
            iconBgColor: const Color(0xFFE0F2F1),
            iconColor: const Color(0xFF00897B),
            title: 'Media Sosial',
            child: Row(
              children: [
                _buildSocialIcon(Icons.camera_alt, const Color(0xFFE91E63)),
                const SizedBox(width: 10),
                _buildSocialIcon(Icons.play_circle_fill, const Color(0xFFFF0000)),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOperasionalItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required Widget child,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
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
                  const SizedBox(height: 6),
                  child,
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildJamRow(String hari, String jam) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Text('•  ',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          SizedBox(
            width: 80,
            child: Text(
              hari,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Text(
            jam,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 3: KETENTUAN UMUM
  // ─────────────────────────────────────────────
  Widget _buildTabKetentuanUmum() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _buildExpandableSection(
            title: 'Manfaat',
            content:
                '1. Membantu masyarakat memverifikasi kebenaran informasi yang beredar.\n\n'
                '2. Mencegah penyebaran hoaks dan disinformasi di lingkungan masyarakat.\n\n'
                '3. Memberikan edukasi kepada masyarakat tentang literasi digital dan cara mengenali hoaks.\n\n'
                '4. Meningkatkan kepercayaan masyarakat terhadap informasi resmi dari pemerintah.',
          ),
          const SizedBox(height: 12),
          _buildExpandableSection(
            title: 'Sistem, Mekanisme, dan Prosedur',
            content:
                '1. Masyarakat mengirimkan informasi yang ingin diverifikasi melalui website atau media sosial resmi Klinik Hoaks.\n\n'
                '2. Tim verifikasi melakukan pengecekan fakta terhadap informasi yang diterima.\n\n'
                '3. Hasil verifikasi dipublikasikan melalui website dan media sosial resmi.\n\n'
                '4. Masyarakat dapat mengakses hasil verifikasi kapan saja melalui platform digital Klinik Hoaks.',
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String content,
  }) {
    return _ExpandableCard(title: title, content: content);
  }
}

class _ExpandableCard extends StatefulWidget {
  final String title;
  final String content;

  const _ExpandableCard({required this.title, required this.content});

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.6,
                ),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
