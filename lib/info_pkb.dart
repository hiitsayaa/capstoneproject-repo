import 'package:flutter/material.dart';
import 'cek_pajak_lain.dart';
import 'detail_kendaraan.dart';

class InfoPkbPage extends StatelessWidget {
  const InfoPkbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Info Pajak Kendaraan Bermotor',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Kendaraan Anda',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Anda memiliki 2 kendaraan bermotor',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),

            // Card 1: Honda (Belum dibayar)
            _buildVehicleCard(
              context,
              merk: 'HONDA',
              nopol: 'N 3579 ANA',
              jatuhTempo: '25-12-2025',
              isPaid: false,
              iconData: Icons.two_wheeler,
            ),
            const SizedBox(height: 16),

            // Card 2: Mazda (Sudah dibayar)
            _buildVehicleCard(
              context,
              merk: 'MAZDA',
              nopol: 'L 54 SA',
              jatuhTempo: '25-12-2025',
              isPaid: true,
              paidDate: '12-12-2025',
              iconData: Icons.directions_car,
            ),
            const SizedBox(height: 32),

            const Text(
              'Informasi Pajak Kendaraan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),

            // Menu Cek Pajak Kendaraan Pribadi
            _buildMenuAction(
              icon: Icons.directions_car_outlined,
              title: 'Cek Pajak Kendaraan Pribadi',
              onTap: () {
                // Future implementation if needed
              },
            ),
            const SizedBox(height: 12),

            // Menu Cek Pajak Kendaraan Lain
            _buildMenuAction(
              icon: Icons.search,
              title: 'Cek Pajak Kendaraan Lain',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CekPajakLainPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context, {
    required String merk,
    required String nopol,
    required String jatuhTempo,
    required bool isPaid,
    String? paidDate,
    required IconData iconData,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section (Vehicle Info)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Merk',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        merk,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nomor Polisi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        nopol,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
                // Vehicle Icon Placeholder & Detail Button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DetailKendaraanPage()),
                        );
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.open_in_new,
                              size: 14, color: Color(0xFF2979FF)),
                          SizedBox(width: 4),
                          Text(
                            'Detail',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2979FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(iconData,
                          size: 40, color: const Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Mid section (Jatuh Tempo & Status)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal Jatuh Tempo',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      jatuhTempo,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPaid ? const Color(0xFF43A047) : const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPaid ? 'Sudah dibayar' : 'Belum dibayar',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Bottom section (Action / Status info)
          InkWell(
            onTap: isPaid
                ? null
                : () {
                    // Navigate to payment/detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DetailKendaraanPage()),
                    );
                  },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPaid ? Icons.check_circle : Icons.account_balance_wallet_outlined,
                    color: isPaid ? const Color(0xFF43A047) : const Color(0xFF2979FF),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPaid ? 'Telah dibayar pada: $paidDate' : 'Bayar sekarang',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPaid ? const Color(0xFF43A047) : const Color(0xFF2979FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF9800), size: 24), // Using orange icon like the design
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}
