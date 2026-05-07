import 'package:flutter/material.dart';
import 'pilih_bahasa.dart';
import 'login.dart';

class AccountVisitorPage extends StatelessWidget {
  const AccountVisitorPage({super.key});

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
              const SizedBox(height: 30),
              // Profile Header - Visitor
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person, color: Colors.grey, size: 40),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visitor',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Anda belum login', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Login Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2979FF), Color(0xFF448AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Login untuk akses lebih banyak',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk ke akun Anda untuk menikmati semua fitur layanan publik, kelola data diri, layanan favorit, dan lainnya.',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white70, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => route.isFirst,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2979FF),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        child: const Text('Masuk Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Informasi Lainnya
              const Text('Informasi Lainnya', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              _buildMenuItem(Icons.settings_outlined, 'Tentang Jatim'),
              _buildMenuItem(Icons.language_outlined, 'Ganti Bahasa', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PilihBahasaPage()));
              }),
              _buildMenuItem(Icons.star_outline, 'Beri Rating'),
              _buildMenuItem(Icons.info_outline, 'Syarat & Ketentuan'),
              _buildMenuItem(Icons.privacy_tip_outlined, 'Kebijakan Privasi'),
              _buildMenuItem(Icons.help_outline, 'Pusat Bantuan (FAQ)'),

              const SizedBox(height: 30),
              // Logout / Kembali ke Welcome
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  icon: const Icon(Icons.logout, color: Color(0xFF0055CC)),
                  label: const Text('Keluar', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF0055CC))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
