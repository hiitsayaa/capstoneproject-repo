import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/kesehatan/skrining_tbc_hasil.dart';

// ─────────────────────────────────────────────
// Screening History Storage (in-memory)
// ─────────────────────────────────────────────
class SkriningRecord {
  final String namaLengkap;
  final String nik;
  final DateTime tanggal;
  final bool terindikasi;
  final String? faskes;
  final Map<String, dynamic> identitas;
  final Map<int, bool> jawaban;

  SkriningRecord({
    required this.namaLengkap,
    required this.nik,
    required this.tanggal,
    required this.terindikasi,
    this.faskes,
    required this.identitas,
    required this.jawaban,
  });
}

// Global storage for screening history
final List<SkriningRecord> riwayatSkrining = [
  SkriningRecord(
    namaLengkap: 'Ahmad Putra',
    nik: '3216540506050001',
    tanggal: DateTime(2026, 4, 12),
    terindikasi: true,
    faskes: 'Puskesmas Ciputunjo',
    identitas: {},
    jawaban: {},
  ),
  SkriningRecord(
    namaLengkap: 'Ahmad Putra',
    nik: '3216540506050001',
    tanggal: DateTime(2026, 4, 12),
    terindikasi: false,
    faskes: null,
    identitas: {},
    jawaban: {},
  ),
];

// ─────────────────────────────────────────────
// Dropdown Data
// ─────────────────────────────────────────────
const List<String> pekerjaanList = [
  'Buruh',
  'Guru/Dosen',
  'Pegawai Swasta/SUMN/BUMD',
  'Pelajar/Mahasiswa',
  'Petani/Peternak/Nelayan',
  'PNS',
  'Sopir',
  'Tenaga Profesional Medis',
  'Tenaga Profesional Non Medis',
  'TNI/Polri',
  'Wiraswasta',
  'Asisten Rumah Tangga',
  'Lainnya',
];

const List<String> kabupatenKotaList = [
  'Kab. Pacitan',
  'Kab. Ponorogo',
  'Kab. Trenggalek',
  'Kab. Tulungagung',
  'Kab. Blitar',
  'Kab. Kediri',
  'Kab. Malang',
  'Kab. Lumajang',
  'Kab. Jember',
  'Kab. Banyuwangi',
  'Kab. Bondowoso',
  'Kab. Situbondo',
  'Kab. Probolinggo',
  'Kab. Pasuruan',
  'Kab. Sidoarjo',
  'Kab. Mojokerto',
  'Kab. Jombang',
  'Kab. Nganjuk',
  'Kab. Madiun',
  'Kab. Magetan',
  'Kab. Ngawi',
  'Kab. Bojonegoro',
  'Kab. Tuban',
  'Kab. Lamongan',
  'Kab. Gresik',
  'Kab. Bangkalan',
  'Kab. Sampang',
  'Kab. Pamekasan',
  'Kab. Sumenep',
  'Kota Kediri',
  'Kota Blitar',
  'Kota Malang',
  'Kota Probolinggo',
  'Kota Pasuruan',
  'Kota Mojokerto',
  'Kota Madiun',
  'Kota Surabaya',
  'Kota Batu',
];

const Map<String, List<String>> kecamatanMap = {
  'Kota Malang': ['Blimbing', 'Klojen', 'Kedungkandang', 'Sukun', 'Lowokwaru'],
  'Kota Surabaya': ['Gubeng', 'Genteng', 'Tegalsari', 'Wonokromo', 'Rungkut', 'Sukolilo'],
  'Kab. Malang': ['Singosari', 'Lawang', 'Batu', 'Kepanjen', 'Gondanglegi'],
};

const Map<String, List<String>> kelurahanMap = {
  'Lowokwaru': ['Tunggulwulung', 'Mojolangu', 'Tlogomas', 'Dinoyo', 'Sumbersari', 'Ketawanggede', 'Jatimulyo', 'Tunjungsekar', 'Mojolangu', 'Tulusrejo', 'Lowokwaru', 'Tasik Madu'],
  'Blimbing': ['Blimbing', 'Purwodadi', 'Polowijen', 'Arjosari', 'Pandanwangi', 'Purwantoro', 'Bunulrejo', 'Kesatrian', 'Polehan', 'Jodipan', 'Ksatrian'],
  'Klojen': ['Klojen', 'Rampal Celaket', 'Samaan', 'Kiduldalem', 'Sukoharjo', 'Kasin', 'Kauman', 'Oro-oro Dowo', 'Bareng', 'Gadingkasri', 'Penanggungan'],
  'Kedungkandang': ['Kedungkandang', 'Sawojajar', 'Madyopuro', 'Lesanpuro', 'Kotalama', 'Mergosono', 'Bumiayu', 'Wonokoyo', 'Tlogowaru', 'Arjowinangun', 'Cemorokandang', 'Buring'],
  'Sukun': ['Sukun', 'Ciptomulyo', 'Gadang', 'Kebonsari', 'Bandungrejosari', 'Mulyorejo', 'Bakalan Krajan', 'Karangbesuki', 'Pisang Candi', 'Bandulan', 'Tanjungrejo'],
};

