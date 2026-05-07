import 'package:flutter/material.dart';

class PilihBahasaPage extends StatefulWidget {
  const PilihBahasaPage({super.key});

  @override
  State<PilihBahasaPage> createState() => _PilihBahasaPageState();
}

class _PilihBahasaPageState extends State<PilihBahasaPage> {
  String _selectedLanguage = 'id';

  final List<Map<String, String>> _languages = [
    {'name': 'Bahasa Indonesia', 'value': 'id'},
    {'name': 'English', 'value': 'en'},
    {'name': 'Bahasa Jawa', 'value': 'jv'},
    {'name': 'Bahasa Madura', 'value': 'mad'},
    {'name': 'Bahasa Osing', 'value': 'os'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        title: const Text(
          'Pilihan Bahasa',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Bahasa',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191B24),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Silakan pilih bahasa yang ingin Anda gunakan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Radio list
                    ..._languages.map(
                      (lang) => _buildLanguageItem(lang['name']!, lang['value']!),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Save action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String title, String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() {
                  _selectedLanguage = val!;
                });
              },
              activeColor: const Color(0xFF2196F3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF191B24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
