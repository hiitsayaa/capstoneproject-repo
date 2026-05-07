import 'package:flutter/material.dart';

class DataDiriPage extends StatefulWidget {
  const DataDiriPage({super.key});

  @override
  State<DataDiriPage> createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  String? _jenisKelamin = 'laki-laki';
  String? _pendidikan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0050CB),
        foregroundColor: Colors.white,
        title: const Text(
          'Pengisian Data',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE1E2EE),
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: Color(0xFFC2C6D8),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
                ),
                child: const Text('Pilih Foto'),
              ),
              const SizedBox(height: 32),

              // Form Section
              _buildTextField('Nama Lengkap', 'Masukkan nama lengkap'),
              const SizedBox(height: 16),
              
              // Jenis Kelamin
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jenis Kelamin', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF424656))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Laki-laki', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                          value: 'laki-laki',
                          groupValue: _jenisKelamin,
                          onChanged: (value) => setState(() => _jenisKelamin = value),
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF0050CB),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Perempuan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                          value: 'perempuan',
                          groupValue: _jenisKelamin,
                          onChanged: (value) => setState(() => _jenisKelamin = value),
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF0050CB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField('Email', 'Masukkan email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              
              // Tanggal Lahir
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tanggal Lahir', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF424656))),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      // Handle picked date if necessary
                    },
                    decoration: InputDecoration(
                      hintText: 'Pilih tanggal',
                      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF727687)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF0050CB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF727687), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField('NIK', 'Masukkan NIK', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              
              // Alamat
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alamat', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF424656))),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Masukkan alamat lengkap',
                      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF727687)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF0050CB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField('No. Telepon', 'Masukkan nomor telepon', keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('NPWP', 'Masukkan NPWP'),
              const SizedBox(height: 16),
              _buildTextField('No. BPJS', 'Masukkan No. BPJS'),
              const SizedBox(height: 16),
              _buildTextField('No. KK', 'Masukkan No. KK'),
              const SizedBox(height: 16),

              // Pendidikan Terakhir
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pendidikan Terakhir', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF424656))),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _pendidikan,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF0050CB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    hint: const Text('Pilih pendidikan terakhir', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF727687))),
                    items: const [
                      DropdownMenuItem(value: 'sma', child: Text('SMA/Sederajat', style: TextStyle(fontFamily: 'Poppins', fontSize: 14))),
                      DropdownMenuItem(value: 'd3', child: Text('D3', style: TextStyle(fontFamily: 'Poppins', fontSize: 14))),
                      DropdownMenuItem(value: 's1', child: Text('S1', style: TextStyle(fontFamily: 'Poppins', fontSize: 14))),
                      DropdownMenuItem(value: 's2', child: Text('S2', style: TextStyle(fontFamily: 'Poppins', fontSize: 14))),
                      DropdownMenuItem(value: 's3', child: Text('S3', style: TextStyle(fontFamily: 'Poppins', fontSize: 14))),
                    ],
                    onChanged: (value) => setState(() => _pendidikan = value),
                    icon: const Icon(Icons.expand_more, color: Color(0xFF727687)),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF424656))),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF727687)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC2C6D8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF0050CB)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
