// lib/features/rsvp/domain/repositories/rsvp_repository.dart

import '../../data/models/rsvp.dart';
import '../../../../core/errors/exceptions.dart';

abstract class RsvpRepository {
  /// Henter alle RSVPer fra backend.
  /// 
  /// Krever autentisering.
  /// Kaster [UnauthorizedException] hvis ikke autentisert.
  /// Kaster [ServerException] ved serverfeil.
  Future<List<RSVP>> getAllRsvps();

  /// Henter en spesifikk RSVP basert på ID.
  /// 
  /// Krever autentisering.
  /// Kaster [UnauthorizedException] hvis ikke autentisert.
  /// Kaster [NotFoundException] hvis RSVP ikke finnes.
  /// Kaster [ServerException] ved serverfeil.
  Future<RSVP> getRsvpById(int id);

  /// Oppretter en ny RSVP.
  /// 
  /// Krever ikke autentisering.
  /// Kaster [BadRequestException] ved ugyldig input.
  /// Kaster [ServerException] ved serverfeil.
  Future<RSVP> createRsvp({
    required String name,
    required String email,
    required bool attending,
    String? allergies,
  });

  /// Oppdaterer en eksisterende RSVP.
  /// 
  /// Krever autentisering.
  /// Kaster [UnauthorizedException] hvis ikke autentisert.
  /// Kaster [NotFoundException] hvis RSVP ikke finnes.
  /// Kaster [BadRequestException] ved ugyldig input.
  /// Kaster [ServerException] ved serverfeil.
  Future<RSVP> updateRsvp(
    int id, {
    String? name,
    String? email,
    bool? attending,
    String? allergies,
  });

  /// Sletter en RSVP basert på ID.
  /// 
  /// Krever autentisering.
  /// Kaster [UnauthorizedException] hvis ikke autentisert.
  /// Kaster [NotFoundException] hvis RSVP ikke finnes.
  /// Kaster [ServerException] ved serverfeil.
  Future<void> deleteRsvp(int id);
  
  /// Søker etter RSVPer basert på søkekriterier.
  /// 
  /// Krever autentisering.
  /// Kaster [UnauthorizedException] hvis ikke autentisert.
  /// Kaster [BadRequestException] ved ugyldige søkekriterier.
  /// Kaster [ServerException] ved serverfeil.
  Future<List<RSVP>> searchRsvps({
    String? query,
    bool? attending,
    DateTime? fromDate,
    DateTime? toDate,
  });
}