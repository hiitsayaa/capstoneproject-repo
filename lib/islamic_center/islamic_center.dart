import 'package:flutter/material.dart';
import 'package:flutter_application_1/islamic_center/islamic_center_booking.dart';

class IslamicCenterPage extends StatefulWidget {
  const IslamicCenterPage({super.key});

  @override
  State<IslamicCenterPage> createState() => _IslamicCenterPageState();
}

class _IslamicCenterPageState extends State<IslamicCenterPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF2979FF),
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Islamic Center', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
          centerTitle: false,
          leading: IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.pop(context)),
        ),
        body: Column(
          children: [
            const SizedBox(height: 24),
            // Logo and Header
            Image.asset('assets/logo_jatim.png', height: 100),
            const SizedBox(height: 16),
            const Text('Islamic Center', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2979FF)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Biro Kesejahteraan Rakyat', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF2979FF), fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Pemesanan online fasilitas aula dan asrama di Islamic Center Surabaya.',
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            // Tabs
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              labelStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13),
              unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 13),
              tabs: [
                Tab(text: 'Layanan'),
                Tab(text: 'Operasional'),
                Tab(text: 'Ketentuan Umum'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildLayananTab(context),
                  _buildOperasionalTab(),
                  _buildKetentuanUmumTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayananTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicCenterBookingPage()));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.business, color: Color(0xFF2979FF)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gedung Islamic Center', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Lihat informasi ketersediaan gedung', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOperasionalTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildInfoCard(
          icon: Icons.language,
          title: 'Website Resmi',
          content: const Text('Kunjungi website resmi Islamic Center', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.location_on_outlined,
          title: 'Alamat',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jl. Raya Dukuh Kupang No. 122-124, Kec. Dukuhpakis, Surabaya', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2979FF)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Lihat di maps', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF2979FF), fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.access_time,
          title: 'Jam Operasional',
          content: Column(
            children: [
              _buildJamRow('Senin', '24 Jam'),
              _buildJamRow('Selasa', '24 Jam'),
              _buildJamRow('Rabu', '24 Jam'),
              _buildJamRow('Kamis', '24 Jam'),
              _buildJamRow('Jumat', '24 Jam'),
              _buildJamRow('Sabtu', '24 Jam'),
              _buildJamRow('Minggu', '24 Jam'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.share_outlined,
          title: 'Media Sosial',
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.purple, Colors.orange]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJamRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 4, color: Colors.grey),
              const SizedBox(width: 8),
              Text(day, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black87)),
            ],
          ),
          Text(time, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required Widget content, Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2979FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                content,
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _buildKetentuanUmumTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildAccordion(
          title: 'Manfaat',
          content: 'Kemudahan pemesanan fasilitas Islamic Centre Surabaya secara online, memungkinkan perencanaan acara Islami kapan pun dan dari mana pun, dengan kenyamanan dan kualitas terbaik.',
        ),
        const SizedBox(height: 12),
        _buildAccordion(
          title: 'Sistem, Mekanisme, dan Prosedur',
          content: 'Platform pemesanan digital fasilitas Islamic Centre yang menyediakan informasi terkait fasilitas yang tersedia, harga, serta jadwal penggunaan. Prosedur pemesanan fasilitas Islamic Centre secara online:\n\n'
                   '1. Akses situs web Islamic Center Jawa Timur.\n'
                   '2. Telusuri informasi fasilitas seperti aula, asrama, ruang pelatihan, dan lainnya.\n'
                   '3. Pilih menu Pemesanan Fasilitas yang diinginkan.\n'
                   '4. Isi formulir pemesanan online dengan data lengkap dan sesuai kebutuhan.\n'
                   '5. Lakukan pembayaran sesuai ketentuan yang berlaku.\n'
                   '6. Pemesanan selesai dan siap digunakan sesuai jadwal yang telah ditentukan.\n'
                   '7. Hubungi pihak terkait apabila terdapat kendala.',
        ),
      ],
    );
  }

  Widget _buildAccordion({required String title, required String content}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
