import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/darurat/services/emergency_service.dart';

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

class NomorDaruratDetailPage extends StatefulWidget {
  final String wilayah;

  const NomorDaruratDetailPage({super.key, required this.wilayah});

  @override
  State<NomorDaruratDetailPage> createState() => _NomorDaruratDetailPageState();
}

class _NomorDaruratDetailPageState extends State<NomorDaruratDetailPage> {
  final EmergencyService _emergencyService = EmergencyService();
  bool _isLoading = true;
  List<EmergencyContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() => _isLoading = true);
    // Extract name before comma for backend query, e.g. "Kota Surabaya, Jawa Timur" -> "Kota Surabaya"
    String queryRegion = widget.wilayah.split(',')[0].trim();
    final data = await _emergencyService.fetchContacts(queryRegion);
    if (mounted) {
      setState(() {
        _contacts = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group contacts by category
    final Map<String, List<EmergencyContact>> groupedContacts = {};
    for (var contact in _contacts) {
      if (!groupedContacts.containsKey(contact.category)) {
        groupedContacts[contact.category] = [];
      }
      groupedContacts[contact.category]!.add(contact);
    }

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
                    decoration: const BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle),
                    child: const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.wilayah, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 2),
                        const Text('Layanan darurat di wilayah ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_contacts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Tidak ada kontak darurat untuk wilayah ini.', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280))),
                ),
              )
            else
              ...groupedContacts.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(entry.key),
                    ...entry.value.map((contact) {
                      return _buildContactCard(context, contact.name, contact.phone);
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
              
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
