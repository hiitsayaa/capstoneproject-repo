import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  static UserModel? currentUser;
  bool isLoading = false;
  String? errorMessage;

  /// Memulihkan sesi pengguna yang sudah login sebelumnya (jika ada token)
  Future<bool> tryResumeSession() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        currentUser = user;
        isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}

    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      currentUser = user;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
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
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.register(
        email: email,
        password: password,
        namaDepan: namaDepan,
        namaBelakang: namaBelakang,
        nomorHp: nomorHp,
        alamat: alamat,
        nik: nik,
        tanggalLahir: tanggalLahir,
        jenisKelamin: jenisKelamin,
      );
      currentUser = user;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    errorMessage = 'Fitur Login Google tidak didukung oleh backend Majadigi saat ini.';
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser = null;
    notifyListeners();
  }
}
