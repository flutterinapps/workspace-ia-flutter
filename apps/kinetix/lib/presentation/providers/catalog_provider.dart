import 'package:flutter/material.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/enums/product_category.dart';

class CatalogProvider extends ChangeNotifier {
  final ProductRepository _productRepository;

  CatalogProvider(this._productRepository) {
    loadProducts();
  }

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  ProductCategory _selectedCategory = ProductCategory.all;
  String _searchQuery = '';
  Product? _selectedProduct;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProductCategory get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  Product? get selectedProduct => _selectedProduct;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.getProducts(
        category: _selectedCategory,
        searchQuery: _searchQuery,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(ProductCategory category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadProducts();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    loadProducts();
  }

  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }
}
