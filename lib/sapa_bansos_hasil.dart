import 'package:flutter/material.dart';

class SapaBansosHasilPage extends StatelessWidget {
  final String nik;

  const SapaBansosHasilPage({
    super.key,
    required this.nik,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data based on the screenshot
    final String mockNama = 'Ahmad Putra';
    final String mockNik = '3216540506050001';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hasil Pencarian',
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
              // Result Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Anda Terdaftar Sebagai Penerima Bansos',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E88E5),
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2979FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data Diri
              const Text(
                'Data Diri',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              _buildDataRow('Nama', mockNama),
              const SizedBox(height: 8),
              _buildDataRow('NIK', mockNik),
              const SizedBox(height: 24),

              // Informasi Bansos
              const Text(
                'Informasi Bansos',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              _buildBansosCard(
                title: 'Program Keluarga Harapan Plus',
                status: 'Aktif',
                periode: 'Januari - Juni 2026',
              ),
              const SizedBox(height: 12),
              _buildBansosCard(
                title: 'Asistensi Sosial Penyandang Disabilitas',
                status: 'Aktif',
                periode: 'Januari - Juni 2026',
              ),
              const SizedBox(height: 12),
              _buildBansosCard(
                title: 'Asistensi Sosial Penyandang Disabilitas',
                status: 'Aktif',
                periode: 'Januari - Juni 2026', // Based on the UI screenshot which has duplicates
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBansosCard({
    required String title,
    required String status,
    required String periode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: const Text(
                  'Status',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ),
              Expanded(
                child: Text(
                  status,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: const Text(
                  'Periode',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ),
              Expanded(
                child: Text(
                  periode,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
