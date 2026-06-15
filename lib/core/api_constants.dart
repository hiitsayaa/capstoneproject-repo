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

  // Endpoint Bansos
  static const String bansosPrograms = '$baseUrl/bansos/programs';
  static const String bansosApply = '$baseUrl/bansos/apply';
  static const String bansosStatus = '$baseUrl/bansos/status';

  // Endpoint Emergency
  static const String emergencyRegions = '$baseUrl/emergency/regions';
  static const String emergencyContacts = '$baseUrl/emergency/contacts';

  // Endpoint Hoaks
  static const String hoaksArticles = '$baseUrl/hoaks/articles';
  static const String hoaksReport = '$baseUrl/hoaks/report';

  // Endpoint Islamic Center
  static const String islamicCenterFacilities = '$baseUrl/islamic-center/facilities';
  static const String islamicCenterBookings = '$baseUrl/islamic-center/bookings';

  // Endpoint Point Jatim
  static const String pointJatimProjects = '$baseUrl/point-jatim/projects';
  static const String pointJatimSubmissions = '$baseUrl/point-jatim/submissions';

  // Endpoint TBC Screening
  static const String tbcQuestions = '$baseUrl/tbc-screening/questions';
  static const String tbcFaskes = '$baseUrl/tbc-screening/faskes';
  static const String tbcRecords = '$baseUrl/tbc-screening/records';

  // Endpoint Tickets
  static const String tickets = '$baseUrl/tickets';
}
