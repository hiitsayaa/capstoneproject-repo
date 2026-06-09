import 'package:flutter/material.dart';
import 'package:flutter_application_1/islamic_center/islamic_center_detail.dart';
import 'package:flutter_application_1/islamic_center/services/islamic_center_service.dart';

class IslamicCenterListPage extends StatefulWidget {
  final String category;
  final String pax;
  
  const IslamicCenterListPage({super.key, required this.category, this.pax = ''});

  @override
  State<IslamicCenterListPage> createState() => _IslamicCenterListPageState();
}

class _IslamicCenterListPageState extends State<IslamicCenterListPage> {
  bool _isLoading = true;
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await IslamicCenterService.getFacilities(category: widget.category);
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.category == 'Masjid' ? 'Fasilitas Ruangan Masjid' : 'Fasilitas ${widget.category}',
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _data.isEmpty 
          ? const Center(child: Text('Fasilitas tidak ditemukan', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _data.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _data[index];
                return _buildCard(
                  context, 
                  item['id'] ?? '',
                  item['name'] ?? '', 
                  '${item['capacity']} Orang', 
                  item['price_label'] ?? '-',
                  item['available'] == true ? 'Tersedia' : 'Penuh',
                  item['image_url'] ?? '',
                );
              },
            ),
    );
  }

  Widget _buildCard(BuildContext context, String id, String title, String capacity, String price, String status, String imageUrl) {
    bool isAvailable = status == 'Tersedia';

    if (imageUrl.isEmpty || imageUrl.contains('majadigi.go.id')) {
      if (widget.category == 'Asrama') {
        imageUrl = 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&q=80&w=400';
      } else if (widget.category == 'Masjid') {
        imageUrl = 'https://images.unsplash.com/photo-1564683214965-3619addd900d?auto=format&fit=crop&q=80&w=400';
      } else {
        imageUrl = 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=400';
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: const Color(0xFF2979FF)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(widget.category, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(status, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: isAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(capacity, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600)),
                          const Text('Kapasitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(price, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Text('Estimasi Harga', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => IslamicCenterDetailPage(
                          id: id,
                          title: title,
                          category: widget.category,
                          imageUrl: imageUrl,
                          capacity: capacity,
                          price: price,
                          pax: widget.pax,
                        )));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2979FF)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Lihat Detail', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
