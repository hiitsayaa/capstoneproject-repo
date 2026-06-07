import 'package:flutter/material.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD),
        title: const Text(
          'Maja.AI',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hai, Sobat Majadigi! 👋',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Saya bisa bantu kamu cari layanan, cek informasi, atau panduan di Majadigi.',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, height: 1.5),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ada yang bisa saya bantu?',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Contoh yang bisa Anda tanyakan ke Maja AI:',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  _buildSuggestionChip(Icons.person_search_outlined, 'Cara membayar pajak kendaraan'),
                  const SizedBox(height: 12),
                  _buildSuggestionChip(Icons.person_search_outlined, 'Cek Antrian Rumah Sakit'),
                  const SizedBox(height: 12),
                  _buildSuggestionChip(Icons.person_search_outlined, 'Bagaimana cara melaporkan hoaks?'),
                ],
              ),
            ),
          ),
          // Bottom Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ketik pertanyaan Anda dengan Maja AI',
                      hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D6EFD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF0D6EFD), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color(0xFF0D6EFD),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
