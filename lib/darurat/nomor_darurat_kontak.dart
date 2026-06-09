import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/darurat/nomor_darurat_wilayah.dart';
import 'package:flutter_application_1/darurat/nomor_darurat_detail.dart';
import 'package:flutter_application_1/darurat/services/emergency_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

class NomorDaruratKontakPage extends StatefulWidget {
  const NomorDaruratKontakPage({super.key});

  @override
  State<NomorDaruratKontakPage> createState() => _NomorDaruratKontakPageState();
}

class _NomorDaruratKontakPageState extends State<NomorDaruratKontakPage> {
  final EmergencyService _emergencyService = EmergencyService();
  bool _isLoading = true;
  List<EmergencyContact> _jatimContacts = [];
  List<String> _otherRegions = [];

  // Lokasi user saat ini (default)
  String _currentLocation = 'Mencari lokasi...';

  late final WebViewController _mapController;

  @override
  void initState() {
    super.initState();
    _otherRegions = ['Kota Surabaya', 'Kota Kediri', 'Kota Batu'];
    
    _mapController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { margin: 0; padding: 0; }
            iframe { width: 100vw; height: 100vh; border: none; }
          </style>
        </head>
        <body>
          <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d126437.18173780588!2d112.55384463296448!3d-7.98220717407696!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2dd62822063dc2fb%3A0x78879446481a4da2!2sMalang%2C%20Malang%20City%2C%20East%20Java!5e0!3m2!1sen!2sid!4v1780952338613!5m2!1sen!2sid" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
        </body>
        </html>
      ''');

    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _fallbackToMalang();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _fallbackToMalang();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _fallbackToMalang();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Gunakan subAdministrativeArea (Kabupaten/Kota) atau locality (Kota/Kecamatan)
        String city = place.subAdministrativeArea ?? place.locality ?? 'Kota Surabaya';
        
        // Membersihkan prefix "Kabupaten " jika ada agar seragam
        if (city.toLowerCase().startsWith('kabupaten ')) {
          city = city.substring(10);
        } else if (city.toLowerCase().startsWith('kota ')) {
          city = city.substring(5);
        }
        
        setState(() {
          _currentLocation = 'Kota $city';
        });
      } else {
        _fallbackToMalang();
      }
    } catch (e) {
      _fallbackToMalang();
    } finally {
      _fetchData();
    }
  }

  void _fallbackToMalang() {
    setState(() {
      _currentLocation = 'Kota Malang';
    });
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    
    // Fetch Jawa Timur contacts
    final jatim = await _emergencyService.fetchContacts('Jawa Timur');
    
    if (mounted) {
      setState(() {
        _jatimContacts = jatim;
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  if (_jatimContacts.isEmpty)
                    const Text('Belum ada data nomor utama', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)))
                  else
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _jatimContacts.map((contact) {
                        return FractionallySizedBox(
                          widthFactor: 0.47, // Approx half width minus spacing
                          child: _buildUtamaCard(
                            context,
                            contact.name,
                            contact.phone,
                            contact.category.toLowerCase().contains('keamanan')
                                ? Icons.local_police
                                : Icons.headset_mic,
                          ),
                        );
                      }).toList(),
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
                        // Google Maps WebView
                        Container(
                          height: 180,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: WebViewWidget(controller: _mapController),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle),
                                child: const Icon(Icons.location_on, color: Color(0xFF2979FF), size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Lokasi Saat Ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text('$_currentLocation, Jawa Timur', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                                    const SizedBox(height: 2),
                                    const Text('Nomor darurat menyesuaikan lokasi Anda saat ini', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => NomorDaruratDetailPage(wilayah: _currentLocation)));
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
                  
                  ..._otherRegions.map((region) => _buildWilayahItem(context, region)),
                ],
              ),
            ),
    );
  }

  Widget _buildUtamaCard(BuildContext context, String title, String number, IconData icon) {
    return Container(
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
          Text(
            title, 
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
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
              decoration: const BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle),
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
