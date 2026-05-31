import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Melakukan login dengan email dan password.
  /// Mengembalikan UserModel jika berhasil, atau melempar Exception jika gagal.
  Future<UserModel> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return UserModel(
        id: credential.user!.uid,
        email: credential.user!.email ?? email,
        name: credential.user!.displayName ?? email.split('@').first,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan saat login');
    }
  }

  /// Mendaftarkan user baru dengan email, password, dan menyimpan profil ke backend.
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
      // 1. Register di Firebase Auth
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // 2. Ambil ID Token
      String? idToken = await credential.user!.getIdToken();
      if (idToken == null) throw Exception('Gagal mendapatkan ID Token dari Firebase');

      // 3. Kirim data ke Backend Express.js
      // Catatan: Gunakan 10.0.2.2 jika di Android Emulator, atau localhost / IP lokal jika di Web/Windows/iOS
      final url = Uri.parse('http://127.0.0.1:3000/api/users/register'); 
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'email': email,
          'nama_depan': namaDepan,
          'nama_belakang': namaBelakang,
          'nomor_hp': nomorHp,
          'alamat': alamat,
          'nik': nik,
          'tanggal_lahir': tanggalLahir,
          'jenis_kelamin': jenisKelamin,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Gagal menyimpan profil di server: ${response.body}');
      }
      
      return UserModel(
        id: credential.user!.uid,
        email: credential.user!.email ?? email,
        name: namaDepan,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan saat pendaftaran');
    }
  }

  /// Melakukan login menggunakan Google Sign-In
  Future<UserModel> signInWithGoogle() async {
    try {
      // 1. Memunculkan popup Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Dibatalkan oleh pengguna');
      }

      // 2. Dapatkan token dari Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Buat kredensial Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in ke Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Gagal login ke Firebase');
      }

      // 5. Ambil Token Firebase untuk backend
      final String? firebaseIdToken = await user.getIdToken();
      if (firebaseIdToken == null) {
        throw Exception('Gagal mendapatkan Token Firebase');
      }

      // 6. Sinkronisasi dengan Backend (Membuat profil otomatis atau mengambil profil lama)
      final url = Uri.parse('http://127.0.0.1:3000/api/users/google-login'); 
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal sinkronisasi data dengan server');
      }

      final responseData = jsonDecode(response.body);
      final profileData = responseData['data'];

      bool isComplete = profileData['nik'] != null && profileData['nik'].toString().isNotEmpty;

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: profileData['nama_depan'] ?? user.displayName ?? '',
        isProfileComplete: isComplete,
      );

    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
