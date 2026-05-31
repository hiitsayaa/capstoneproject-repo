import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // Gunakan 10.0.2.2 untuk Emulator Android.
  // Jika menggunakan HP fisik, ganti dengan IP Address WiFi laptop Anda (misal: 192.168.1.5:3000)
  final String baseUrl = 'http://10.0.2.2:3000'; 

  /// Mendapatkan token yang tersimpan
  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  /// Mengekstrak profil user dari backend berdasarkan token saat ini
  Future<UserModel?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final url = Uri.parse('$baseUrl/profile/me');
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

  /// Melakukan login dengan email dan password.
  Future<UserModel> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
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
      final url = Uri.parse('$baseUrl/auth/register'); 
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'nama_lengkap': '$namaDepan $namaBelakang'.trim(),
          'nik': nik,
          // Backend Majadigi saat ini fokus pada 4 field utama di API contract
          // Field lainnya bisa di-update nanti via /profile/me
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

  /// Logout user
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }
}

