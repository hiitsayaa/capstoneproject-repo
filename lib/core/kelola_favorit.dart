import 'package:flutter/material.dart';
import 'package:flutter_application_1/account/visitorterdaftar.dart';

class KelolaFavoritPage extends StatefulWidget {
  final List<String> selectedIds;
  const KelolaFavoritPage({super.key, required this.selectedIds});

  @override
  State<KelolaFavoritPage> createState() => _KelolaFavoritPageState();
}

class _KelolaFavoritPageState extends State<KelolaFavoritPage> {
  late List<String> _selectedIds;
  String _searchQuery = '';
  static const int maxFavorit = 8;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedIds);
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        if (_selectedIds.length < maxFavorit) {
          _selectedIds.add(id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maksimal 8 layanan favorit', style: TextStyle(fontFamily: 'Poppins')),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  List<LayananItem> get _filtered {
    if (_searchQuery.isEmpty) return semuaLayanan;
    return semuaLayanan.where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  List<LayananItem> get _favoritItems => semuaLayanan.where((l) => _selectedIds.contains(l.id)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Kelola Layanan Favorit', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected favorites section
                  if (_selectedIds.isNotEmpty) ...[
                    const Text('Layanan Favorit', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 85,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _favoritItems.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final item = _favoritItems[index];
                          return SizedBox(
                            width: 68,
                            child: Column(
                              children: [
                                Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(
                                    color: item.iconColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(item.icon, color: item.iconColor, size: 24),
                                ),
                                const SizedBox(height: 4),
                                Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text('Pilih maksimal $maxFavorit Layanan Favorit',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF9CA3AF))),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    const SizedBox(height: 16),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('Pilih layanan favorit Anda untuk ditampilkan sebagai favorit di beranda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF))),
                      ),
                    ),
                  ],

                  // Semua Layanan
                  const Text('Semua Layanan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Search
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Cari layanan di Majadigi',
                      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFFADB5BD)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFADB5BD), size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF2979FF))),
                      filled: true, fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grid layanan
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.7,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      final isSelected = _selectedIds.contains(item.id);
                      return GestureDetector(
                        onTap: () => _toggle(item.id),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 50, height: 50,
                                  decoration: BoxDecoration(
                                    color: item.iconColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    border: isSelected ? Border.all(color: const Color(0xFF2979FF), width: 2) : null,
                                  ),
                                  child: Icon(item.icon, color: item.iconColor, size: 24),
                                ),
                                Positioned(
                                  right: -4, top: -4,
                                  child: Container(
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.red : const Color(0xFF2979FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isSelected ? Icons.remove : Icons.add,
                                      color: Colors.white, size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Simpan button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selectedIds),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF), foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 15),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
