import 'package:flutter/material.dart';
import 'visitorterdaftar.dart';
import 'islamic_center.dart';
import 'klinik_hoaks.dart';
import 'bapenda_jatim.dart';
import 'rsud_haji.dart';
import 'rsud_haji_ketersediaan_kamar.dart';
import 'skrining_tbc.dart';
import 'sapa_bansos.dart';
import 'point_jatim.dart';
import 'rsud_karsa_husada.dart';
import 'rsud_karsa_husada_ketersediaan_kamar.dart';
import 'rsud_daha_husada.dart';
import 'rsud_daha_husada_jadwal_operasi.dart';
import 'rsud_daha_husada_antrian.dart';
import 'nomor_darurat.dart';

class SemuaLayananPage extends StatefulWidget {
  const SemuaLayananPage({super.key});

  @override
  State<SemuaLayananPage> createState() => _SemuaLayananPageState();
}

class _SemuaLayananPageState extends State<SemuaLayananPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<String> _categories = ['Semua', 'Kesehatan', 'Kerja', 'Usaha', 'Transportasi'];

  List<LayananItem> get _filtered {
    var list = semuaLayanan.toList();
    if (_searchQuery.isNotEmpty) {
      list = list.where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Semua Layanan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: TextField(
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
          ),

          // Category chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2979FF) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? const Color(0xFF2979FF) : const Color(0xFFE5E7EB)),
                    ),
                    child: Text(cat, style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF6B7280),
                    )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // List layanan
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _filtered.length,
              separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
              itemBuilder: (context, index) {
                final item = _filtered[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  leading: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: item.iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 22),
                  ),
                  title: Text(item.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text(item.subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF9CA3AF))),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
                  onTap: () {
                    if (item.id == 'islamic') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCenterPage()));
                    } else if (item.id == 'klinik') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const KlinikHoaksPage()));
                    } else if (item.id == 'bapenda') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BapendaJatimPage()));
                    } else if (item.id == 'rsud_haji') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudHajiPage()));
                    } else if (item.id == 'info_kamar') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudHajiKetersediaanKamarPage()));
                    } else if (item.id == 'skrining') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SkriningTbcPage()));
                    } else if (item.id == 'sapa_bansos') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosPage()));
                    } else if (item.id == 'point') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PointJatimPage()));
                    } else if (item.id == 'rsud_karsa') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudKarsaHusadaPage()));
                    } else if (item.id == 'ketersediaan') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudKarsaHusadaKetersediaanKamarPage()));
                    } else if (item.id == 'rsud_daha') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudDahaHusadaPage()));
                    } else if (item.id == 'jadwal_op') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudDahaHusadaJadwalOperasiPage()));
                    } else if (item.id == 'antrian') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudDahaHusadaAntrianPage()));
                    } else if (item.id == 'darurat') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NomorDaruratPage()));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
