import 'package:flutter/material.dart';
import 'account.dart';
import 'kelola_favorit.dart';
import 'semua_layanan.dart';
import 'klinik_hoaks.dart';
import 'bapenda_jatim.dart';
import 'islamic_center.dart';
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

// Data model untuk layanan
class LayananItem {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const LayananItem({
    required this.id,
    required this.name,
    this.subtitle = '',
    required this.icon,
    this.iconColor = const Color(0xFF0055CC),
  });
}

// Daftar semua layanan yang tersedia
const List<LayananItem> semuaLayanan = [
  LayananItem(id: 'bapenda', name: 'Bapenda Jatim', subtitle: 'Bapenda Jatim', icon: Icons.account_balance, iconColor: Color(0xFF1565C0)),
  LayananItem(id: 'klinik', name: 'Klinik Hoaks', subtitle: 'Klinik Hoaks', icon: Icons.fact_check, iconColor: Color(0xFFE53935)),
  LayananItem(id: 'darurat', name: 'Nomor Darurat', subtitle: 'Nomor Darurat', icon: Icons.phone_in_talk, iconColor: Color(0xFFE53935)),
  LayananItem(id: 'point', name: 'Point Jatim', subtitle: 'Point Jatim', icon: Icons.stars, iconColor: Color(0xFF43A047)),
  LayananItem(id: 'skrining', name: 'Skrining E-Tibi', subtitle: 'Skrining E-Tibi', icon: Icons.medical_services, iconColor: Color(0xFF00897B)),
  LayananItem(id: 'rsud_daha', name: 'Rsud Daha Husada', subtitle: 'RSUD Daha Husada', icon: Icons.local_hospital, iconColor: Color(0xFF1E88E5)),
  LayananItem(id: 'rsud_haji', name: 'Rsud Haji Prov. Jatim', subtitle: 'RSUD Haji Prov. Jatim', icon: Icons.health_and_safety, iconColor: Color(0xFF43A047)),
  LayananItem(id: 'rsud_karsa', name: 'RSUD Karsa Husada', subtitle: 'RSUD Karsa Husada', icon: Icons.local_hospital, iconColor: Color(0xFF5E35B1)),
  LayananItem(id: 'sapa_bansos', name: 'Sapa Bansos', subtitle: 'SAPA BANSOS', icon: Icons.volunteer_activism, iconColor: Color(0xFFFF6F00)),
  LayananItem(id: 'islamic', name: 'Islamic Center', subtitle: 'Islamic Center', icon: Icons.mosque, iconColor: Color(0xFF00897B)),
  LayananItem(id: 'njkb', name: 'Info NJKB', subtitle: 'Bapenda Jatim', icon: Icons.directions_car, iconColor: Color(0xFF1565C0)),
  LayananItem(id: 'ketersediaan', name: 'Ketersediaan Kamar Rawat', subtitle: 'RSUD Karsa Husada', icon: Icons.bed, iconColor: Color(0xFF5E35B1)),
  LayananItem(id: 'info_kamar', name: 'Info Kamar RSUD Haji', subtitle: 'RSUD Haji Prov. Jatim', icon: Icons.bed, iconColor: Color(0xFF43A047)),
  LayananItem(id: 'jadwal_op', name: 'Jadwal Operasi', subtitle: 'RSUD Daha Husada', icon: Icons.schedule, iconColor: Color(0xFF1E88E5)),
  LayananItem(id: 'antrian', name: 'Info Antrian Pasien', subtitle: 'RSUD Daha Husada', icon: Icons.people, iconColor: Color(0xFF1E88E5)),
  LayananItem(id: 'pajak', name: 'Info Pajak Kendaraan Bermotor', subtitle: 'Bapenda Jatim', icon: Icons.receipt_long, iconColor: Color(0xFF1565C0)),
];

class VisitorTerdaftarPage extends StatefulWidget {
  const VisitorTerdaftarPage({super.key});

  @override
  State<VisitorTerdaftarPage> createState() => _VisitorTerdaftarPageState();
}

class _VisitorTerdaftarPageState extends State<VisitorTerdaftarPage> {
  int _currentIndex = 0;
  List<String> _favoritIds = [];

  // Layanan umum yang ditampilkan di home (8 pertama + Lainnya)
  List<LayananItem> get _layananUmum => semuaLayanan.take(8).toList();
  List<LayananItem> get _favoritLayanan => semuaLayanan.where((l) => _favoritIds.contains(l.id)).toList();

