import 'package:flutter/material.dart';
import 'package:flutter_application_1/account/data_diri.dart';
import 'package:flutter_application_1/core/pilih_bahasa.dart';
import '../auth/controllers/auth_controller.dart';
import '../core/main.dart'; // Untuk WelcomeScreen
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
              // Profile Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_placeholder.png'), // Ganti dengan foto user jika ada
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthController.currentUser?.name ?? 'Pengguna',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(AuthController.currentUser?.email ?? 'Tidak ada email', style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      if (AuthController.currentUser?.isProfileComplete == false)
                        Row(
                          children: [
                            _buildStatusBadge('Lengkapi Profil', Colors.red.shade100, Colors.red),
                          ],
                        )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),
              
              const Text('Keamanan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              _buildMenuItem(Icons.person_outline, 'Data Diri', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataDiriPage()),
                );
              }),
              _buildMenuItem(Icons.lock_outline, 'Ubah Kata Sandi'),
              
              const SizedBox(height: 24),
              const Text('Informasi Lainnya', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              _buildMenuItem(Icons.settings_outlined, 'Tentang Jatim'),
              _buildMenuItem(Icons.language_outlined, 'Ganti Bahasa', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PilihBahasaPage()),
                );
              }),
              _buildMenuItem(Icons.star_outline, 'Beri Rating'),
              _buildMenuItem(Icons.info_outline, 'Syarat & Ketentuan'),
              _buildMenuItem(Icons.privacy_tip_outlined, 'Kebijakan Privasi'),
              _buildMenuItem(Icons.help_outline, 'Pusat Bantuan (FAQ)'),
              
              const SizedBox(height: 30),
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await AuthController().logout();
                    
                    if (!context.mounted) return;
                    
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Color(0xFF0055CC)),
                  label: const Text('Logout', style: TextStyle(color: Color(0xFF0055CC))),
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

  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Text(text, style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Icon(Icons.edit, size: 10, color: textColor),
        ],
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
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}