import 'package:flutter/material.dart';
import 'package:flutter_application_1/islamic_center/islamic_center_detail.dart';

class IslamicCenterListPage extends StatelessWidget {
  final String category;
  
  const IslamicCenterListPage({super.key, required this.category});

  List<Map<String, String>> _getData() {
    if (category == 'Aula') {
      return [
        {'title': 'Hall Utama', 'capacity': '2.000 Orang', 'price': 'Rp10.000.000'},
        {'title': 'Ruang Rapat', 'capacity': '150 Orang', 'price': 'Rp2.000.000'},
        {'title': 'Ruang VIP', 'capacity': '25 Orang', 'price': 'Rp1.500.000'},
        {'title': 'Ruang VIP 2', 'capacity': '50 Orang', 'price': 'Rp1.000.000'},
      ];
    } else if (category == 'Asrama') {
      return [
        {'title': 'Kamar 2 Bed', 'capacity': '2 Orang', 'price': 'Rp175.000'},
        {'title': 'Kamar 4 Bed', 'capacity': '4 Orang', 'price': 'Rp175.000'},
        {'title': 'Kamar 6 Bed', 'capacity': '6 Orang', 'price': 'Rp175.000'},
      ];
    } else {
      return [
        {'title': 'Ruang VIP Masjid', 'capacity': '100 Orang', 'price': 'Rp3.000.000'},
        {'title': 'Akad Nikah + Petugas', 'capacity': '100 Orang', 'price': 'Rp3.500.000'},
        {'title': 'Ruang VIP 2', 'capacity': '100 Orang', 'price': 'Rp3.500.000'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          category == 'Masjid' ? 'Fasilitas Ruangan Masjid' : 'Fasilitas $category',
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: data.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = data[index];
          return _buildCard(context, item['title']!, item['capacity']!, item['price']!);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String capacity, String price) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120, height: 110,
            decoration: const BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
            child: const Icon(Icons.image, color: Colors.grey, size: 40),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(capacity, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600)),
                          const Text('Kapasitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(price, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600)),
                          const Text('Estimasi Harga', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCenterDetailPage()));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2979FF)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Lihat Detail', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
