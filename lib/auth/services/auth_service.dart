import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../../core/api_constants.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Mendapatkan token yang tersimpan
  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  /// Mengekstrak profil user dari backend berdasarkan token saat ini
  Future<UserModel?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final url = Uri.parse(ApiConstants.profile);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool isComplete = data['nik'] != null && data['nik'].toString().isNotEmpty;
        return UserModel(
          id: data['id']?.toString() ?? '1',
          email: data['email'] ?? '',
          name: data['nama_lengkap'] ?? 'Pengguna',
          isProfileComplete: isComplete,
        );
      } else {
        // Token mungkin kedaluwarsa
        await logout();
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Mengekstrak seluruh profil mentah untuk halaman Data Diri
  Future<Map<String, dynamic>?> getFullProfile() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final url = Uri.parse(ApiConstants.profile);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Melakukan login dengan email dan password.
  Future<UserModel> login(String email, String password) async {
    try {
      final url = Uri.parse(ApiConstants.login);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        
        // Simpan token ke storage
        await _storage.write(key: 'access_token', value: token);
        
        // Ambil profil
        final user = await getCurrentUser();
        if (user != null) return user;
        throw Exception('Gagal mendapatkan profil pengguna');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Email atau password salah');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Mendaftarkan user baru
  Future<UserModel> register({
    required String email,
    required String password,
    required String namaDepan,
    required String namaBelakang,
    required String nomorHp,
    required String alamat,
    required String nik,
    required String tanggalLahir,
    required String jenisKelamin,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.register); 
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'nama_lengkap': '$namaDepan $namaBelakang'.trim(),
          'nik': nik,
          'tempat_lahir': 'Belum Diisi', // Temporary fallback, but UI should provide it if we have it? Wait, the API doesn't require them but user filled them?
          // Let's check what the register method parameters are...
          // required String namaDepan, required String namaBelakang, required String nomorHp, required String alamat, required String nik, required String tanggalLahir, required String jenisKelamin
          'telepon': nomorHp,
          'alamat_lengkap': alamat,
          'tanggal_lahir': tanggalLahir.isNotEmpty ? tanggalLahir : null,
          'jenis_kelamin': jenisKelamin.isNotEmpty ? jenisKelamin : null,
        }),
      );

      if (response.statusCode == 201) {
        // Otomatis login setelah register berhasil
        return await login(email, password);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mendaftar');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Melakukan login menggunakan Google Sign-In (Dihapus sementara)
  Future<UserModel> signInWithGoogle() async {
    throw Exception('Fitur Login Google saat ini belum didukung oleh server Majadigi');
  }

  /// Update profil user
  Future<void> updateProfile({
    String? namaLengkap,
    String? tempatLahir,
    String? tanggalLahir,
    String? jenisKelamin,
    String? telepon,
    String? alamatLengkap,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('Tidak ada token');

    try {
      final url = Uri.parse(ApiConstants.profile);
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (namaLengkap != null) 'nama_lengkap': namaLengkap,
          if (tempatLahir != null) 'tempat_lahir': tempatLahir,
          if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
          if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
          if (telepon != null) 'telepon': telepon,
          if (alamatLengkap != null) 'alamat_lengkap': alamatLengkap,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal memperbarui profil');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }
}

