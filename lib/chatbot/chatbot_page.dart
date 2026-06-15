import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late GenerativeModel _model;
  late ChatSession _chatSession;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _isInitializing = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null ||
          apiKey.isEmpty ||
          apiKey == 'masukkan_api_key_anda_disini') {
        throw Exception(
          'API Key tidak valid. Silakan isi GEMINI_API_KEY di file .env',
        );
      }

      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.system('''
Kamu adalah Maja AI, asisten virtual resmi untuk aplikasi Majadigi. 
Majadigi adalah super-app atau aplikasi layanan publik terintegrasi yang dibuat oleh Pemerintah Provinsi Jawa Timur (Pemprov Jatim).
Tugasmu adalah membantu warga Jawa Timur (panggil mereka "Sobat Majadigi") dalam mencari informasi, menggunakan layanan aplikasi, seperti:
- Cek pajak kendaraan & membayar pajak dan dapat melihat NJKB (Layanan Bapenda)
- Cek ketersediaan kamar rumah sakit (RSUD Karsa Husada)
- Cek ketersediaan kamar rumah sakit (RSUD Haji Jatim)
- Cek ketersediaan kamar rumah sakit, jadwal operasi, dan antrean (RSUD Daha Husada)
- Cek dan melaporkan berita hoaks (Klinik Hoaks)
- Cek data penerima & informasi program bantuan sosial serta ajukan bansos (Bansos)
- Cek informasi investasi di Jawa Timur dan pengajuan investasi projek (Point Jatim)
- Melakukan skrining gejala TBC secara mandiri dan melihat riwayat skrining (Skrining E-Tibi)
- Melihat kontak darurat sesuai lokasi user (Nomor Darurat)
- Melihat informasi ketersediaan & memesan gedung aula, asrama, dan masjid (Islamic Center)
- Selain 10 layanan utama, ada layanan tambahan yaitu "layanan favorit" untuk bantu user cari layanan yang sering digunakan
- Bisa juga melihat berita terkini berdasarkan kategori (Navbar "Berita")
- User bisa melihat aktivitas yang sedang dalam proses atau pun yang sudah selesai  (Navbar "Aktivitas")

Berikan jawaban yang ramah, sopan, ringkas, dan berbahasa Indonesia yang baik. Selalu posisikan dirimu sebagai asisten yang siap membantu urusan layanan publik Provinsi Jawa Timur.
        '''),
      );
      _chatSession = _model.startChat();

      setState(() {
        _isInitializing = false;
        // Kita tidak menambah pesan selamat datang ke _messages di sini
        // karena sudah ada "Greeting Card" statis di UI
      });
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _errorMessage = e.toString();
        _messages.add({
          'role': 'model',
          'text': 'Error inisialisasi: $_errorMessage',
        });
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      final response = await _chatSession.sendMessage(Content.text(text));
      setState(() {
        _messages.add({
          'role': 'model',
          'text': response.text ?? 'Tidak ada respons',
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'model', 'text': 'Terjadi kesalahan: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    // Kita tambah 1 item di index 0 untuk Greeting Card
                    itemCount: _messages.isEmpty ? 1 : _messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildGreetingSection();
                      }

                      final message = _messages[index - 1];
                      final isUser = message['role'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF0D6EFD)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12).copyWith(
                              bottomRight: isUser
                                  ? const Radius.circular(0)
                                  : null,
                              bottomLeft: !isUser
                                  ? const Radius.circular(0)
                                  : null,
                            ),
                            border: isUser
                                ? null
                                : Border.all(color: Colors.grey.shade200),
                          ),
                          child: isUser
                              ? Text(
                                  message['text'] ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )
                              : MarkdownBody(
                                  data: message['text'] ?? '',
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                    strong: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                    listBullet: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                // Bottom Input Field
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _sendMessage,
                          decoration: InputDecoration(
                            hintText: 'Ketik pertanyaan Anda dengan Maja AI',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0D6EFD),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
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
                          onPressed: () => _sendMessage(_textController.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai, Sobat Majadigi! 👋',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Saya bisa bantu kamu cari layanan, cek informasi, atau panduan di Majadigi.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  height: 1.5,
                ),
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
        if (_messages.isEmpty) ...[
          const Text(
            'Contoh yang bisa Anda tanyakan ke Maja AI:',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _sendMessage('Cara membayar pajak kendaraan'),
            child: _buildSuggestionChip(
              Icons.person_search_outlined,
              'Cara membayar pajak kendaraan',
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _sendMessage('Cek Antrian Rumah Sakit'),
            child: _buildSuggestionChip(
              Icons.person_search_outlined,
              'Cek Antrian Rumah Sakit',
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _sendMessage('Bagaimana cara melaporkan hoaks?'),
            child: _buildSuggestionChip(
              Icons.person_search_outlined,
              'Bagaimana cara melaporkan hoaks?',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildSuggestionChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF0D6EFD), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color(0xFF0D6EFD),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
