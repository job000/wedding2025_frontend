import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/faq_model.dart';

class FAQProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  List<FAQ> _faqs = [];
  bool _isLoading = false;
  String? _error;

  FAQProvider(this._apiClient) {
    fetchFAQs();
  }

  List<FAQ> get faqs => _faqs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFAQs() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiClient.get(ApiConstants.getFaqs);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _faqs = data.map((json) => FAQ.fromJson(json)).toList();
      } else {
        _error = AppConstants.genericError;
      }
    } catch (e) {
      _error = AppConstants.networkError;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFAQs() => fetchFAQs();
}