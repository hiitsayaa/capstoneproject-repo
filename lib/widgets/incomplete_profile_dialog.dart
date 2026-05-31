import 'package:flutter/material.dart';

class IncompleteProfileDialog extends StatelessWidget {
  final VoidCallback onLengkapiSekarang;

  const IncompleteProfileDialog({
    super.key,
    required this.onLengkapiSekarang,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD), // Biru sangat muda
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Color(0xFF2979FF),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'Data Diri Belum Lengkap',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'Silakan lengkapi data diri Anda di menu Akun terlebih dahulu untuk dapat menggunakan layanan ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            
            // Primary Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  onLengkapiSekarang(); // Panggil aksi untuk pindah ke menu Akun
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                child: const Text('Lengkapi Sekarang'),
              ),
            ),
            const SizedBox(height: 12),
            
            // Secondary Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2979FF),
                  side: const BorderSide(color: Color(0xFF2979FF)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                child: const Text('Nanti Saja'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fungsi helper untuk memanggil dialog dengan mudah dari mana saja
void showIncompleteProfileDialog(BuildContext context, VoidCallback onLengkapiSekarang) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return IncompleteProfileDialog(onLengkapiSekarang: onLengkapiSekarang);
    },
  );
}
