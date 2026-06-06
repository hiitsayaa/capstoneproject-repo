import 'package:flutter/material.dart';

class BeritaDetailPage extends StatelessWidget {
  const BeritaDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Aktivitas',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pertumbuhan Ekonomi Digital di Jawa Timur Meningkat Pesat Tahun Ini',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Senin, 31 Maret 2026',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Oleh: Humas JATIM',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildParagraph(
                'Kominfo Jatim - Pemerintah Provinsi Jawa Timur menegaskan komitmennya memperkuat transformasi ekonomi digital dan pengembangan sumber daya manusia unggul. Hal ini disampaikan dalam sambutan Gubernur Jawa Timur pada Rapat Pleno Majelis Wali Amanat (MWA) ITS yang digelar daring, melalui Kepala Diskominfo Jatim, Sherlita Ratna Dewi Agustin.'),
            _buildParagraph(
                'Dalam sambutannya, disampaikan, di tengah dinamika global yang penuh ketidakpastian, perekonomian Indonesia tetap menunjukkan kinerja yang tangguh. Pertumbuhan ekonomi nasional pada tahun 2025 tercatat sebesar 5,11 persen, dengan capaian kuartal IV sebesar 5,39 persen, menjadikan Indonesia sebagai salah satu negara dengan pertumbuhan tertinggi di antara negara G20.'),
            _buildParagraph(
                '"Capaian ini tidak hanya mencerminkan kekuatan ekonomi, tetapi juga berdampak pada perbaikan indikator sosial, seperti penurunan tingkat kemiskinan menjadi 8,25 persen dan tingkat pengangguran terbuka yang turun menjadi 4,74 persen," ujar Sherlita, dilansir Rabu (8/4/2026).'),
            _buildParagraph(
                'Lebih lanjut disampaikan, pemerintah menargetkan pertumbuhan ekonomi pada tahun 2026 berada di kisaran 5,4 hingga 5,6 persen, sejalan dengan tema RKP 2026 yakni kedaulatan pangan, energi, dan transformasi ekonomi menuju Indonesia maju.'),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
