import 'package:flutter/material.dart';
import 'nomor_darurat_detail.dart';

class NomorDaruratWilayahPage extends StatefulWidget {
  const NomorDaruratWilayahPage({super.key});

  @override
  State<NomorDaruratWilayahPage> createState() => _NomorDaruratWilayahPageState();
}

class _NomorDaruratWilayahPageState extends State<NomorDaruratWilayahPage> {
  final List<String> _allWilayah = [
    'Kota Batu, Jawa Timur',
    'Kota Blitar, Jawa Timur',
    'Kota Kediri, Jawa Timur',
    'Kota Madiun, Jawa Timur',
    'Kota Malang, Jawa Timur',
    'Kota Mojokerto, Jawa Timur',
    'Kota Surabaya, Jawa Timur',
    'Kota Pasuruan, Jawa Timur',
    'Kota Probolinggo, Jawa Timur',
    'Kabupaten Banyuwangi, Jawa Timur',
    'Kabupaten Tuban, Jawa Timur',
    'Kabupaten Bondowoso, Jawa Timur',
    'Kabupaten Lamongan, Jawa Timur',
    'Kabupaten Lumajang, Jawa Timur',
    'Kabupaten Pacitan, Jawa Timur',
    'Kabupaten Pamekasan, Jawa Timur',
    'Kabupaten Sampang, Jawa Timur',
    'Kabupaten Sidoarjo, Jawa Timur',
    'Kabupaten Trenggalek, Jawa Timur',
    'Kabupaten Tulungagung, Jawa Timur',
    'Kabupaten Jember, Jawa Timur',
    'Kabupaten Jombang, Jawa Timur',
    'Kabupaten Ponorogo, Jawa Timur',
    'Kabupaten Kediri, Jawa Timur',
    'Kabupaten Madiun, Jawa Timur',
    'Kabupaten Magetan, Jawa Timur',
    'Kabupaten Malang, Jawa Timur',
    'Kabupaten Mojokerto, Jawa Timur',
    'Kabupaten Nganjuk, Jawa Timur',
    'Kabupaten Ngawi, Jawa Timur',
    'Kabupaten Pasuruan, Jawa Timur',
    'Kabupaten Probolinggo, Jawa Timur',
    'Kabupaten Situbondo, Jawa Timur',
    'Kabupaten Sumenep, Jawa Timur',
    'Kabupaten Bangkalan, Jawa Timur',
    'Kabupaten Blitar, Jawa Timur',
    'Kabupaten Bojonegoro, Jawa Timur',
    'Kabupaten Gresik, Jawa Timur',
  ];

  List<String> _filteredWilayah = [];
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredWilayah = _allWilayah;
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWilayah = _allWilayah;
      } else {
        _filteredWilayah = _allWilayah
            .where((w) => w.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cari Wilayah Lainnya',
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _filter,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Ketik nama kota/kabupaten',
                      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2979FF))),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _filter(_searchCtrl.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('Cari', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              itemCount: _filteredWilayah.length,
              itemBuilder: (context, index) {
                return _buildWilayahItem(context, _filteredWilayah[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWilayahItem(BuildContext context, String name) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => NomorDaruratDetailPage(wilayah: name)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFE3F2FD), shape: BoxShape.circle),
              child: const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}
