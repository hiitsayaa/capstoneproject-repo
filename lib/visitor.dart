import 'package:flutter/material.dart';
import 'account.dart';

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
              // Header Klik ke Akun
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountPage()));
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat pagi,', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Ahmad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const Text(' Kota Malang', style: TextStyle(fontSize: 12)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Layanan Favorit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle, color: Color(0xFF0055CC))),
                ],
              ),
              const Center(child: Text('Belum ada layanan yang dipilih', style: TextStyle(color: Colors.grey, fontSize: 12))),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari layanan di Majadigi',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 24),
              const Text('Layanan Umum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                children: [
                  _buildServiceIcon('Bapenda\nJatim', Icons.account_balance),
                  _buildServiceIcon('Nomor\nDarurat', Icons.phone_in_talk),
                  _buildServiceIcon('Point\nJatim', Icons.location_on),
                  _buildServiceIcon('Singles', Icons.grid_view),
                  _buildServiceIcon('Skrining E-\nTibi', Icons.medical_services),
                  _buildServiceIcon('Rsud Daha\nHusada', Icons.local_hospital),
                  _buildServiceIcon('Rsud Haji\nProv. Jatim', Icons.health_and_safety),
                  _buildServiceIcon('Lainnya', Icons.more_horiz),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Berita Terkini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        selectedItemColor: const Color(0xFF0055CC),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Berita'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF0055CC)),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildNewsCard(String title, String category, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(width: 80, height: 60, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2),
                const SizedBox(height: 4),
                Text('$category • $date', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}