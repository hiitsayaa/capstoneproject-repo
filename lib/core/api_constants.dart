class ApiConstants {
  // Menggunakan 127.0.0.1 karena kita menggunakan jalur kabel USB (adb reverse)
  // static const String baseUrl = 'http://127.0.0.1:3000';

  //Menghubungkan aplikasi Flutter di emulator Android ke server backend (localhost) yang berjalan di laptop
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Endpoint Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String profile = '$baseUrl/profile/me';
  static const String favorites = '$baseUrl/profile/favorites';

  // Endpoint Gateway
  static const String features = '$baseUrl/gateway/features';

  // Endpoint Bapenda
  static const String bapendaVehiclesMe = '$baseUrl/bapenda/vehicles/me';
  static const String bapendaPkbCheck = '$baseUrl/bapenda/pkb/check';
  static const String bapendaPkbPay = '$baseUrl/bapenda/pkb/pay';
  static const String bapendaPkbPayments = '$baseUrl/bapenda/pkb/payments';
  static const String bapendaNjkb = '$baseUrl/bapenda/njkb';

  // Endpoint RSUD
  static const String rsudHospitals = '$baseUrl/rsud/hospitals';
  static const String rsudHospital = '$baseUrl/rsud'; // Base for :hospitalId
}
