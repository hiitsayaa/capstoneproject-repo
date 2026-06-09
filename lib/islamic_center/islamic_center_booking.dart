import 'package:flutter/material.dart';
import 'package:flutter_application_1/islamic_center/islamic_center_list.dart';
import 'package:flutter_application_1/islamic_center/islamic_center_detail.dart';
import 'package:flutter_application_1/islamic_center/services/islamic_center_service.dart';

class IslamicCenterBookingPage extends StatefulWidget {
  const IslamicCenterBookingPage({super.key});

  @override
  State<IslamicCenterBookingPage> createState() => _IslamicCenterBookingPageState();
}

class _IslamicCenterBookingPageState extends State<IslamicCenterBookingPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _paxController = TextEditingController();
  String _selectedFasilitas = 'Aula';
  String _displayedFasilitas = 'Aula';
  bool _hasSearched = false;
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _displayedFasilitas = _selectedFasilitas;
    });

    final data = await IslamicCenterService.getFacilities(category: _selectedFasilitas);
    
    setState(() {
      _searchResults = data;
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
        title: const Text('Islamic Center', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kategori Fasilitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton(Icons.business, 'Aula', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => IslamicCenterListPage(category: 'Aula', pax: _paxController.text)));
                }),
                _buildCategoryButton(Icons.apartment, 'Asrama', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => IslamicCenterListPage(category: 'Asrama', pax: _paxController.text)));
                }),
                _buildCategoryButton(Icons.mosque, 'Masjid', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => IslamicCenterListPage(category: 'Masjid', pax: _paxController.text)));
                }),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Cek Ketersediaan Fasilitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tanggal Acara', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: _showDatePicker,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Masukkan tanggal',
                          hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
                          suffixIcon: const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Jenis Fasilitas', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFasilitas,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black),
                            items: ['Aula', 'Asrama', 'Masjid'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedFasilitas = newValue!;
                                // Don't trigger search automatically as requested by user
                                _hasSearched = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Jumlah Tamu', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _paxController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Masukkan jumlah tamu',
                hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
                prefixIcon: const Icon(Icons.person_outline, size: 20, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Cek Ketersediaan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            if (_hasSearched) ...[
              const SizedBox(height: 32),
              const Text('Hasil Pencarian', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_searchResults.isEmpty)
                const Center(child: Text('Fasilitas tidak ditemukan', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)))
              else
                ..._searchResults.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildFacilityCard(
                      item['id'] ?? '',
                      item['name'] ?? '',
                      item['available'] == true ? 'Tersedia' : 'Penuh',
                      '${item['capacity']} Orang',
                      item['price_label'] ?? '-',
                      item['category'] ?? _displayedFasilitas,
                      item['image_url'] ?? '',
                    ),
                  );
                }),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF2979FF), size: 32),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(String id, String title, String status, String capacity, String price, String category, String imageUrl) {
    bool isAvailable = status == 'Tersedia';
    
    // Fallback dummy image if null or majadigi (unreachable)
    if (imageUrl.isEmpty || imageUrl.contains('majadigi.go.id')) {
      if (category == 'Asrama') {
        imageUrl = 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&q=80&w=400';
      } else if (category == 'Masjid') {
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
              width: 120, // Match height of card roughly
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
                        child: Text(category, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
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
                          category: category,
                          imageUrl: imageUrl,
                          capacity: capacity,
                          price: price,
                          pax: _paxController.text, // Pass Pax!
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
