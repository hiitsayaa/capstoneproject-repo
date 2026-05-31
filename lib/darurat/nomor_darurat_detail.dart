import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _handleCallDetail(BuildContext context, String number, String name) async {
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

class NomorDaruratDetailPage extends StatelessWidget {
  final String wilayah;

  const NomorDaruratDetailPage({super.key, required this.wilayah});

  @override
  Widget build(BuildContext context) {
    // Extract short name for mock data (e.g., "Surabaya" from "Kota Surabaya, Jawa Timur")
    String shortName = wilayah.split(',')[0].replaceAll('Kota ', '').replaceAll('Kabupaten ', '');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Nomor Darurat',
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
            // Location Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFE3F2FD), shape: BoxShape.circle),
                    child: const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(wilayah, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 2),
                        const Text('Layanan darurat di wilayah ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section: Pemadam Kebakaran
            _buildSectionHeader('Pemadam Kebakaran'),
            _buildContactCard(context, 'Dinas Pemadam Kebakaran Kota $shortName', '(031) 3533843'),
            _buildContactCard(context, 'Posko Dinas Kebakaran Kota $shortName', '(031) 99424417'),
            _buildContactCard(context, 'Dinas Pemadam Kebakaran UPTD $shortName', '(031) 3712208'),
            const SizedBox(height: 16),

            // Section: Kesehatan
            _buildSectionHeader('Kesehatan'),
            _buildContactCard(context, 'PMI (Palang Merah Indonesia)', '(031) 99443899'),
            _buildContactCard(context, 'RSUD dr. Mohamad Soewandhie', '031-3717141'),
            _buildContactCard(context, 'RSUD Dr. Soetomo', '031-5501001'),
            _buildContactCard(context, 'Ambulans jenazah Kota $shortName', '112'),
            const SizedBox(height: 16),

            // Section: Kepolisian
            _buildSectionHeader('Kepolisian'),
            _buildContactCard(context, 'Polrestabes $shortName', '(031) 3523927'),
            const SizedBox(height: 16),

            // Section: Layanan Utilitas (Gangguan)
            _buildSectionHeader('Layanan Utilitas (Gangguan)'),
            _buildContactCard(context, 'PDAM (Air)', '800 1926666'),
            _buildContactCard(context, 'PLN (Listrik)', '031 123'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, String name, String number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                Text(number, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          InkWell(
            onTap: () => _handleCallDetail(context, number, name),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone, color: Color(0xFF2979FF), size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