  void _onTabTapped(int index) {
    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountPage()));
      return;
    }
    setState(() => _currentIndex = index);
  }

  Future<void> _openKelolaFavorit() async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => KelolaFavoritPage(selectedIds: List.from(_favoritIds))),
    );
    if (result != null) {
      setState(() => _favoritIds = result);
    }
  }

  void _navigateToLayanan(String id) {
    if (id == 'klinik') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const KlinikHoaksPage()));
    } else if (id == 'bapenda') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const BapendaJatimPage()));
    } else if (id == 'islamic') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCenterPage()));
    } else if (id == 'rsud_haji') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudHajiPage()));
    } else if (id == 'info_kamar') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudHajiKetersediaanKamarPage()));
    } else if (id == 'skrining') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SkriningTbcPage()));
    } else if (id == 'sapa_bansos') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosPage()));
    } else if (id == 'point') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PointJatimPage()));
    } else if (id == 'rsud_karsa') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudKarsaHusadaPage()));
    } else if (id == 'ketersediaan') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudKarsaHusadaKetersediaanKamarPage()));
    } else if (id == 'rsud_daha') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudDahaHusadaPage()));
    } else if (id == 'jadwal_op') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudDahaHusadaJadwalOperasiPage()));
    } else if (id == 'antrian') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudDahaHusadaAntrianPage()));
    } else if (id == 'darurat') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const NomorDaruratPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountPage())),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/profile_placeholder.png'),
                      backgroundColor: Color(0xFFE0E0E0),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat pagi,', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                        Text('Ahmad Putra', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 2),
                    const Text('Kota Malang', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.notifications_none_outlined, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/welcome_image.png', fit: BoxFit.cover, height: 160, width: double.infinity,
                  errorBuilder: (_, _, _) => Container(
                    height: 160, width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF66BB6A)]),
                    ),
                    child: const Center(child: Text('Banner', style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Layanan Favorit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Layanan Favorit', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: _openKelolaFavorit,
                    child: Container(
                      width: 30, height: 30,
                      decoration: const BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_favoritIds.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Belum ada layanan yang dipilih', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 12)),
                  ),
                )
              else
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _favoritLayanan.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final item = _favoritLayanan[index];
                      return GestureDetector(
                        onTap: () => _navigateToLayanan(item.id),
                        child: SizedBox(
                          width: 72,
                          child: Column(
                            children: [
                              Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(
                                  color: item.iconColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(item.icon, color: item.iconColor, size: 26),
                              ),
                              const SizedBox(height: 6),
                              Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari layanan di Majadigi',
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFFADB5BD)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFADB5BD)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF2979FF))),
                  filled: true, fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Layanan Umum
              const Text('Layanan Umum', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 8, childAspectRatio: 0.75,
                ),
                itemCount: _layananUmum.length + 1, // +1 for "Lainnya"
                itemBuilder: (context, index) {
                  if (index == _layananUmum.length) {
                    return _buildServiceTile(
                      icon: Icons.more_horiz,
                      label: 'Lainnya',
                      color: const Color(0xFF9E9E9E),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SemuaLayananPage())),
                    );
                  }
                  final item = _layananUmum[index];
                  return _buildServiceTile(
                    icon: item.icon,
                    label: item.name,
                    color: item.iconColor,
                    onTap: () => _navigateToLayanan(item.id),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Berita Terkini
              const Text('Berita Terkini', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildNewsCard(
                'Strategi Penanganan Banjir Pasuruan: Mas Rusdi Fokus Sinergi Antarinstansi dan Penguatan Shelt...',
                'Peristiwa', 'Senin, 31 Maret 2026',
              ),
              _buildNewsCard(
                'Waspada Ancaman Campak di Gresik: 65 Kasus Muncul, Satu Pasien Bisa Tulari 18 Orang',
                'Kesehatan', 'Senin, 31 Maret 2026',
              ),
              _buildNewsCard(
                'Unair Umumkan Nama 68 Kandidat Penerima Golden Ticket 2026',
                'Pendidikan', 'Senin, 31 Maret 2026',
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Lihat semua berita', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),

              // Banner pertanyaan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2979FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Sampaikan pertanyaan terkait Majadigi atau layanan publik di Jawa Timur',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2979FF),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Berita'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildServiceTile({required IconData icon, required String label, required Color color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String category, String date) {
    Color catColor;
    switch (category) {
      case 'Peristiwa': catColor = const Color(0xFFE53935); break;
      case 'Kesehatan': catColor = const Color(0xFF43A047); break;
      case 'Pendidikan': catColor = const Color(0xFFFF6F00); break;
      default: catColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 80, height: 65,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.image, color: Colors.grey, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: catColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(category, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: catColor, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 6),
                    Text(' • $date', style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.grey)),
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
