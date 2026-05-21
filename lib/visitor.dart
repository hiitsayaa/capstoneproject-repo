import 'package:flutter/material.dart';
import 'account_visitor.dart';
import 'login.dart';
import 'klinik_hoaks.dart';
import 'bapenda_jatim.dart';
import 'islamic_center.dart';

class VisitorHomePage extends StatelessWidget {
  const VisitorHomePage({super.key});

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
              const SizedBox(height: 20),
              // Header
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountVisitorPage()));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(Icons.person, color: Colors.grey, size: 30),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat pagi,', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                        Text('Visitor', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const Text(' Kota Malang', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.notifications_none_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/welcome_image.png', fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
              const SizedBox(height: 24),

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Login untuk akses penuh',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE65100)),
                          ),
                          const SizedBox(height: 2),
                          const Text(
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
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                children: [
                  _buildServiceIcon(context, 'Bapenda\nJatim', Icons.account_balance, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BapendaJatimPage()));
                  }),
                  _buildServiceIcon(context, 'Nomor\nDarurat', Icons.phone_in_talk),
                  _buildServiceIcon(context, 'Point\nJatim', Icons.stars),
                  _buildServiceIcon(context, 'Skrining E-\nTibi', Icons.medical_services),
                  _buildServiceIcon(context, 'Rsud Daha\nHusada', Icons.local_hospital),
                  _buildServiceIcon(context, 'Islamic\nCenter', Icons.mosque, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCenterPage()));
                  }),
                  _buildServiceIcon(context, 'Klinik\nHoaks', Icons.fact_check, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const KlinikHoaksPage()));
                  }),
                  _buildServiceIcon(context, 'Lainnya', Icons.more_horiz),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Berita Terkini', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildNewsCard('Strategi Penanganan Banjir Pasuruan...', 'Peristiwa', 'Senin, 31 Maret 2026'),
              _buildNewsCard('Waspada Ancaman Campak di Gresik...', 'Kesehatan', 'Senin, 31 Maret 2026'),
              _buildNewsCard('Unair Umumkan Nama 68 Kandidat...', 'Pendidikan', 'Senin, 31 Maret 2026'),
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountVisitorPage()));
          }
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

  Widget _buildServiceIcon(BuildContext context, String label, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF0055CC)),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10)),
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
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 80, height: 60,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.image, color: Colors.grey, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: catColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(category, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: catColor, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 4),
                    Text(' • $date', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}