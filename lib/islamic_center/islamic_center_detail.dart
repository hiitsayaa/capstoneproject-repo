import 'package:flutter/material.dart';
import 'package:flutter_application_1/islamic_center/islamic_center_form.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IslamicCenterDetailPage extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String capacity;
  final String price;
  final String pax;

  const IslamicCenterDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.capacity,
    required this.price,
    required this.pax,
  });

  @override
  State<IslamicCenterDetailPage> createState() => _IslamicCenterDetailPageState();
}

class _IslamicCenterDetailPageState extends State<IslamicCenterDetailPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { margin: 0; padding: 0; }
            iframe { width: 100%; height: 100vh; border: none; }
          </style>
        </head>
        <body>
          <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d126646.25766470858!2d112.63028217712748!3d-7.275441718591583!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2dd7fbf8381ac47f%3A0x3027a76e352be40!2sSurabaya%2C%20East%20Java!5e0!3m2!1sen!2sid!4v1780986083863!5m2!1sen!2sid" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
        </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    String displayImage = widget.imageUrl;
    if (displayImage.isEmpty || displayImage.contains('majadigi.go.id')) {
      if (widget.category == 'Asrama') {
        displayImage = 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&q=80&w=400';
      } else if (widget.category == 'Masjid') {
        displayImage = 'https://images.unsplash.com/photo-1564683214965-3619addd900d?auto=format&fit=crop&q=80&w=400';
      } else {
        displayImage = 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=400';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Detail Ruangan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                image: DecorationImage(
                  image: NetworkImage(displayImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2979FF)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(widget.category, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Tersedia', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('Surabaya, Jawa Timur', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Kapasitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(widget.capacity, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Tarif mulai dari', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(widget.price, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Deskripsi', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.title} Islamic Center Jawa Timur adalah ruang serbaguna megah yang mampu menampung hingga ${widget.capacity}. Didesain dengan arsitektur yang elegan dan nuansa Islami yang khas, fasilitas ini sangat ideal untuk menyelenggarakan berbagai acara berskala medium hingga besar, seperti seminar nasional, konferensi, pelatihan, wisuda, maupun acara keagamaan.',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text('Fasilitas Bersama', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildFasilitasItem('1 TV LED 24 inci'),
                  _buildFasilitasItem('1 Sofa Panjang'),
                  _buildFasilitasItem('1 Pendingin Ruangan (AC)'),
                  _buildFasilitasItem('1 Toilet Duduk'),
                  const SizedBox(height: 24),
                  const Text('Lokasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: WebViewWidget(controller: _controller),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => IslamicCenterFormPage(
                  id: widget.id,
                  title: widget.title,
                  category: widget.category,
                  imageUrl: widget.imageUrl,
                  price: widget.price,
                  pax: widget.pax,
                )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Pesan Sekarang', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFasilitasItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.grey, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}
