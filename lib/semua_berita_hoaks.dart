import 'package:flutter/material.dart';
import 'halaman_klinik_hoaks.dart';

class SemuaBeritaHoaksPage extends StatefulWidget {
  const SemuaBeritaHoaksPage({super.key});

  @override
  State<SemuaBeritaHoaksPage> createState() => _SemuaBeritaHoaksPageState();
}

class _SemuaBeritaHoaksPageState extends State<SemuaBeritaHoaksPage> {
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  final List<String> _filters = [
    'Semua',
    'Hoaks',
    'Fakta',
    'Disinformasi',
    'Hate Speech',
  ];

  List<BeritaHoaksItem> get _filteredBerita {
    var list = daftarBeritaHoaks.toList();

    // Apply tag filter
    if (_selectedFilter != 'Semua') {
      list = list.where((b) => b.tag == _selectedFilter).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((b) =>
              b.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              b.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBerita;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Semua Berita',
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari berita...',
                hintStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFFADB5BD)),
                prefixIcon:
                    const Icon(Icons.search, color: Color(0xFFADB5BD), size: 20),
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
                fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;

                Color chipColor;
                Color chipTextColor;
                Color chipBorderColor;

                if (isSelected) {
                  switch (filter) {
                    case 'Hoaks':
                      chipColor = const Color(0xFFE53935);
                      break;
                    case 'Fakta':
                      chipColor = const Color(0xFF43A047);
                      break;
                    case 'Disinformasi':
                      chipColor = const Color(0xFFFF6F00);
                      break;
                    case 'Hate Speech':
                      chipColor = const Color(0xFF7B1FA2);
                      break;
                    default:
                      chipColor = const Color(0xFF2979FF);
                  }
                  chipTextColor = Colors.white;
                  chipBorderColor = chipColor;
                } else {
                  chipColor = Colors.white;
                  chipTextColor = const Color(0xFF6B7280);
                  chipBorderColor = const Color(0xFFE5E7EB);
                }

                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: chipBorderColor),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: chipTextColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filtered.length} berita ditemukan',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Berita List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 56, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text(
                          'Tidak ada berita ditemukan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildBeritaCard(filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeritaCard(BeritaHoaksItem berita) {
    Color tagColor;
    Color tagBgColor;
    switch (berita.tag) {
      case 'Hoaks':
        tagColor = const Color(0xFFE53935);
        tagBgColor = const Color(0xFFFFEBEE);
        break;
      case 'Fakta':
        tagColor = const Color(0xFF43A047);
        tagBgColor = const Color(0xFFE8F5E9);
        break;
      case 'Disinformasi':
        tagColor = const Color(0xFFFF6F00);
        tagBgColor = const Color(0xFFFFF3E0);
        break;
      case 'Hate Speech':
        tagColor = const Color(0xFF7B1FA2);
        tagBgColor = const Color(0xFFF3E5F5);
        break;
      default:
        tagColor = Colors.grey;
        tagBgColor = Colors.grey.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.article,
                        color: Colors.grey.shade400, size: 28),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        berita.tag,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: tagColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag + Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: tagColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        berita.tag,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: tagColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      berita.date,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  berita.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Category
                Text(
                  berita.category,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 6),

                // Baca Selengkapnya
                GestureDetector(
                  onTap: () {
                    // Navigate to detail berita
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Baca Selengkapnya',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2979FF),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                          color: Color(0xFF2979FF), size: 14),
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
}
