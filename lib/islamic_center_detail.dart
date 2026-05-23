import 'package:flutter/material.dart';
import 'islamic_center_form.dart';

class IslamicCenterDetailPage extends StatelessWidget {
  const IslamicCenterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Detail Ruangan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xFFE0E0E0),
              child: const Icon(Icons.image, size: 60, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2979FF)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Aula', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Tersedia', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Hall Utama', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('Surabaya, Jawa Timur', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text('Kapasitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              const Text('2000 Orang', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text('Tarif mulai dari', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              const Text('Rp 10.000.000/hari', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Deskripsi', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Hall Utama Islamic Center Jawa Timur adalah ruang serbaguna megah yang mampu menampung hingga 2.000 orang. Didesain dengan arsitektur yang elegan dan nuansa Islami yang khas, hall ini sangat ideal untuk menyelenggarakan berbagai acara berskala medium hingga besar, seperti seminar nasional, konferensi, pelatihan, wisuda, maupun acara keagamaan.',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text('Fasilitas Bersama', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildFasilitasItem('1 TV LED 24 inci'),
                  _buildFasilitasItem('1 Sofa Panjang'),
                  _buildFasilitasItem('1 Pendingin Ruangan (AC)'),
                  _buildFasilitasItem('1 Toilet Duduk'),
                  const SizedBox(height: 24),
                  const Text('Lokasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        const Center(child: Icon(Icons.map, size: 60, color: Colors.grey)),
                        Positioned(
                          bottom: 12, left: 12, right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 16),
                                const SizedBox(width: 8),
                                const Text('Surabaya, Jawa Timur', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
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
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCenterFormPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Pesan Sekarang', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFasilitasItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.grey, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}