const List<String> kelompokList = ['Lainnya', 'Kader', 'Nakes'];

// ─────────────────────────────────────────────
// Screening Questions
// ─────────────────────────────────────────────
class SkriningQuestion {
  final int nomor;
  final String text;
  final String section;
  final bool autoFilled; // For questions 21-23

  const SkriningQuestion({
    required this.nomor,
    required this.text,
    required this.section,
    this.autoFilled = false,
  });
}

const List<SkriningQuestion> skriningQuestions = [
  // Gejala Fisik dan Keluhan
  SkriningQuestion(nomor: 1, text: 'Batuk (lebih dari 2 minggu atau kurang dari 2 minggu)', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 2, text: 'Batuk berdarah', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 3, text: 'Demam', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 4, text: 'Berkeringat di malam hari tanpa aktivitas', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 5, text: 'Sesak napas', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 6, text: 'Nyeri dada', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 7, text: 'Nafsu makan menurun atau hilang selama berhari-hari', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 8, text: 'Mudah lelah atau sering merasa kecapekan tanpa aktivitas fisik yang berat', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 9, text: 'Berat badan turun drastis (bukan karena diet)', section: 'Gejala Fisik dan Keluhan'),
  SkriningQuestion(nomor: 10, text: 'Adanya bengkak di leher, bawah rahang, bawah telinga, atau ketiak', section: 'Gejala Fisik dan Keluhan'),
  // Riwayat Kontak dan Penularan
  SkriningQuestion(nomor: 11, text: 'Apakah ada anggota keluarga serumah yang sakit TBC?', section: 'Riwayat Kontak dan Penularan'),
  SkriningQuestion(nomor: 12, text: 'Apakah pernah berada dalam satu ruangan dengan penderita TBC (kantor, kelas, asrama, dll)?', section: 'Riwayat Kontak dan Penularan'),
  SkriningQuestion(nomor: 13, text: 'Apakah pernah tinggal serumah (minimal satu malam atau sering pada siang hari) dengan penderita TBC?', section: 'Riwayat Kontak dan Penularan'),
  // Riwayat Pengobatan dan Kondisi Kesehatan
  SkriningQuestion(nomor: 14, text: 'Pernah berobat TBC dan tuntas', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 15, text: 'Pernah berobat TBC tapi tidak tuntas', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 16, text: 'Memiliki riwayat penyakit Diabetes Melitus (kencing manis)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 17, text: 'Status sebagai Orang Dengan HIV', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 18, text: 'Sedang hamil (Ibu Hamil)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 19, text: 'Memiliki kebiasaan merokok', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 20, text: 'Status usia (0-14 tahun atau lansia di atas 60 tahun)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan'),
  SkriningQuestion(nomor: 21, text: 'Kondisi gizi (kurang gizi atau kurus)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan', autoFilled: true),
  SkriningQuestion(nomor: 22, text: 'Kurang Gizi (kurus)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan', autoFilled: true),
  SkriningQuestion(nomor: 23, text: 'Lansia (diatas 60 tahun)', section: 'Riwayat Pengobatan dan Kondisi Kesehatan', autoFilled: true),
];

// ─────────────────────────────────────────────
// Main Form Page
// ─────────────────────────────────────────────

class SkriningTbcFormPage extends StatefulWidget {
  const SkriningTbcFormPage({super.key});

  @override
  State<SkriningTbcFormPage> createState() => _SkriningTbcFormPageState();
}

class _SkriningTbcFormPageState extends State<SkriningTbcFormPage> {
  int _currentStep = 0; // 0=initial, 1=identity, 2=questionnaire, 3=preview

  // Step 0
  bool? _isSelf; // null=not chosen, true=Ya, false=Tidak
  final _namaCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  // For non-self (pelapor)
  final _pelaporNamaCtrl = TextEditingController();
  String? _pelaporKelompok;
  final _pelaporInstansiCtrl = TextEditingController();
  final _pelaporTeleponCtrl = TextEditingController();

