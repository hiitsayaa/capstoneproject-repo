import 'package:flutter/material.dart';
import 'package:flutter_application_1/investasi/point_jatim_investasi.dart';
import 'package:flutter_application_1/investasi/point_jatim_ajukan.dart';

class PointJatimDetailPage extends StatelessWidget {
  final InvestProject project;

  const PointJatimDetailPage({super.key, required this.project});

  void _showHubungiPicDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Balance
                  const Text('Hubungi PIC', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildContactCard(Icons.phone, '081122334455'),
              const SizedBox(height: 12),
              _buildContactCard(Icons.email, 'budi@gmail.com'),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactCard(IconData icon, String text) {
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
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
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
          'POINT JATIM',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: const Color(0xFFE5E7EB),
                    child: const Center(child: Icon(Icons.image, size: 64, color: Color(0xFF9CA3AF))),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF2979FF)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            project.sektor,
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2979FF)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Title
                        Text(
                          project.name,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                        ),
                        const SizedBox(height: 8),
                        
                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Color(0xFF6B7280), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              project.location,
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Nilai Investasi
                        const Text('Nilai Investasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 4),
                        Text(project.nilaiInvestasiStr, style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 24),
                        
                        // Analisis Finansial
                        const Text('Analisis Finansial', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _FinansialItem(label: 'IRR', value: project.irrStr),
                              const SizedBox(width: 1, height: 40, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFE5E7EB)))),
                              _FinansialItem(label: 'NPV', value: project.npvStr),
                              const SizedBox(width: 1, height: 40, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFE5E7EB)))),
                              const _FinansialItem(label: 'Payback Period', value: '5.5 Tahun'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Informasi Proyek
                        const Text('Informasi Proyek', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 8),
                        const Text(
                          'Proyek Integrated Farming Sapi Perah merupakan proyek strategis yang diinisiasi oleh Dinas Peternakan Pemerintah Propinsi Jawa Timur dalam program I-PRO (Investment Project Ready to Offer) dalam rangka mendukung pengembangan investasi yang berbasis ESG (Environmental, Social and Governance) serta peningkatan industri pertanian dan peternakan dalam rangka program ketahanan pangan di Indonesia. Hal ini sesuai dengan trend investasi global pada program ekonomi hijau secara berkelanjutan. Lokasi proyek dikembangkan pada wilayah Desa Ngroto Kecamatan Pujon, Kabupaten Malang Propinsi Jawa Timur dengan dasar pertimbangan Kesesuaian Lahan yang telah memenuhi aspek geografi, topografi, demografi dan aspek-aspek pendukung strategis lainnya seperti dekat dengan potensi market, sumber pakan alamiah dan Lokasi merupakan Klaster terbesar produksi Susu sapi segar di jawa timur.',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280), height: 1.6),
                        ),
                        const SizedBox(height: 24),
                        
                        // Lokasi
                        const Text('Lokasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 12),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Stack(
                            children: [
                              const Center(child: Icon(Icons.map, size: 64, color: Color(0xFFD1D5DB))), // Placeholder for map
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 16),
                                      const SizedBox(width: 8),
                                      Text(project.location, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Info Memo
                        const Text('Info Memo', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 12),
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(child: Icon(Icons.image, size: 64, color: Color(0xFF9CA3AF))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showHubungiPicDialog(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2979FF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Hubungi PIC', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PointJatimAjukanPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Ajukan Investasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
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

class _FinansialItem extends StatelessWidget {
  final String label;
  final String value;

  const _FinansialItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
