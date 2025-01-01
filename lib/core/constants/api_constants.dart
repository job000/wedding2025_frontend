/// API-konstanter for bryllupsappen
class ApiConstants {
  ApiConstants._();

  // Base URL for API
  static const String baseUrl = 'http://localhost:5000';
  
  // Endpoint paths
  static const String _auth = '/auth';
  static const String _rsvp = '/rsvp';
  static const String _gallery = '/gallery';
  static const String _info = '/info';
  static const String _faq = '/faq';

  // Auth endpoints
  static const String login = '$_auth/login';
  static const String register = '$_auth/register';
  static const String profile = '$_auth/profile';

  // RSVP endpoints
  static const String getRsvps = _rsvp;
  static const String createRsvp = _rsvp;

  // Gallery endpoints
  static const String getGallery = _gallery;
  static const String uploadMedia = _gallery;

  // Info endpoints
  static const String getInfo = _info;
  static const String createInfo = _info;

  // FAQ endpoints
  static const String getFaqs = _faq;
  static const String createFaq = _faq;

  // HTTP Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // Timeout durations
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Error messages
  static const String connectionError = 'Kunne ikke koble til serveren';
  static const String noInternetError = 'Ingen internettforbindelse';
  static const String timeoutError = 'Forespørselen tok for lang tid';
  static const String unauthorizedError = 'Ikke autorisert';
  static const String serverError = 'Serverfeil';
}