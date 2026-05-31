import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/darurat/nomor_darurat_wilayah.dart';
import 'package:flutter_application_1/darurat/nomor_darurat_detail.dart';

Future<void> _handleCall(BuildContext context, String number, String name) async {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
      content: Text('Nomor: $number\nPilih tindakan yang ingin dilakukan.', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280))),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: number));
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nomor $number disalin ke clipboard!')));
          },
          child: const Text('Salin Nomor', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF2979FF))),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            Navigator.pop(ctx);
            final Uri phoneUri = Uri(scheme: 'tel', path: number.replaceAll(RegExp(r'[^0-9]'), ''));
            if (await canLaunchUrl(phoneUri)) {
              await launchUrl(phoneUri);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat melakukan panggilan pada perangkat ini.')));
              }
            }
          },
          child: const Text('Telepon', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        ),
      ],
    ),
  );
}

class NomorDaruratKontakPage extends StatelessWidget {
  const NomorDaruratKontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Kontak Darurat',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue 112 Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2979FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Butuh Bantuan Darurat?', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Hubungi layanan darurat Nasional', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white70)),
                        SizedBox(height: 12),
                        Text('112', style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _handleCall(context, '112', 'Layanan Darurat Nasional'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone, color: Color(0xFF2979FF), size: 32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nomor Utama Jatim
            const Text('Nomor Utama di Jawa Timur', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildUtamaCard(context, 'Polda JATIM', '(031) 8280748', Icons.local_police),
                const SizedBox(width: 16),
                _buildUtamaCard(context, 'Call Center JATIM', '1500979', Icons.headset_mic),
              ],
            ),
            const SizedBox(height: 24),

            // Lokasi Saat Ini Map
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  // Map placeholder
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Surabaya&zoom=12&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7CSurabaya'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: const Color(0xFFE3F2FD), shape: BoxShape.circle),
                          child: const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 16),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Lokasi Saat Ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Text('Kota Surabaya, Jawa Timur', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                              SizedBox(height: 2),
                              Text('Nomor darurat menyesuaikan lokasi Anda saat ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NomorDaruratDetailPage(wilayah: 'Kota Surabaya, Jawa Timur')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Lihat nomor di wilayah ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                          Icon(Icons.chevron_right, color: Color(0xFF2979FF), size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Cari Wilayah Lainnya
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Cari Wilayah Lainnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NomorDaruratWilayahPage()));
                  },
                  child: const Text('Lihat Semua >', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildWilayahItem(context, 'Kota Malang, Jawa Timur'),
            _buildWilayahItem(context, 'Kota Sidoarjo, Jawa Timur'),
            _buildWilayahItem(context, 'Kota Mojokerto, Jawa Timur'),
          ],
        ),
      ),
    );
  }

  Widget _buildUtamaCard(BuildContext context, String title, String number, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF2979FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 4),
            Text(number, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleCall(context, number, title),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 0,
                ),
                icon: const Icon(Icons.phone, size: 14, color: Colors.white),
                label: const Text('Hubungi', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWilayahItem(BuildContext context, String name) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => NomorDaruratDetailPage(wilayah: name)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFE3F2FD), shape: BoxShape.circle),
              child: const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}
