// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/gallery_media_model.dart';

class GalleryRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<GalleryMediaModel>> getGalleryMedia() async {
    try {
      final response = await _apiClient.get(ApiConstants.getGallery);
      return (response.data as List)
          .map((item) => GalleryMediaModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch gallery media');
    }
  }

  Future<void> uploadMedia(String filename, String uploadedBy) async {
    try {
      await _apiClient.post(
        ApiConstants.uploadMedia,
        data: {
          'filename': filename,
          'uploaded_by': uploadedBy,
        },
      );
    } catch (e) {
      throw Exception('Failed to upload media');
    }
  }
}