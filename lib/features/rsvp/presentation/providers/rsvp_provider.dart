// lib/features/rsvp/presentation/providers/rsvp_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

class RsvpProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Kall for å lage en ny RSVP.
  /// Krever ikke token ifølge backend – dvs. åpen for alle.
  Future<void> createRsvp({
    required String name,
    required String email,
    required bool attending,
    String? allergies,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiClient.post(
        // Endpoint: /rsvp
        ApiConstants.getRsvps,
        data: {
          'name': name,
          'email': email,
          'attending': attending,
          'allergies': allergies ?? '',
        },
        options: Options(
          headers: {
            // Ingen auth header nødvendig for POST /rsvp
            ApiConstants.contentType: ApiConstants.applicationJson,
          },
        ),
      );

      if (response.statusCode == 201) {
        // Alt vel. Du kan evt. parse 'rsvp' fra response.data hvis du vil
      } else {
        // Noen feilmeldinger? Legg dem i _error
        final data = response.data;
        if (data is Map && data.containsKey('message')) {
          _setError(data['message'].toString());
        } else {
          _setError('Kunne ikke sende RSVP (ukjent feil).');
        }
      }
    } on DioException catch (e) {
      // Håndter DioException
      _handleError(e);
    } catch (e) {
      // Andre typer feil
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Evt. flere metoder for å hente/oppdatere/slette RSVP – disse krever token ifølge backend

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  void _handleError(DioException e) {
    // Forenklet feil-håndtering:
    if (e.response?.data is Map && e.response?.data['message'] != null) {
      _setError(e.response?.data['message'].toString());
    } else if (e.message != null) {
      _setError(e.message);
    } else {
      _setError('Ukjent feil');
    }
  }
}
