import 'package:flutter/material.dart';
import 'rsud_karsa_husada_ketersediaan_kamar.dart';

class RsudKarsaHusadaDetailKamarPage extends StatelessWidget {
  final KamarRawatKarsa kamar;

  const RsudKarsaHusadaDetailKamarPage({
    super.key,
    required this.kamar,
  });

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Kamar',
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Card
              Container(
                padding: const EdgeInsets.all(20),
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
                    Row(
                      children: [
                        Text(kamar.nama, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)),
                          child: Text(kamar.kategori, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: badgeColor)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                          child: Text(kamar.status, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${kamar.kelas} • ${kamar.jenisKelamin}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(kamar.kapasitas.toString(), 'Kapasitas'),
                        Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                        _buildStatItem(kamar.terisi.toString(), 'Terisi'),
                        Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                        _buildStatItem(kamar.tersedia.toString(), 'Tersedia'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tarif
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tarif', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 16),
                    const Text('Tarif Per Hari', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
                    const SizedBox(height: 4),
                    const Text('Rp 500.000/malam', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 8),
                    const Text('*Belum termasuk biaya tindakan & obat', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontStyle: FontStyle.italic, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fasilitas
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fasilitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 16),
                    _buildFacilityItem('2 Tempat Tidur'),
                    _buildFacilityItem('1 TV LED 24 Inci'),
                    _buildFacilityItem('1 Sofa Panjang'),
                    _buildFacilityItem('1 Pendingin Ruangan (AC)'),
                    _buildFacilityItem('1 Toilet Duduk & Shower'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildFacilityItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6B7280)),
            ),
            child: const Icon(Icons.check, size: 10, color: Color(0xFF6B7280)),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1A1A1A))),
        ],
      ),
    );
  }
}