  // Step 1 - Identity
  String? _jenisKelamin;
  final _teleponCtrl = TextEditingController();
  DateTime? _tanggalLahir;
  final _beratCtrl = TextEditingController();
  final _tinggiCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  String? _pekerjaan;
  String? _kabupatenKota;
  String? _kecamatan;
  String? _kelurahan;

  // Step 2 - Questions
  final Map<int, bool> _jawaban = {};

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nikCtrl.dispose();
    _pelaporNamaCtrl.dispose();
    _pelaporInstansiCtrl.dispose();
    _pelaporTeleponCtrl.dispose();
    _teleponCtrl.dispose();
    _beratCtrl.dispose();
    _tinggiCtrl.dispose();
    _alamatCtrl.dispose();
    super.dispose();
  }

  // Auto-fill logic for questions 21-23
  void _updateAutoFilledQuestions() {
    // Q21 & Q22: Kurang gizi based on BMI
    if (_beratCtrl.text.isNotEmpty && _tinggiCtrl.text.isNotEmpty) {
      final berat = double.tryParse(_beratCtrl.text) ?? 0;
      final tinggiCm = double.tryParse(_tinggiCtrl.text) ?? 0;
      if (berat > 0 && tinggiCm > 0) {
        final tinggiM = tinggiCm / 100;
        final bmi = berat / (tinggiM * tinggiM);
        _jawaban[21] = bmi < 18.5;
        _jawaban[22] = bmi < 18.5;
      }
    }
    // Q23: Lansia based on age
    if (_tanggalLahir != null) {
      final age = DateTime.now().difference(_tanggalLahir!).inDays ~/ 365;
      _jawaban[23] = age >= 60;
      // Also update Q20 for usia 0-14 or >= 60
      if (age <= 14 || age >= 60) {
        _jawaban[20] = true;
      }
    }
  }

  int _calculateUsia() {
    if (_tanggalLahir == null) return 0;
    return DateTime.now().difference(_tanggalLahir!).inDays ~/ 365;
  }

  double _calculateBMI() {
    final berat = double.tryParse(_beratCtrl.text) ?? 0;
    final tinggiCm = double.tryParse(_tinggiCtrl.text) ?? 0;
    if (berat <= 0 || tinggiCm <= 0) return 0;
    final tinggiM = tinggiCm / 100;
    return berat / (tinggiM * tinggiM);
  }

  bool _isTerminated() {
    // Count positive symptoms (questions 1-10)
    int symptomCount = 0;
    for (int i = 1; i <= 10; i++) {
      if (_jawaban[i] == true) symptomCount++;
    }
    // Count contact history (questions 11-13)
    int contactCount = 0;
    for (int i = 11; i <= 13; i++) {
      if (_jawaban[i] == true) contactCount++;
    }
    // Count risk factors (14-23)
    int riskCount = 0;
    for (int i = 14; i <= 23; i++) {
      if (_jawaban[i] == true) riskCount++;
    }
    // Terindikasi if has symptoms + (contact or risk factors)
    return symptomCount >= 2 || (symptomCount >= 1 && contactCount >= 1) || (symptomCount >= 1 && riskCount >= 2);
  }

  void _goNext() {
    if (_currentStep < 3) {
      if (_currentStep == 1) {
        _updateAutoFilledQuestions();
      }
      setState(() => _currentStep++);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitData() {
    final terindikasi = _isTerminated();
    final record = SkriningRecord(
      namaLengkap: _namaCtrl.text,
      nik: _nikCtrl.text,
      tanggal: DateTime.now(),
      terindikasi: terindikasi,
      identitas: {
        'jenisKelamin': _jenisKelamin,
        'telepon': _teleponCtrl.text,
        'tanggalLahir': _tanggalLahir,
        'usia': _calculateUsia(),
        'beratBadan': _beratCtrl.text,
        'tinggiBadan': _tinggiCtrl.text,
        'bmi': _calculateBMI(),
        'alamat': _alamatCtrl.text,
        'pekerjaan': _pekerjaan,
        'kabupatenKota': _kabupatenKota,
        'kecamatan': _kecamatan,
        'kelurahan': _kelurahan,
      },
      jawaban: Map.from(_jawaban),
    );
    riwayatSkrining.insert(0, record);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SkriningTbcHasilPage(
          terindikasi: terindikasi,
          namaLengkap: _namaCtrl.text,
          waktuSkrining: DateTime.now(),
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Data sudah sesuai?',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Pastikan data sudah sesuai, karena data yang dikirim tidak dapat diubah.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2979FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cek Ulang', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _submitData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Submit', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Skrining Mandiri (E-TIBI)', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () {
            if (_currentStep > 0) {
              _goBack();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _currentStep == 3 ? const Color(0xFF00897B) : const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Skrining Mandiri (E-TIBI)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentStep == 3 ? Colors.white : const Color(0xFF00897B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Semakin dini gejala TBC terdeteksi, maka semakin cepat diobati dan tidak menulari keluarga yang Anda sayangi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: _currentStep == 3 ? Colors.white70 : const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Step Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildStepContent(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep0();
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  // ─────────────────────────────────────────────
  // STEP 0: Initial Question
  // ─────────────────────────────────────────────
  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apakah anda melakukan skrining untuk diri sendiri?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildRadioChip('Ya', _isSelf == true, () => setState(() => _isSelf = true)),
            const SizedBox(width: 12),
            _buildRadioChip('Tidak', _isSelf == false, () => setState(() => _isSelf = false)),
          ],
        ),
        const SizedBox(height: 24),

        if (_isSelf == true) ..._buildSelfIdentity(),
        if (_isSelf == false) ..._buildNonSelfIdentity(),

        if (_isSelf != null) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_namaCtrl.text.isNotEmpty && _nikCtrl.text.isNotEmpty) ? _goNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
                disabledBackgroundColor: const Color(0xFFB2DFDB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Selanjutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],

        // Riwayat Skrining Section
        const SizedBox(height: 32),
        const Text('Riwayat Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 12),
        _buildRiwayatTable(),
      ],
    );
  }

  List<Widget> _buildSelfIdentity() {
    return [
      const Text('Masukkan Identitas Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      const SizedBox(height: 16),
      _buildTextField('Nama Lengkap', _namaCtrl, hint: 'Masukkan nama'),
      const SizedBox(height: 12),
      _buildTextField('NIK', _nikCtrl, hint: 'NIK harus 16 digit angka', keyboardType: TextInputType.number),
    ];
  }

  List<Widget> _buildNonSelfIdentity() {
    return [
      const Text('Data Pelapor', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      const SizedBox(height: 16),
      _buildTextField('Nama lengkap', _pelaporNamaCtrl, hint: 'Masukkan nama'),
      const SizedBox(height: 12),
      _buildDropdownField('Kelompok', _pelaporKelompok, kelompokList, (v) => setState(() => _pelaporKelompok = v)),
      const SizedBox(height: 12),
      _buildTextField('Nama Instansi', _pelaporInstansiCtrl, hint: 'Masukkan nama instansi'),
      const SizedBox(height: 12),
      _buildTextField('Nomor Telepon', _pelaporTeleponCtrl, hint: 'Masukkan nomor telepon', keyboardType: TextInputType.phone),
      const SizedBox(height: 24),
      const Text('Data yang Diskrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
      const SizedBox(height: 16),
      _buildTextField('Nama lengkap', _namaCtrl, hint: 'Masukkan nama'),
      const SizedBox(height: 12),
      _buildTextField('NIK', _nikCtrl, hint: 'NIK harus 16 digit angka', keyboardType: TextInputType.number),
    ];
  }

  // ─────────────────────────────────────────────
  // STEP 1: Detail Identity
  // ─────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lengkapi Identitas Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 16),

        // Jenis Kelamin
        const Text('Jenis Kelamin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRadioChip('Laki-laki', _jenisKelamin == 'Laki-laki', () => setState(() => _jenisKelamin = 'Laki-laki')),
            const SizedBox(width: 12),
            _buildRadioChip('Perempuan', _jenisKelamin == 'Perempuan', () => setState(() => _jenisKelamin = 'Perempuan')),
          ],
        ),
        const SizedBox(height: 16),

        _buildTextField('Nomor Telepon/HP', _teleponCtrl, hint: '08xxxxxxxxxx', keyboardType: TextInputType.phone),
        const SizedBox(height: 16),

        // Tanggal Lahir
        const Text('Tanggal Lahir', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _tanggalLahir ?? DateTime(2000, 1, 1),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
              locale: const Locale('id', 'ID'),
            );
            if (picked != null) setState(() => _tanggalLahir = picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _tanggalLahir != null ? DateFormat('d MMM yyyy', 'id_ID').format(_tanggalLahir!) : 'Masukkan tanggal lahir',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: _tanggalLahir != null ? const Color(0xFF1A1A1A) : const Color(0xFF9CA3AF),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildTextField('Berat Badan (kg)', _beratCtrl, hint: 'Cth: 60', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField('Tinggi Badan (cm)', _tinggiCtrl, hint: 'Cth: 170', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField('Alamat Domisili', _alamatCtrl, hint: 'Cth: Jl. Merdeka No. 20'),
        const SizedBox(height: 16),

        _buildSearchableDropdown('Pekerjaan', _pekerjaan, pekerjaanList, (v) => setState(() => _pekerjaan = v)),
        const SizedBox(height: 16),
        _buildSearchableDropdown('Kabupaten / Kota', _kabupatenKota, kabupatenKotaList, (v) {
          setState(() {
            _kabupatenKota = v;
            _kecamatan = null;
            _kelurahan = null;
          });
        }),
        const SizedBox(height: 16),
        _buildSearchableDropdown(
          'Kecamatan',
          _kecamatan,
          _kabupatenKota != null ? (kecamatanMap[_kabupatenKota] ?? []) : [],
          (v) {
            setState(() {
              _kecamatan = v;
              _kelurahan = null;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildSearchableDropdown(
          'Kelurahan / Desa',
          _kelurahan,
          _kecamatan != null ? (kelurahanMap[_kecamatan] ?? []) : [],
          (v) => setState(() => _kelurahan = v),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Selanjutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _goBack,
            child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF00897B))),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STEP 2: Screening Questionnaire
  // ─────────────────────────────────────────────
  Widget _buildStep2() {
    String? currentSection;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mulai Skrining Anda', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        const Text('Jawab pertanyaan berikut dengan jujur.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
        const SizedBox(height: 20),

        ...skriningQuestions.map((q) {
          final List<Widget> widgets = [];

          // Section header
          if (q.section != currentSection) {
            currentSection = q.section;
            widgets.add(
              Padding(
                padding: EdgeInsets.only(top: q.nomor == 1 ? 0 : 20, bottom: 12),
                child: Text(
                  q.section,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                ),
              ),
            );
          }

          final isDisabled = q.autoFilled;
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${q.nomor}. ${q.text}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isDisabled ? const Color(0xFF9CA3AF) : const Color(0xFF1A1A1A),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildYaTidakChip('Ya', _jawaban[q.nomor] == true, isDisabled
                        ? null
                        : () => setState(() => _jawaban[q.nomor] = true)),
                      const SizedBox(width: 12),
                      _buildYaTidakChip('Tidak', _jawaban[q.nomor] == false, isDisabled
                        ? null
                        : () => setState(() => _jawaban[q.nomor] = false)),
                    ],
                  ),
                ],
              ),
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          );
        }),

        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Selanjutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _goBack,
            child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF00897B))),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // STEP 3: Preview
  // ─────────────────────────────────────────────
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pratinjau Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        const Text('Periksa kembali data dan jawaban anda sebelum mengirim.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280))),
        const SizedBox(height: 20),

        // Skrining type
        _buildPreviewRow('Skrining untuk diri sendiri', _isSelf == true ? 'Ya' : 'Tidak'),
        const SizedBox(height: 16),

        // Data yang di Skrining
        const Text('Data yang di Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Divider(color: Color(0xFFE5E7EB)),
        _buildPreviewRow('Nama Lengkap', _namaCtrl.text),
        _buildPreviewRow('Nomor Induk Kependudukan (NIK)', _nikCtrl.text),
        _buildPreviewRow('Jenis Kelamin', _jenisKelamin ?? '-'),
        _buildPreviewRow('Nomor Telepon', _teleponCtrl.text.isEmpty ? '-' : _teleponCtrl.text),
        _buildPreviewRow('Tanggal Lahir', _tanggalLahir != null ? DateFormat('d MMM yyyy', 'id_ID').format(_tanggalLahir!) : '-'),
        _buildPreviewRow('Usia', _calculateUsia() > 0 ? '${_calculateUsia()} tahun' : '-'),
        _buildPreviewRow('Berat Badan', _beratCtrl.text.isEmpty ? '-' : '${_beratCtrl.text} kg'),
        _buildPreviewRow('Tinggi Badan', _tinggiCtrl.text.isEmpty ? '-' : '${_tinggiCtrl.text} cm'),
        _buildPreviewRow('Indeks Massa Tubuh', _calculateBMI() > 0 ? _calculateBMI().toStringAsFixed(1) : '-'),
        _buildPreviewRow('Alamat Domisili', _alamatCtrl.text.isEmpty ? '-' : _alamatCtrl.text),
        _buildPreviewRow('Pekerjaan', _pekerjaan ?? '-'),
        _buildPreviewRow('Kota/Kabupaten', _kabupatenKota ?? '-'),
        _buildPreviewRow('Kecamatan', _kecamatan ?? '-'),
        _buildPreviewRow('Kelurahan/Desa', _kelurahan ?? '-'),

        const SizedBox(height: 20),

        // Keluhan yang Dirasakan
        const Text('Keluhan yang Dirasakan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Divider(color: Color(0xFFE5E7EB)),
        ...skriningQuestions.where((q) => q.nomor <= 10).map(
          (q) => _buildPreviewRow(q.text, _jawaban[q.nomor] == true ? 'Ya' : 'Tidak'),
        ),

        const SizedBox(height: 20),

        // Informasi Lainnya
        const Text('Informasi Lainnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Divider(color: Color(0xFFE5E7EB)),
        ...skriningQuestions.where((q) => q.nomor > 10).map(
          (q) => _buildPreviewRow(q.text, _jawaban[q.nomor] == true ? 'Ya' : 'Tidak'),
        ),

        const SizedBox(height: 24),

        // Submit
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showConfirmDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2979FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Submit Data', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _goBack,
            child: const Text('Edit', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2979FF))),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Shared Widgets
  // ─────────────────────────────────────────────

  Widget _buildRadioChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00897B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF00897B) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYaTidakChip(String label, bool isSelected, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (label == 'Ya' ? const Color(0xFF00897B) : const Color(0xFFE8F5E9))
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (label == 'Ya' ? const Color(0xFF00897B) : const Color(0xFF43A047))
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 14,
              color: !enabled
                  ? const Color(0xFFBDBDBD)
                  : isSelected
                      ? (label == 'Ya' ? Colors.white : const Color(0xFF43A047))
                      : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: !enabled
                    ? const Color(0xFFBDBDBD)
                    : isSelected
                        ? (label == 'Ya' ? Colors.white : const Color(0xFF43A047))
                        : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF00897B))),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Pilih $label', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF))),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF1A1A1A)),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchableDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: items.isEmpty
              ? null
              : () async {
                  final result = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => _SearchableListSheet(title: label, items: items, selected: value),
                  );
                  if (result != null) onChanged(result);
                },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
              color: items.isEmpty ? const Color(0xFFF3F4F6) : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          value ?? 'Pilih $label',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: value != null ? const Color(0xFF1A1A1A) : const Color(0xFF9CA3AF),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (value != null) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => onChanged(null),
                          child: const Icon(Icons.close, size: 16, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
          ),
          const Text(' : ', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280))),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: value == 'Ya'
                    ? const Color(0xFF43A047)
                    : value == 'Tidak'
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatTable() {
    if (riwayatSkrining.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(
          child: Text('Belum ada riwayat skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9CA3AF))),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Table Header
            Container(
              color: const Color(0xFFF9FAFB),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: const Row(
                children: [
                  Expanded(flex: 2, child: Text('Tanggal Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                  Expanded(flex: 2, child: Text('Hasil Skrining', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                  Expanded(flex: 2, child: Text('Faskes', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                ],
              ),
            ),
            ...riwayatSkrining.take(5).map((r) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        DateFormat('dd MMMM yyyy', 'id_ID').format(r.tanggal),
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF1A1A1A)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: r.terindikasi ? const Color(0xFFFEE2E2) : const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          r.terindikasi ? 'Terindikasi TBC' : 'Tidak Terindikasi TBC',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: r.terindikasi ? const Color(0xFFEF4444) : const Color(0xFF43A047),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        r.faskes ?? '-',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Searchable List Bottom Sheet
// ─────────────────────────────────────────────

class _SearchableListSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selected;

  const _SearchableListSheet({required this.title, required this.items, this.selected});

  @override
  State<_SearchableListSheet> createState() => _SearchableListSheetState();
}

class _SearchableListSheetState extends State<_SearchableListSheet> {
  String _search = '';

  List<String> get _filtered {
    if (_search.isEmpty) return widget.items;
    return widget.items.where((i) => i.toLowerCase().contains(_search.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari...',
                hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF00897B))),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final item = _filtered[i];
                final isSelected = widget.selected == item;
                return ListTile(
                  dense: true,
                  title: Text(
                    item,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? const Color(0xFF00897B) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF00897B), size: 18) : null,
                  onTap: () => Navigator.pop(ctx, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
