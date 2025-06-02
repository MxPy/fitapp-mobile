import 'package:fitapp_mobile/models/product.dart';
import 'package:fitapp_mobile/services/api_service.dart';
import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProduct(Product product, String userId) async {
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.createProduct(product, userId);
      await loadProducts(); // Odśwież listę
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}