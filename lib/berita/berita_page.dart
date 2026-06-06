import 'package:flutter/material.dart';
import 'package:flutter_application_1/berita/berita_detail_page.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Pendidikan',
    'Kesehatan',
    'Politik',
    'Ekonomi',
    'Peristiwa'
  ];

  final List<Map<String, String>> _semuaBeritaTerkini = [
    {
      'id': '1',
      'category': 'Peristiwa',
      'title': 'Strategi Penanganan Banjir Pasuruan: Mas Rusdi Fokus Sinergi Antarinstansi dan Penguatan Shelt...',
      'date': 'Senin, 31 Maret 2026',
      'imageUrl': 'https://picsum.photos/seed/banjir/150/150',
    },
    {
      'id': '2',
      'category': 'Kesehatan',
      'title': 'Waspada Ancaman Campak di Gresik: 65 Kasus Muncul, Satu Pasien Bisa Tulari 18 Orang',
      'date': 'Senin, 31 Maret 2026',
      'imageUrl': 'https://picsum.photos/seed/campak/150/150',
    },
    {
      'id': '3',
      'category': 'Pendidikan',
      'title': 'Unair Umumkan Nama 68 Kandidat Penerima Golden Ticket 2026',
      'date': 'Senin, 31 Maret 2026',
      'imageUrl': 'https://picsum.photos/seed/unair/150/150',
    },
    {
      'id': 'detail_1',
      'category': 'Ekonomi',
      'title': 'Pertumbuhan Ekonomi Digital di Jawa Timur Meningkat Pesat Tahun Ini',
      'date': 'Senin, 31 Maret 2026',
      'imageUrl': 'https://picsum.photos/seed/ekonomi/150/150',
    }
  ];

  List<Map<String, String>> get _filteredBerita {
    if (_selectedCategory == 'Semua') return _semuaBeritaTerkini;
    return _semuaBeritaTerkini.where((b) => b['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        elevation: 0,
        title: const Text(
          'Berita',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari berita terkini',
                  hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Color(0xFFADB5BD)),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFADB5BD)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFF2979FF))),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Berita Utama Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Berita Utama',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Berita Utama Horizontal List
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BeritaDetailPage()));
                    },
                    child: _buildBeritaUtamaCard(
                      category: 'Ekonomi',
                      title: 'Pertumbuhan Ekonomi Digital di Jawa Timur Meningkat Pesat Tahun Ini',
                      imageUrl: 'https://picsum.photos/seed/ekonomi/400/200',
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildBeritaUtamaCard(
                    category: 'Pendidikan',
                    title: 'Beasiswa Pendidikan Jatim Segera Dibuka',
                    imageUrl: 'https://picsum.photos/seed/pendidikan/400/200',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Categories
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2979FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2979FF)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Berita Terkini Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Berita Terkini',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Berita Terkini List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _filteredBerita.map((berita) {
                  return GestureDetector(
                    onTap: () {
                      if (berita['id'] == 'detail_1') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const BeritaDetailPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Detail berita menyusul', style: TextStyle(fontFamily: 'Poppins'))));
                      }
                    },
                    child: _buildBeritaTerkiniCard(
                      category: berita['category']!,
                      title: berita['title']!,
                      date: berita['date']!,
                      imageUrl: berita['imageUrl']!,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBeritaUtamaCard({
    required String category,
    required String title,
    required String imageUrl,
  }) {
    Color badgeColor = const Color(0xFF43A047); // Default green
    if (category == 'Ekonomi') badgeColor = const Color(0xFF43A047);
    if (category == 'Pendidikan') badgeColor = const Color(0xFFFF6F00);

    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeritaTerkiniCard({
    required String category,
    required String title,
    required String date,
    required String imageUrl,
  }) {
    Color catColor = Colors.grey;
    switch (category) {
      case 'Peristiwa':
        catColor = const Color(0xFFE53935);
        break;
      case 'Kesehatan':
        catColor = const Color(0xFF43A047);
        break;
      case 'Pendidikan':
        catColor = const Color(0xFFFF6F00);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: catColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• $date',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
