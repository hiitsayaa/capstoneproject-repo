import 'package:flutter/material.dart';
import 'package:flutter_application_1/account/account_visitor.dart';
import 'package:flutter_application_1/auth/views/login_view.dart';
import 'package:flutter_application_1/hoaks/klinik_hoaks.dart';
import 'package:flutter_application_1/pajak/bapenda_jatim.dart';
import 'package:flutter_application_1/islamic_center/islamic_center.dart';
import 'package:flutter_application_1/investasi/point_jatim.dart';
import 'package:flutter_application_1/kesehatan/rsud_karsa_husada.dart';
import 'package:flutter_application_1/kesehatan/rsud_daha_husada.dart';
import 'package:flutter_application_1/widgets/floating_chatbot.dart';
import 'package:flutter_application_1/account/visitorterdaftar.dart'; // for LayananItem and referensiLayanan

class VisitorHomePage extends StatefulWidget {
  const VisitorHomePage({super.key});

  @override
  State<VisitorHomePage> createState() => _VisitorHomePageState();
}

class _VisitorHomePageState extends State<VisitorHomePage> {
  int _currentIndex = 0;
  String _searchQuery = '';

  List<LayananItem> get _layananUmum => referensiLayanan.take(7).toList();

  List<LayananItem> get _filteredLayanan {
    if (_searchQuery.isEmpty) return _layananUmum;
    return referensiLayanan.where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat pagi,';
    if (hour < 15) return 'Selamat siang,';
    if (hour < 18) return 'Selamat sore,';
    return 'Selamat malam,';
  }

  void _navigateToLayanan(String id) {
    // Requires login for some services, or allow navigation to public ones
    if (id == 'klinik_hoaks') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const KlinikHoaksPage()));
    } else if (id == 'bapenda') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const BapendaJatimPage()));
    } else if (id == 'islamic_center') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCenterPage()));
    } else if (id == 'point_jatim') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PointJatimPage()));
    } else if (id == 'rsud_karsa_husada') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudKarsaHusadaPage()));
    } else if (id == 'rsud_daha_husada') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RsudDahaHusadaPage()));
    } else {
      // If service is not publicly available or requires login
      _showLoginPromptDialog();
    }
  }

  void _showLoginPromptDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Akses Terbatas', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Text('Silakan login terlebih dahulu untuk mengakses layanan ini.', style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D6EFD), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            child: const Text('Login', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRequiredPage(String title, IconData icon) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: const Color(0xFF2979FF),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                child: Icon(icon, size: 64, color: const Color(0xFF2979FF)),
              ),
              const SizedBox(height: 24),
              Text('Fitur $title Terkunci', style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Silakan login atau daftar akun untuk mengakses fitur ini secara penuh.',
                  textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                  child: const Text('Login Sekarang', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      switch (_currentIndex) {
        case 0: return _buildBeranda(context);
        case 1: return _buildLoginRequiredPage('Berita', Icons.article_outlined);
        case 2: return _buildLoginRequiredPage('Aktivitas', Icons.show_chart);
        case 3: return const AccountVisitorPage();
        default: return const SizedBox();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          getBody(),
          if (_currentIndex == 0) FloatingChatbotWidget(
            onTapOverride: () {
              // Menampilkan pesan untuk login ketika chatbot ditekan oleh visitor
              _showLoginPromptDialog();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2979FF),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Berita'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildBeranda(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/profile_placeholder.png'),
                    backgroundColor: Color(0xFFE0E0E0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getGreeting(), style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                        const Text('Visitor', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 2),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: const Text(
                      'Jawa Timur', 
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
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

            // Login info banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFCC80)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFE65100), size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login untuk akses penuh',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE65100)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Masuk ke akun untuk menikmati layanan favorit, data diri, dan fitur lainnya.',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFFBF360C), height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => route.isFirst,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE65100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Masuk', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search bar
            TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari layanan di Majadigi',
                hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFFADB5BD)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFADB5BD)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF2979FF))),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Layanan Umum', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 8, childAspectRatio: 0.75,
              ),
              itemCount: _searchQuery.isEmpty ? _layananUmum.length + 1 : _filteredLayanan.length, // +1 for "Lainnya" if not searching
              itemBuilder: (context, index) {
                if (_searchQuery.isEmpty && index == _layananUmum.length) {
                  return _buildServiceTile(
                    icon: Icons.more_horiz,
                    label: 'Lainnya',
                    color: const Color(0xFF9E9E9E),
                    onTap: () => _showLoginPromptDialog(), // Atur lainnya agar login
                  );
                }
                final item = _searchQuery.isEmpty ? _layananUmum[index] : _filteredLayanan[index];
                return _buildServiceTile(
                  icon: item.icon,
                  label: item.name,
                  color: item.iconColor,
                  imageAsset: item.imageAsset,
                  onTap: () => _navigateToLayanan(item.id),
                );
              },
            ),
            const SizedBox(height: 24),

            const Text('Berita Terkini', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildNewsCard(
              'Strategi Penanganan Banjir Pasuruan: Mas Rusdi Fokus Sinergi Antarinstansi dan Penguatan Shelt...',
              'Peristiwa', 'Senin, 31 Maret 2026',
              imageUrl: 'https://images.unsplash.com/photo-1542282088-fe8426682b8f?auto=format&fit=crop&q=80&w=200',
            ),
            _buildNewsCard(
              'Waspada Ancaman Campak di Gresik: 65 Kasus Muncul, Satu Pasien Bisa Tulari 18 Orang',
              'Kesehatan', 'Senin, 31 Maret 2026',
              imageUrl: 'https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?auto=format&fit=crop&q=80&w=200',
            ),
            _buildNewsCard(
              'Unair Umumkan Nama 68 Kandidat Penerima Golden Ticket 2026',
              'Pendidikan', 'Senin, 31 Maret 2026',
              imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&q=80&w=200',
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _currentIndex = 1),
                child: const Text('Lihat semua berita', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile({required IconData icon, required String label, required Color color, String imageAsset = '', VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imageAsset.isNotEmpty
              ? SizedBox(
                  width: 50, height: 50,
                  child: Image.asset(imageAsset, fit: BoxFit.contain),
                )
              : Container(
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

  Widget _buildNewsCard(String title, String category, String date, {String imageUrl = ''}) {
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
            child: imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.grey, size: 28),
                    ),
                  )
                : const Icon(Icons.image, color: Colors.grey, size: 28),
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