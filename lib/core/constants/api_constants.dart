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
  static const String getUsers = '$_auth/users';
  static String updateUser(String username) => '$_auth/users/$username';
  static String deleteUser(String username) => '$_auth/users/$username';

  // RSVP endpoints
  static const String getRsvps = _rsvp;
  static const String createRsvp = _rsvp;
  static String getRsvpById(int id) => '$_rsvp/$id';
  static String updateRsvp(int id) => '$_rsvp/$id';
  static String deleteRsvp(int id) => '$_rsvp/$id';

  // Gallery endpoints
  static const String getGallery = '$_gallery/media';  // Updated to match API spec
  static const String uploadMedia = '$_gallery/upload';
  static const String searchGallery = '$_gallery/search';
  static const String getAlbums = '$_gallery/albums';
  static const String createAlbum = '$_gallery/albums';
  static String getAlbumById(int id) => '$_gallery/albums/$id';
  static String updateAlbum(int id) => '$_gallery/albums/$id';
  static String deleteAlbum(int id) => '$_gallery/albums/$id';
  static String getMediaById(int id) => '$_gallery/media/$id';
  static String updateMedia(int id) => '$_gallery/media/$id';
  static String deleteMedia(int id) => '$_gallery/media/$id';
  static String addComment(int mediaId) => '$_gallery/media/$mediaId/comments';
  static String likeMedia(int mediaId) => '$_gallery/media/$mediaId/like';

  // Info endpoints
  static const String getInfo = _info;
  static const String createInfo = _info;
  static String getInfoById(int id) => '$_info/$id';
  static String updateInfo(int id) => '$_info/$id';
  static String deleteInfo(int id) => '$_info/$id';

  // FAQ endpoints
  static const String getFaqs = _faq;
  static const String createFaq = _faq;
  static String getFaqById(int id) => '$_faq/$id';
  static String updateFaq(int id) => '$_faq/$id';
  static String deleteFaq(int id) => '$_faq/$id';

  // HTTP Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
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
  static const String unexpectedError = 'En uventet feil oppstod';
  static const String invalidResponseFormat = 'Ugyldig responsformat fra serveren';

  // Add these new cache control constants
  static const String cacheControl = 'Cache-Control';
  static const String noCache = 'no-cache, no-store, must-revalidate';
}