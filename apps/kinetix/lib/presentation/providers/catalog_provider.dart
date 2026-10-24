import 'package:flutter/material.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/enums/product_category.dart';
import '../../domain/enums/product_sort.dart';

class CatalogProvider extends ChangeNotifier {
  final ProductRepository _productRepository;

  CatalogProvider(this._productRepository) {
    loadProducts();
  }

  /// Products in the order the repository returned them (relevance).
  List<Product> _products = [];

  /// [_products] ordered by [_sort]; recomputed only when either changes.
  List<Product> _sortedProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  ProductCategory _selectedCategory = ProductCategory.all;
  String _searchQuery = '';
  ProductSort _sort = ProductSort.relevance;
  Product? _selectedProduct;

  List<Product> get products => _sortedProducts;
  ProductSort get sort => _sort;
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
      _sortedProducts = _sortProducts(_products, _sort);
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

  /// Reorders the already filtered list; does not hit the repository.
  void selectSort(ProductSort sort) {
    if (_sort == sort) return;
    _sort = sort;
    _sortedProducts = _sortProducts(_products, _sort);
    notifyListeners();
  }

  /// Stable sort: products with the same price keep their original order.
  static List<Product> _sortProducts(List<Product> products, ProductSort sort) {
    if (sort == ProductSort.relevance) return List.unmodifiable(products);
    final indexed = products.indexed.toList()
      ..sort((a, b) {
        final byPrice = switch (sort) {
          ProductSort.priceLowToHigh => a.$2.price.compareTo(b.$2.price),
          ProductSort.priceHighToLow => b.$2.price.compareTo(a.$2.price),
          ProductSort.relevance => 0,
        };
        return byPrice != 0 ? byPrice : a.$1.compareTo(b.$1);
      });
    return List.unmodifiable(indexed.map((entry) => entry.$2));
  }

  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }
}
